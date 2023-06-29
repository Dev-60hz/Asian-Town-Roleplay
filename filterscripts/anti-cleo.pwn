#include <a_samp>
#include <sampvoice>
#include <foreach>
#include <Pawn.CMD>

#define SCM 	SendClientMessage
#define SMA 	SendMessageToAll // SendClientMessageToAll with string formats
#define 	COLOR_LIGHTRED      0xFF6347FF
#define SERVER_BOT       "AT:RP"

stock SendMessageToAll(color, const text[], {Float,_}:...)
{
	static
  	    args,
	    str[192];

	if((args = numargs()) <= 2)
	{
	    foreach(new i : Player)
	    {
		    SCM(i, color, str);
		}
	}
	else
	{
		while(--args >= 2)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 		text
		#emit PUSH.C 		192
		#emit PUSH.C 		str
		#emit LOAD.S.pri 	8
		#emit ADD.C 		4
		#emit PUSH.pri
		#emit SYSREQ.C 		format
		#emit LCTRL 		5
		#emit SCTRL 		4

		foreach(new i : Player)
	    {
		    SCM(i, color, str);
		}

		#emit RETN
	}
	return 1;
}

stock GetPlayerNameEx(playerid)
{
	new	name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	for(new i = 0, l = strlen(name); i < l; i ++)
	{
	    if(name[i] == '_')
	    {
	        name[i] = ' ';
		}
	}
	return name;
}

public OnGameModeInit()
{
    printf("——————————————————");
    printf("|");
    printf("|");
    printf("|.    Anti Cleo key by !60hz#3524");
    printf("|");
    printf("|");
    printf("——————————————————");
    return 1;
}

CMD:fskin(playerid, params[])
{
	SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Skin Changer", GetPlayerNameEx(playerid), SERVER_BOT);
	Kick(playerid);
	return 1;
}

CMD:salo(playerid, params[])
{
	SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Silent Aim", GetPlayerNameEx(playerid), SERVER_BOT);
	Kick(playerid);
	return 1;
}

CMD:cbug(playerid, params[])
{
	SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Auto C-Bug", GetPlayerNameEx(playerid), SERVER_BOT);
	Kick(playerid);
	return 1;
}

CMD:enablecjrun(playerid, params[])
{
	SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: CJ Run", GetPlayerNameEx(playerid), SERVER_BOT);
	Kick(playerid);
	return 1;
}

CMD:speedhack(playerid, params[])
{
	SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Speed Hack", GetPlayerNameEx(playerid), SERVER_BOT);
	Kick(playerid);
	return 1;
}

CMD:fspawn(playerid, params[])
{
	SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Bot Spawner", GetPlayerNameEx(playerid), SERVER_BOT);
	Kick(playerid);
	return 1;
}

CMD:antiautokick(playerid, params[])
{
	SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Anti auto kick hacks", GetPlayerNameEx(playerid), SERVER_BOT);
	Kick(playerid);
	return 1;
}

CMD:sex(playerid, params[]) return callcmd::invis(playerid, params);
CMD:invis(playerid, params[])
{
	SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Invisible", GetPlayerNameEx(playerid), SERVER_BOT);
	Kick(playerid);
	return 1;
}

CMD:ddcrash(playerid, params[]) return callcmd::xcrash(playerid, params);
CMD:vcrash(playerid, params[]) return callcmd::xcrash(playerid, params);
CMD:crash(playerid, params[]) return callcmd::xcrash(playerid, params);
CMD:fcrash(playerid, params[]) return callcmd::xcrash(playerid, params);
CMD:kenzo(playerid, params[]) return callcmd::xcrash(playerid, params);
CMD:xcrash(playerid, params[])
{
	SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Auto Crasher", GetPlayerNameEx(playerid), SERVER_BOT);
	Kick(playerid);
	return 1;
}

CMD:mrxpawn(playerid, params[]) return callcmd::menu(playerid, params);
CMD:cmode(playerid, params[]) return callcmd::menu(playerid, params);
CMD:skema(playerid, params[]) return callcmd::menu(playerid, params);
CMD:menu(playerid, params[])
{
	SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: General Hack", GetPlayerNameEx(playerid), SERVER_BOT);
	Kick(playerid);
	return 1;
}

CMD:xprip(playerid, params[]) return callcmd::whack(playerid, params);
CMD:pgun(playerid, params[]) return callcmd::whack(playerid, params);
CMD:xgun(playerid, params[]) return callcmd::whack(playerid, params);
CMD:whack(playerid, params[])
{
	SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Weapon Hack", GetPlayerNameEx(playerid), SERVER_BOT);
	Kick(playerid);
	return 1;
}