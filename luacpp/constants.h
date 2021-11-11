#pragma once

#define BASE_DIR "/EDGELUA"
#define SHM_VAR 1
#define GLOBAL_LUA_MIX_VAR __Sw2MixerValue

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
#define CFG_StateTimeout 3
#define CFG_ScrollUdId 4
#define CFG_ScrollLrId 5
#define CFG_ParamaterDialId 6
#define CFG_PageSwitchId 7
#define CFG_RemoteId 8
#define CFG_Encoding 9
#define CFG_MixerGlobalVariable 10
#define CFG_PreviousLsId 11
#define CFG_NextLsId 12
#define CFG_SelectLsId 13
#define CFG_Backend 14
#define CFG_SafeMode_FlightMode 15
#define CFG_SafeMode_Timeout 16
#define CFG_SafeMode_LinkDropoutMax 17
#define CFG_SafeMode_LsNumber 18
#define CFG_Footer 19

#define MENUDATA_Title 1
#define MENUDATA_Footer 2

#define PAGEDATA_Title 1

#define MENUSTATE_Row 1
#define MENUSTATE_Col 2
#define MENUSTATE_Page 3
#define MENUSTATE_SelRow 4
#define MENUSTATE_SelCol 5

#define ITEM_Name 1
#define ITEM_States 2
#define ITEM_State 3
#define ITEM_Function 4
#define ITEM_Module 5
#define ITEM_Export 6
#define ITEM_Virtual 7
#define ITEM_Rects 8

#define OVERLAY_SwitchID 1
#define OVERLAY_Item 2
#define OVERLAY_LSMode 3
#define OVERLAY_LastValue 4

#define SHORTCUT_SwitchID 1
#define SHORTCUT_Item 2
#define SHORTCUT_LSMode 3
#define SHORTCUT_LastValue 4

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
#define FSMADR_STATE_Initial 0
#define FSMADR_STATE_Output 1

#define FSMSWITCH_LastTime 1
#define FSMSWITCH_State 2
#define FSMSWITCH_CyclePage 3
#define FSMSWITCH_CycleRow 4

#define FSMCONF_LastTime 1
#define FSMCONF_State 2
#define FSMCONF_Row 3

#define FSMCONF_STATE_Wait 0
#define FSMCONF_STATE_BCastOff 1
#define FSMCONF_STATE_SelectOn 2
#define FSMCONF_STATE_SendValue 3
#define FSMCONF_STATE_End 4

#define FSMRSSI_State 1
#define FSMRSSI_LastTime 2

#define FSMRSSI_STATE_SafeMode 0
#define FSMRSSI_STATE_WaitUp 1
#define FSMRSSI_STATE_Normal 2
#define FSMRSSI_STATE_WaitDown 3