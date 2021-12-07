#pragma once

//#define DEBUG 

// #define TEST1

#define USE_DEPRECATED

#define USE_VALUE_STORAGE

// can query "t5u", ..., "sl1".."sl62" as switch-source
//#define USE_TRIM_NAMES // only for color/edgetx (own patch)
#define USE_GETSWITCHID // (PR 1154) getSwitchIndex("L01"), ... 
#define USE_CHAR_CONSTANTS // (PR 1169)
#define USE_SHM // only for color/edgetx (PR 1018)
#define USE_LS_STICKY // (PR 1056)
#define USE_MODEL_FILENAME // (PR 1132)
#define USE_FUNCTION_NAMES

#define USE_FALLBACK_IDS

#define USE_BACKEND_BUS
#define USE_BACKEND_SPORT
#define USE_BACKEND_TIPTIP
#define USE_BACKEND_SOLEXPERT

#define LSFUNC_A_EQ_X 1
#define LSFUNC_A_GT_X 3

#define TRIMS_MODE_DISABLE_TRIM 31

#include "version.h"
#include "constants.h"
#include "macros.h"

