# pokeemerald-tempered

`pokeemerald-tempered` is built on [pokeemerald-expansion](https://github.com/rh-hideout/pokeemerald-expansion).
The current goal is an enhanced "Emerald Plus" experience, which will serve as the foundation for larger gameplay systems added to this project later.
This document lists every change made to upstream's defaults and the reasoning behind each one.

## Design goals

- **Modern mechanics:** battle, Pokémon, and item mechanics follow upstream's latest-generation defaults unless noted below.
- **Quality of life:** upstream features that make the game smoother to play are turned on where they fit Emerald.
- **Expert difficulty:** the game is tuned for the intended **Expert** experience.
  A **Normal** (vanilla) mode and a way to choose between them are planned for later; see [Difficulty](#difficulty).

## How changes are marked

Settings changed from upstream keep their original comment, prefixed with `[tempered]` and the upstream value:

```c
#define I_REUSABLE_TMS  TRUE  // [tempered] upstream: FALSE. In Gens5-8, TMs are reusable. ...
```

## Config review status

| Header | Status |
|--------|--------|
| `ai.h` | Reviewed: 7 changes |
| `battle.h` | Pending |
| `caps.h` | Pending |
| `contest.h` | Pending |
| `debug.h` | Pending |
| `dexnav.h` | Pending |
| `fishing.h` | Pending |
| `follower_npc.h` | Pending |
| `general.h` | Pending |
| `item.h` | Pending |
| `map_preview_screen.h` | Pending |
| `name_box.h` | Pending |
| `overworld.h` | Pending |
| `pokedex_plus_hgss.h` | Pending |
| `pokemon.h` | Pending |
| `pokerus.h` | Pending |
| `quickstart.h` | Pending |
| `save.h` | Pending |
| `species_enabled.h` | Pending |
| `summary_screen.h` | Pending |
| `test.h` | Pending |
| `text.h` | Pending |
| `wild_encounter.h` | Pending |

## Changes

In the tables below, **Difficulty** marks changes that are part of Expert difficulty, and **Save** marks changes that make older save files incompatible.

<details>
<summary><code>ai.h</code>: 7 changes. Trainers heal, switch and use priority moves more reliably.</summary>

Upstream uses chances below 100% for many AI decisions so the AI isn't perfectly predictable. Where we raised a chance, we aimed for about two-thirds: smarter, but still not fully predictable.
The four switching changes only apply to trainers with Smart Switching AI.

| Config | Upstream | Tempered | Motivation | Difficulty | Save |
|--------|----------|----------|------------|------------|------|
| `SHOULD_SWITCH_FREE_TURN_PERCENTAGE` | 50 | 66 | Switching while the player is mid-Fly/Dig or charging a move is nearly free, and it only happens when the AI is losing the matchup and has a good switch-in. | Yes | No |
| `SHOULD_SWITCH_BADLY_POISONED_PERCENTAGE` | 50 | 66 | Toxic damage keeps growing and switching resets it, so switching is usually the right call. | Yes | No |
| `SHOULD_SWITCH_CURSED_PERCENTAGE` | 50 | 66 | Curse takes a quarter of max HP every turn and switching removes it. | Yes | No |
| `SHOULD_SWITCH_INTIMIDATE_PERCENTAGE` | 25 | 33 | A little more Intimidate pressure from bosses, kept low to avoid tedious switching back and forth. | Yes | No |
| `SHOULD_RECOVER_CHANCE` | 50 | 100 | When it's safe, the AI always heals below 60% HP instead of half the time. Healing to survive a KO was already guaranteed. | Yes | No |
| `PRIORITIZE_LAST_CHANCE_CHANCE` | 50 | 100 | When the AI is slower and about to be knocked out, it always uses a priority move, rather than a stronger move it won't live to use. | Yes | No |
| `LAST_MON_PREFERS_NOT_SACRIFICE` | FALSE | TRUE | A trainer's last Pokémon avoids Explosion or Final Gambit, which would hand the player the win. | Yes | No |

One upstream test, *"AI's Explosion scoring handles multiple move effects and the Explosion defense config"* in `test/battle/ai/ai.c`, now skips when `LAST_MON_PREFERS_NOT_SACRIFICE` is TRUE, like the three similar tests next to it.

</details>

## Flags and vars in use

| Flag/Var | Used by | Purpose |
|----------|---------|---------|

## Code changes

Changes outside the config headers, needed to switch some settings on.

_None yet._

## Difficulty

The current settings implement **Expert** difficulty.
A future **Normal** mode would undo or switch off each change marked as a Difficulty change above.
This table notes how each Expert setting could become switchable in-game.

| Expert setting | How it's set now | How Normal mode could switch it off |
|----------------|------------------|-------------------------------------|
| AI switching chances (`ai.h`: free turn, Toxic, Curse, Intimidate) | Config values | All switch chances are read through `GetSwitchChance` in `src/battle_ai_switch.c`, which upstream marks as the place to vary them by difficulty; return the upstream values in Normal mode. |
| AI healing, priority and self-KO choices (`ai.h`: `SHOULD_RECOVER_CHANCE`, `PRIORITIZE_LAST_CHANCE_CHANCE`, `LAST_MON_PREFERS_NOT_SACRIFICE`) | Config values | Read directly where used in `src/battle_ai_main.c` and `src/battle_ai_util.c`; replace each use with a small helper that returns the upstream value in Normal mode. |

### Planned for later

- Normal (vanilla) difficulty mode.
- Choosing a difficulty in-game, e.g. at the start of a new game.
- Expert-specific trainer teams, using upstream's `B_VAR_DIFFICULTY`.
- Stronger trainer AI: give Gym Leaders, the Elite Four, the Champion, rivals, Team Aqua/Magma leaders and admins, Cooltrainers, Experts, Dragon Tamers, Old Couples, the Winstrates and Pokémon Rangers Smart Trainer AI, and everyone else Basic Trainer AI.
  Open questions:
  - Whether bosses should know all of the player's moves, abilities and items ("Omniscient"), only what they've seen, or a random subset.
  - Whether the AI should switch out of matchups it would lose (`SHOULD_SWITCH_LOSES_1V1_PERCENTAGE`, currently 0).
