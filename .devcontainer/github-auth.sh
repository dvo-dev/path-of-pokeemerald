#!/usr/bin/env bash

[[ $- == *i* && -t 0 ]] || return 0

_devcontainer_github_auth() {
    local restore_xtrace=false credentials key value token=''

    case $- in
        *x*) restore_xtrace=true; set +x ;;
    esac

    if [[ -z ${GH_TOKEN:-} && -z ${GITHUB_TOKEN:-} ]]; then
        if credentials="$(
            printf 'protocol=https\nhost=github.com\n\n' |
                GIT_TERMINAL_PROMPT=0 GIT_ASKPASS=/bin/false \
                SSH_ASKPASS=/bin/false GCM_INTERACTIVE=never \
                timeout 10s git -c credential.interactive=false credential fill 2>/dev/null
        )"; then
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
            printf '%s\n' \
                'GitHub authentication unavailable: no forwarded credential was retrieved.' \
                'On the host, authenticate gh and run: gh auth setup-git --hostname github.com' \
                'Then reopen the devcontainer in VS Code and start a new terminal.' >&2
        fi
    fi

    if [[ $restore_xtrace == true ]]; then
        set -x
    fi
    return 0
}

_devcontainer_github_auth
unset -f _devcontainer_github_auth
