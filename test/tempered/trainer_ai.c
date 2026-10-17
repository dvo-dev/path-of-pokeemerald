#include "global.h"
#include "data.h"
#include "tempered/trainer_ai.h"
#include "constants/battle_ai.h"
#include "test/test.h"

// IDs from test/battle/trainer_control.party and test/battle/partner_control.party.
#define TEST_TRAINER_RIVAL      1
#define TEST_TRAINER_BLACK_BELT 14
#define PARTNER_STEVEN_TEST     1

TEST("Tempered trainer AI: smart trainer classes get Smart Trainer AI")
{
    ASSUME(GetTrainerClassFromId(TEST_TRAINER_RIVAL) == TRAINER_CLASS_RIVAL);
    EXPECT(Tempered_GetExtraTrainerAiFlags(TEST_TRAINER_RIVAL) == AI_FLAG_SMART_TRAINER);
}

TEST("Tempered trainer AI: other trainer classes get Basic Trainer AI")
{
    ASSUME(GetTrainerClassFromId(TEST_TRAINER_BLACK_BELT) == TRAINER_CLASS_BLACK_BELT);
    EXPECT(Tempered_GetExtraTrainerAiFlags(TEST_TRAINER_BLACK_BELT) == AI_FLAG_BASIC_TRAINER);
}

TEST("Tempered trainer AI: in-game partners follow the trainer class rule")
{
    ASSUME(GetTrainerClassFromId(TRAINER_PARTNER(PARTNER_STEVEN_TEST)) == TRAINER_CLASS_RIVAL);
    EXPECT(Tempered_GetExtraTrainerAiFlags(TRAINER_PARTNER(PARTNER_STEVEN_TEST)) == AI_FLAG_SMART_TRAINER);
}
