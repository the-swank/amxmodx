#ifndef NS_H
#define NS_H


#include <extdll.h>
#include <string.h>
#include "amxxmodule.h"
#include "ns_const.h"
#include "CPlayer.h"
#include "CSpawn.h"
#include "CCallList.h"
#include "utilfunctions.h"

extern CSpawn ns_spawnpoints;


extern BOOL iscombat;
extern CPlayer g_player[33];
extern edict_t *player_edicts[33]; // Stupid INDEXENT() bug.

extern int gmsgHudText2;


extern int gmsgShowMenu;

extern AMX_NATIVE_INFO ns_misc_natives[];
extern AMX_NATIVE_INFO ns_menu_natives[];
extern AMX_NATIVE_INFO ns_pdata_natives[];



extern int ChangeclassForward;
extern int BuiltForward;


////////////////////////////////



#endif // NS_H