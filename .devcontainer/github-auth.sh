#!/usr/bin/env bash
# Gives the gh CLI the same GitHub auth that git already has in this container.
#
# VS Code forwards the host's git credential helper into the devcontainer, so
# `git push` works, but gh keeps its own separate login and is unauthenticated.
# This script asks git for the forwarded credential and exports it as GH_TOKEN.
#
# It's sourced from ~/.bashrc (see Dockerfile) rather than run once at build or
# postCreate time because the forwarded helper only works while VS Code is
# connected. Keeping the token in the environment also avoids writing it to
# disk (as `gh auth login` would) inside the container.

# Only run in a real interactive terminal. Non-interactive shells (scripts,
# tasks) and interactive shells without a TTY (e.g. tooling that probes the
# environment via `bash -i`) shouldn't trigger a credential lookup. This uses
# `return`, not `exit`, because the file is sourced into the user's shell.
[[ $- == *i* && -t 0 ]] || return 0

# Wrapped in a function so `local` keeps the token and parsing variables out of
# the user's shell; only GH_TOKEN is intentionally exported.
_devcontainer_github_auth() {
    local restore_xtrace=false credentials key value token=''

    # If tracing (`set -x`) is on, the token would be printed in the trace
    # output. Disable it for the duration and restore it at the end.
    case $- in
        *x*) restore_xtrace=true; set +x ;;
    esac

    # Respect an existing token. gh reads both variables, and some environments
    # (e.g. Codespaces) already set GITHUB_TOKEN.
    if [[ -z ${GH_TOKEN:-} && -z ${GITHUB_TOKEN:-} ]]; then
        # Use `git credential fill` instead of calling a specific helper, so this
        # works with whatever helper git is configured to use (normally VS Code's
        # forwarder). The input is git's key=value protocol, ending with a blank line.
        #
        # If no credential exists, git falls back to prompting. That would block
        # shell startup or open a VS Code input box through its GIT_ASKPASS.
        # Every prompt path is disabled: terminal, askpass, SSH askpass, and Git
        # Credential Manager. `timeout` covers a host helper that never responds,
        # and stderr is suppressed to keep helper noise out of new terminals.
        if credentials="$(
            printf 'protocol=https\nhost=github.com\n\n' |
                GIT_TERMINAL_PROMPT=0 GIT_ASKPASS=/bin/false \
                SSH_ASKPASS=/bin/false GCM_INTERACTIVE=never \
                timeout 10s git -c credential.interactive=false credential fill 2>/dev/null
        )"; then
            # Parse the response in pure bash, which avoids exposing the token to
            # extra processes like grep or sed. With IFS='=', `read` splits only on
            # the first '=', so `value` gets the rest of the line even if the token
            # contains '='. The token is in the `password` field.
            while IFS='=' read -r key value; do
                if [[ $key == password && -n $value ]]; then
                    token=$value
                    break
                fi
            done <<< "$credentials"
        fi

        if [[ -n $token ]]; then
            export GH_TOKEN="$token"
        else
            # The forwarder only passes along what the host's git can provide, so
            # the fix is on the host: make gh the git credential helper there. The
            # forwarded helper is picked up when the container connects, and this
            # script runs per shell, so reconnect and open a new terminal.
            printf '%s\n' \
                'GitHub authentication unavailable: no forwarded credential was retrieved.' \
                'On the host, authenticate gh and run: gh auth setup-git --hostname github.com' \
                'Then reopen the devcontainer in VS Code and start a new terminal.' >&2
        fi
    fi

    if [[ $restore_xtrace == true ]]; then
        set -x
    fi
    # Always succeed so an auth failure never disrupts ~/.bashrc or leaves a
    # non-zero $? at the first prompt.
    return 0
}

# Run once, then remove the function so it doesn't stay in the user's shell.
_devcontainer_github_auth
unset -f _devcontainer_github_auth
