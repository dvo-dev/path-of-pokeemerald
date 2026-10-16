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
| `ai.h` | Pending |
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

_No changes yet._

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

### Planned for later

- Normal (vanilla) difficulty mode.
- Choosing a difficulty in-game, e.g. at the start of a new game.
- Expert-specific trainer teams, using upstream's `B_VAR_DIFFICULTY`.
