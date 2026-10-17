#include "global.h"
#include "data.h"
#include "tempered/trainer_ai.h"
#include "constants/battle_ai.h"
#include "constants/trainers.h"

// Expert difficulty: bosses and strong regular trainers use expansion's Smart Trainer AI,
// everyone else uses Basic Trainer AI. In-game partners (e.g. Steven) follow the same rule.
// See TEMPERED.md.
static bool32 IsSmartTrainerClass(enum TrainerClassID trainerClass)
{
    switch (trainerClass)
    {
    case TRAINER_CLASS_LEADER:
    case TRAINER_CLASS_ELITE_FOUR:
    case TRAINER_CLASS_CHAMPION:
    case TRAINER_CLASS_RIVAL:
    case TRAINER_CLASS_AQUA_LEADER:
    case TRAINER_CLASS_MAGMA_LEADER:
    case TRAINER_CLASS_AQUA_ADMIN:
    case TRAINER_CLASS_MAGMA_ADMIN:
    case TRAINER_CLASS_COOLTRAINER:
    case TRAINER_CLASS_COOLTRAINER_2:
    case TRAINER_CLASS_EXPERT:
    case TRAINER_CLASS_DRAGON_TAMER:
    case TRAINER_CLASS_OLD_COUPLE:
    case TRAINER_CLASS_WINSTRATE:
    case TRAINER_CLASS_PKMN_RANGER:
        return TRUE;
    default:
        return FALSE;
    }
}

u64 Tempered_GetExtraTrainerAiFlags(u16 trainerId)
{
    if (IsSmartTrainerClass(GetTrainerClassFromId(trainerId)))
        return AI_FLAG_SMART_TRAINER;

    return AI_FLAG_BASIC_TRAINER;
}
