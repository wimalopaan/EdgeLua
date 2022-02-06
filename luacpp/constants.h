#pragma once

#define BASE_DIR "/EDGELUA"
#define SHM_VAR 1
#define SHM_VMAP_VAR 2
#define GLOBAL_LUA_MIX_VAR   __Sw2MixerValue
#define GLOBAL_LUA_MIX_VMAP_VAR   __Sw2MixerValueVmap
#define GLOABL_LUA_CONFIG    __WmSw2Config
#define GLOBAL_LUA_STOP_MASK __stopWmSw2
// #define GLOBAL_LUA_FOREIGN   __WmSw2ForeignInput
#define GLOBAL_LUA_Queue     __WmSw2ForeignInputQueue
#define GLOABL_LUA_WARN1     __WmSw2Warning1
#define GLOBAL_LUA_WARN2     __WmSw2Warning2

#define STOPMASK_CONFIG 1
#define STOPMASK_ADRESS 2

#define EVENT_X9E_MENU 96
#define EVENT_X9E_EXIT 97

#define W_X 1
#define W_Y 2
#define W_Width 3
#define W_Height 4
#define W_FontHeight 5
#define W_YOffset 6
#define W_YPOffset 7
#define W_FontHSmall 8
#define W_FontHLarge 9
#define W_Zone 10
#define W_Options 11

#define CFG_Title 1
#define CFG_FirstColWidth 2
// #define CFG_StateTimeout 3
#define CFG_ScrollUdId 4
#define CFG_ScrollLrId 5
#define CFG_ParamaterDialId 6
#define CFG_PageSwitchId 7
#define CFG_RemoteId 8
#define CFG_Encoding 9
// #define CFG_MixerGlobalVariable 10
#define CFG_PreviousLsId 11
#define CFG_NextLsId 12
#define CFG_SelectLsId 13
#define CFG_Backend 14
#define CFG_SafeMode_FlightMode 15
#define CFG_SafeMode_Timeout 16
#define CFG_SafeMode_LinkDropoutMax 17
#define CFG_SafeMode_LsNumber 18
#define CFG_Footer 19
#define CFG_Backend_Data 20

#define MIXCFG_Backend 1
#define MIXCFG_Backend_Data 2

#define CFG_BEND_Bus 1
#define CFG_BEND_SPort 2
#define CFG_BEND_TipTip 3
#define CFG_BEND_SolExpert 4

#define BEND_BUS_StateTimeout 1
#define BEND_BUS_MixerGlobalVariable 2
#define BEND_BUS_ExportValues 3
#define BEND_BUS_ExportMixerGlobalVariable 4

#define BEND_BUS_DEFAULT_MixerGlobalVariable 5
#define BEND_BUS_DEFAULT_StateTimeout 20

//#define BEND_SPORT_

#define BEND_TIPTIP_ShortTimeout  1
#define BEND_TIPTIP_LongTimeout   2
#define BEND_TIPTIP_MixerGlobalVariable  3
#define BEND_TIPTIP_Values  4
#define BEND_TIPTIP_DEFAULT_ShortTimeout 30 
#define BEND_TIPTIP_DEFAULT_LongTimeout 90 
#define BEND_TIPTIP_DEFAULT_MixerGlobalVariable 7 

#define BEND_SOLEXPERT_ShortTimeout 1
#define BEND_SOLEXPERT_LongTimeout 2
#define BEND_SOLEXPERT_Map 3
#define SOLEXPERT_MENT_Module 1
#define SOLEXPERT_MENT_Channel 2
#define SOLEXPERT_MENT_Values 3

#define MENUDATA_Title 1
#define MENUDATA_Footer 2

#define PAGEDATA_Title 1

#define MENUSTATE_Row 1
#define MENUSTATE_Col 2
#define MENUSTATE_Page 3
#define MENUSTATE_SelRow 4
#define MENUSTATE_SelCol 5
#ifdef USE_VALUE_STORAGE
# define MENUSTATE_Dirty 6
#endif

#define ITEM_Name 1
#define ITEM_States 2
#define ITEM_State 3
#define ITEM_Function 4
#define ITEM_Module 5
#define ITEM_Export 6
#define ITEM_Virtual 7
#define ITEM_Rects 8
#define ITEM_AutoReset 9
#define ITEM_AutoResetTime 10

#define PUSHED_ITEM_Item 1
#define PUSHED_ITEM_BeforeState 2

#define OVERLAY_SwitchID 1
#define OVERLAY_Item 2
#define OVERLAY_LSMode 3

#define SHORTCUT_SwitchID OVERLAY_SwitchID
#define SHORTCUT_Item OVERLAY_Item
#define SHORTCUT_LSMode OVERLAY_LSMode

#define SWITCHES_LastValue 1

#define SWITCH_ThreshPos  680
#define SWITCH_ThreshNeg -680

#define PHEADER_Title 1
#define PHEADER_Module 2
#define PHEADER_LinesStart 3

#define PHITEM_Name 1
#define PHITEM_ParamId 2

#define PITEM_Name 1
#define PITEM_Function 2
#define PITEM_Module 3

#define PLINE_Item 1
#define PLINE_Values 2
#define PLINE_Line 3
#define PLINE_Rects ITEM_Rects

#define ANIM_Name 1
#define ANIM_Length 2
#define ANIM_Transitions 3

#define ANIM_TRANS_Function 1
#define ANIM_TRANS_Module 2
#define ANIM_TRANS_State 3
#define ANIM_TRANS_Time 4
#define ANIM_TRANS_Done 5

// #define ANIM_StateDurations 4

// #define ASTATEPOINT_Function 1
// #define ASTATEPOINT_Module 2
// #define ASTATEPOINT_TimeStates 3

// #define ATIMESTATE_Time 1
// #define ATIMESTATE_State 2
// #define ATIMESTATE_Done 3

// #define ASTATEDUR_Function 1
// #define ASTATEDUR_Module 2
// #define ASTATEDUR_DurationStates 3

// #define ADURSTATE_Duration 1
// #define ADURSTATE_State 2
// #define ADURSTATE_Done 3

#define FSMANIM_LastTime 1
#define FSMANIM_State 2
#define FSMANIM_StartTime 3
#define FSMANIM_LastSwitch 4
#define FSMANIM_ActiveAnim 5
//#define FSMANIM_Selection 6
//#define FSMANIM_LastReached 7
#define FSMANIM_CursorRow 8

#define ALLFSMS_STATE_Init 0

#define FSMANIM_STATE_Init ALLFSMS_STATE_Init
#define FSMANIM_STATE_Run 1

#define REMOTE_LastValue  1
#define REMOTE_Module  2
#define REMOTE_Function  3
#define REMOTE_State  4

#define BUTTONS_PREV 1
#define BUTTONS_NEXT 2
#define BUTTONS_SELECT 3
#define BUTTONS_MENUSELECT 4
#define BUTTONS_SLIDER_UD 5
#define BUTTONS_SLIDER_LR 6

#define FSMADR_State 1
#define FSMADR_STATE_Initial ALLFSMS_STATE_Init
#define FSMADR_STATE_Output 1

#define FSMSWITCH_LastTime 1
#define FSMSWITCH_State 2
#define FSMSWITCH_CyclePage 3
#define FSMSWITCH_CycleRow 4

#define FSMTIP_LastTime 1
#define FSMTIP_State 2
#define FSMTIP_ActualCount 3
#define FSMTIP_ActualChannel 4
#define FSMTIP_ActualPulse 5
#define FSMTIP_Busy 6

#define FSMTIP_STATE_Idle ALLFSMS_STATE_Init
#define FSMTIP_STATE_On 1
#define FSMTIP_STATE_Off 2
#define FSMTIP_STATE_Last 3
#define FSMTIP_STATE_End 4

#define FSMCONF_LastTime 1
#define FSMCONF_State 2
#define FSMCONF_Row 3

#define FSMCONF_STATE_Wait ALLFSMS_STATE_Init
#define FSMCONF_STATE_BCastOff 1
#define FSMCONF_STATE_SelectOn 2
#define FSMCONF_STATE_SendValue 3
#define FSMCONF_STATE_End 4

#define FSMRSSI_State 1
#define FSMRSSI_LastTime 2

#define FSMRSSI_STATE_SafeMode ALLFSMS_STATE_Init
#define FSMRSSI_STATE_WaitUp 1
#define FSMRSSI_STATE_Normal 2
#define FSMRSSI_STATE_WaitDown 3

#define DEBUG_TEXT_Radio 1
#define DEBUG_TEXT_TrimSwitchId 2
#define DEBUG_TEXT_GetSwitchId 3
#define DEBUG_TEXT_GetFieldSL 4
#define DEBUG_TEXT_Shm 5
#define DEBUG_TEXT_StickySwitch 6
#define DEBUG_TEXT_Version 7
#define DEBUG_TEXT_ValueStorage 8
#define DEBUG_TEXT_Filename 9
#define DEBUG_TEXT_StringOption 10
#define DEBUG_TEXT_FuncNames 11

#define REMOTE_SW_Name 1
#define REMOTE_SW_thresh 2
#define REMOTE_SW_map 3
#define REMOTE_SW_fn 4
#define REMOTE_SW_module 5
#define REMOTE_SW_Id 6
