#pragma once

// activates TRACE macros: set via make
// #define DEBUG 

// inactivates soem extra feature for small radios (T12): set via make
// #define SELECT_TINY

#ifdef SELECT_TINY 
#define USE_BACKEND_BUS
#define INCLUDE_SAFEMODE
#else
#define INCLUDE_ANIMATIONS
#define INCLUDE_COLOR_FUNCTIONS
#define INCLUDE_SAFEMODE
#define INCLUDE_VIRTUAL_SWITCHES
#define INCLUDE_EXPORT
#define INCLUDE_AUTORESET
#define USE_BACKEND_BUS
#define USE_BACKEND_SPORT
#define USE_BACKEND_TIPTIP
#define USE_BACKEND_SOLEXPERT
#define USE_VALUE_STORAGE
#endif

#define USE_DEPRECATED

// can query "t5u", ..., "sl1".."sl62" as switch-source
//#define USE_TRIM_NAMES // only for color/edgetx (own patch)
#define USE_GETSWITCHID // (PR 1154) getSwitchIndex("L01"), ... 
#define USE_CHAR_CONSTANTS // (PR 1169)
#define USE_SHM // only for color/edgetx (PR 1018)
#define USE_LS_STICKY // (PR 1056)
#define USE_MODEL_FILENAME // (PR 1132)
#define USE_FUNCTION_NAMES // (PR 1223)
#define USE_NEW_STRING_OPTION // (PR 1218)

#define USE_FALLBACK_IDS


// fallback IDs for functions
#define LSFUNC_A_EQ_X 1
#define LSFUNC_A_GT_X 3
#define LSFUNC_STICKY 18

#define TRIMS_MODE_DISABLE_TRIM 31

#include "version.h"
#include "constants.h"
#include "macros.h"

