#pragma once

#define DEBUG 

// #define TEST1

#define USE_VALUE_STORAGE

// can query "t5u", ..., "sl1".."sl62" as switch-source
#define USE_TRIM_NAMES // only for color/edgetx (PR)

#define USE_SHM // only for color/edgetx (PR)

//#define USE_LS_STICKY // patch

#define LSFUNC_A_EQ_X 1
#define LSFUNC_A_GT_X 3

#define TRIMS_MODE_DISABLE_TRIM 31

#include "version.h"
#include "constants.h"
#include "macros.h"
