////////////////////////////////////////////////////////////////////////////////
//////////////////// Egg Hunt Script by: UnuAlex ///////////////////////////////
////////////////////////////////////////////////////////////////////////////////



#include <a_samp>
#include <streamer>
#include <YSI\y_iterate>
#include <YSI\y_commands>
#include <YSI\y_master>
#include <sscanf2>
#pragma disablerecursion

#pragma dynamic 500000

//Defines \/
#define MAX_EGGS 1000 //The max ammount of eggs you can create
#define EGG_HUNT_TIME 600 //10 Minutes

#define TP_INT 0 // TP Interior definer
#define TP_VW 0 //TP Virtual World definer

#define SCM SendClientMessage

#define c_warn    0xDE6767FF
#define c_cmd     0xE9AE49FF
#define c_result  0x6AE949FF
#define c_result2 0x409929FF
#define c_help    0xA5ADB5FF

#define m_admin "(!) You don't have permission to use this command!"

#define ADMIN_REQ true //Set to false for debugging
#define JOIN_TP true //Set this to false if don't want the players teleported to the island.
					 //This is usefull if you want to hold the events in other places. Eg. Los Santos

#define function%0(%1)         forward %0(%1); public %0(%1)

/////// OBJS VARS ///////
new wallstimer;
new bool:wstate;
new mwall[12];

new pltftimer;
new bool:pstate;
new platform[5];

new para[3];

new respawn_cp[4];
new Float:cp_pos[4][4] = { //Checkpoints Coords
{3524.8550,1510.4786,7.4436,356.3898},
{3682.1006,1561.1146,43.8394,299.8094},
{3726.7073,1563.4187,86.2033,268.2850},
{3801.8669,1574.1094,54.0434,270.0658}
};
new respawn_timer[MAX_PLAYERS];

new Float:tp_pos[] = { 3524.8223,1505.5803,7.4436, 360.0 };//Teleportation Coords

/////// DB VARIABLE ///////
new DB:eggs_db;


/////// EGGY VARS ///////
enum eggs //Egg data
{
	emodel,
	Float:posx,
	Float:posy,
	Float:posz,
	bool:valid
};

new egg_info[MAX_EGGS][eggs];
new Egg[MAX_EGGS];
new eggcount;
new Text3D:EggLabel[MAX_EGGS];
new bool:eggLabels;

/////// EGG HUNT VARS ///////
new bool:EggHunt;
new ehTime;
new ehTimer;

new bool:atEggHunt[MAX_PLAYERS];
new pEggs[MAX_PLAYERS];
new pSpawn[MAX_PLAYERS];
new PlayerText:EggHUD[3];

enum rankingEnum
{
    player_Score,
    player_ID
}

///////////////////////////EGG HUNT COMMANDS////////////////////////////////////

CMD:eh(playerid, params[])
{
	new opt[32];
	if(sscanf(params,"s[32]",opt))
	{
		SCM(playerid, c_cmd, "[EH] - Type:/eh [option]");
		SCM(playerid, c_help, "Options: join, leave, respawn, reset, help.");
		if(IsPlayerAdmin(playerid))
		{
		    SCM(playerid, c_cmd,  "______________ADMIN COMMANDS_______________");
		    SCM(playerid, c_help, "Event: start, stop.");
			SCM(playerid, c_help, "Egg Editing: /cegg, /degg, /epos, /elabels.");
		}
		return 1;
	}
	if(isnull(opt))
	{
	    SCM(playerid, c_cmd, "[EH] - Type:/eh [option]");
		SCM(playerid, c_help, "Options: join, leave, respawn, reset, help.");
		if(IsPlayerAdmin(playerid))
		{
		    SCM(playerid, c_cmd,  "______________ADMIN COMMANDS_______________");
		    SCM(playerid, c_help, "Event: start, stop.");
			SCM(playerid, c_help, "Egg Editing: /cegg, /degg, /epos, /elabels.");
		}
		return 1;
	}
	
	if(strmatch(opt,"start"))
	{
 		#if ADMIN_REQ == true
		if(!IsPlayerAdmin(playerid))return SCM(playerid,c_warn, m_admin);
		#endif

		if(EggHunt)return SCM(playerid, c_warn, "(!) The Egg Hunt event is already started! Use /eh stop to force stop it.");

		EggHunt = true; //Turn Event On
		if(eggLabels) EggLabels(false);//Hide labels if shown

		//Clear Vars For Everyone;
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				ClearVars(i);
			}
		}

		//Start The Timers
	    ehTime = EGG_HUNT_TIME;
		ehTimer = SetTimer("EggHuntTimer",1000,true);
		wallstimer = SetTimer("MoveWalls",2000,true);
		pltftimer = SetTimer("MovePlatforms",17000, true);

		//Feedback
		new msg[128];
		format(msg, sizeof(msg),"[Event]: The Egg Hunt event has started! You have %d minutes to get as manny eggs as possible!", EGG_HUNT_TIME/60);
		SendClientMessageToAll(c_result, msg);
		SendClientMessageToAll(c_result2, "Notice: Join this event by typing '/eh join'. Use '/eh help' to see all commands!");
		
		PlaySoundForAll(1057);
	}
	else if(strmatch(opt,"stop"))
	{
	    #if ADMIN_REQ == true
		if(!IsPlayerAdmin(playerid))return SCM(playerid,c_warn, m_admin);
		#endif

		if(!EggHunt)return SCM(playerid, c_warn, "(!) The Egg Hunt event is not started! Use /eh start to start it now.");

		EggHunt = false;//Turn Event Off
		ehTime = 0;
		ResetEggs();

		//Clear Vars For Everyone;
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i) && atEggHunt[i])
			{
			    #if JOIN_TP == true
			    SpawnPlayer(i);
			    #endif
				ClearVars(i);
				EggHuntHUD(i);
			}
		}

  	    //Kill Timers
		KillTimer(ehTimer);
		KillTimer(wallstimer);
		KillTimer(pltftimer);

		//Feedback
		new msg[128];
		format(msg, sizeof(msg),"[Event]: Admin %s has cancelled the Egg Hunt event.", pname(playerid));
		SendClientMessageToAll(c_cmd, msg);
		
		PlaySoundForAll(1058);
	}
	else if(strmatch(opt,"join"))
	{
	    if(!EggHunt)return SCM(playerid, c_warn, "(!) The Egg Hunt event isn't active at the moment!");
	    if(atEggHunt[playerid])return SCM(playerid, c_warn, "(!) You're already at the Egg Hunt event! Use /eh leave if you want to leave.");
	    
	    atEggHunt[playerid] = true;//Joining event
	    //pEggs[playerid] = 0; //Optional (If you uncomment this, the players that leave, and then re-join the event will lose their egg count)
	    
	    #if JOIN_TP == true
	    //Teleporting Player
	    SetPlayerPos(playerid,tp_pos[0],tp_pos[1],tp_pos[2]);
	    SetPlayerFacingAngle(playerid,tp_pos[3]);
	    SetCameraBehindPlayer(playerid);
	    SetPlayerInterior(playerid, TP_INT);
	    SetPlayerVirtualWorld(playerid, TP_VW);
		ResetPlayerWeapons(playerid);
	    #endif
	    
	    //Textdraws
		EggHuntHUD(playerid);
	    
	    //Feedback
	    new msg[128];
	    format(msg, sizeof(msg),"[EH] - Welcome to Egg Hunt %s! Try to collect as many eggs as possible.", pname(playerid));
	    SCM(playerid, c_result, msg);
	    SCM(playerid, c_result2, "Notice: Use '/eh help' to see all the commands available.");
	    
		PlayerPlaySound(playerid,6401 ,0,0,0);
	}
	else if(strmatch(opt,"leave"))
	{
	    if(!EggHunt)return SCM(playerid, c_warn, "(!) The Egg Hunt event isn't active at the moment!");
	    if(!atEggHunt[playerid])return SCM(playerid, c_warn, "(!) You aren't participating at this event! Use /eh join to join in.");
	    
	    atEggHunt[playerid] = false;//Leave event (Comment this line if you want your players to join only once)
	    //pEggs[playerid] = 0;
	    
	    //Textdraws
		EggHuntHUD(playerid);
	    
	    #if JOIN_TP == true
	    //Respawn player
	    SpawnPlayer(playerid);
	    #endif
	    
	    //Feedback
	    SCM(playerid, c_result, "[EH] - You left the Egg Hunt event. Thank you for participating!");
	    PlayerPlaySound(playerid,1058,0,0,0);
	}
	else if(strmatch(opt,"respawn"))
	{
	    if(!EggHunt)return SCM(playerid, c_warn, "(!) The Egg Hunt event isn't active at the moment!");
	    if(!atEggHunt[playerid])return SCM(playerid, c_warn, "(!) You aren't participating at this event! Use /eh join to join in.");
	    
	    #if JOIN_TP == true
	    //Spawn Player
	    DelaySpawn(playerid);
	    
	    //Message
	    SCM(playerid, c_result, "[EH] - You've been respawned!");
	    PlayerPlaySound(playerid,1058,0,0,0);
	    
	    #else
	    SCM(playerid, c_cmd,"[EH] - You can't be respawned right now.");
	    
	    #endif
	}
	else if(strmatch(opt,"reset"))
	{
	    if(!EggHunt)return SCM(playerid, c_warn, "(!) The Egg Hunt event isn't active at the moment!");
	    if(!atEggHunt[playerid])return SCM(playerid, c_warn, "(!) You aren't participating at this event! Use /eh join to join in.");

	    #if JOIN_TP == true
	    //Spawn Player
     	pSpawn[playerid] = 0;
	    DelaySpawn(playerid);

	    //Message
	    SCM(playerid, c_result, "[EH] - Your respawn has been reset!");
	    PlayerPlaySound(playerid,1058,0,0,0);

	    #else
	    SCM(playerid, c_cmd,"[EH] - You can't be respawned right now.");

	    #endif
	}
	else if(strmatch(opt,"help"))
	{
	    SCM(playerid, c_result,"___________Egg Hunt Commands___________");
	    SCM(playerid, c_help,  "join - Join the egg hunt event.");
	    SCM(playerid, c_help,  "leave - Leave the egg hunt event and lose the egg points.");
	    SCM(playerid, c_help,  "respawn - Respawn at the last checkpoint you got in.");
	    SCM(playerid, c_help,  "reset - This will reset your spawn at the first checkpoint.");
	    if(IsPlayerAdmin(playerid))
	    {
	        SCM(playerid, c_help,"start - This commands starts the Egg Hunt.");
	        SCM(playerid, c_help,"stop - This will forcefully stop the Egg Hunt with no winner.");
	        SCM(playerid, c_result,"___________Egg Editor Commands___________");
	        SCM(playerid, c_help,"/cegg - Creates a new EGG.");
	        SCM(playerid, c_help,"/degg - Deletes a specified EGG by using the eggid.");
	        SCM(playerid, c_help,"/epos - Relocates a specified EGG at your position.");
	        SCM(playerid, c_help,"/elabels - Displays the labes that indicate the EGG ids.");
	        SCM(playerid, c_help,"/gotoeh - Teleports you to the island.");
	    }
	}
	else SCM(playerid, c_warn, "(!) This option doesn't exist or its not available!");
	return 1;
}

/////////////////////////// EGG HUNT FUNCTIONS//////////////////////////////////

function EggHuntHUD(playerid)
{
	if(atEggHunt[playerid])
	{
	    //Display TD's
	    PlayerTextDrawShow(playerid, EggHUD[0]);
	    PlayerTextDrawShow(playerid, EggHUD[1]);
	    PlayerTextDrawShow(playerid, EggHUD[2]);
	}
	else
	{
	    //Hide TD's
	    PlayerTextDrawHide(playerid, EggHUD[0]);
	    PlayerTextDrawHide(playerid, EggHUD[1]);
	    PlayerTextDrawHide(playerid, EggHUD[2]);
	}
	return 1;
}

////////////////////////// EGGY FUNCTIONS //////////////////////////////////////

function DeleteEgg(eggid)
{
	//Destroy objects
	DestroyDynamicPickup(Egg[eggid]);
	if(IsValidDynamic3DTextLabel(EggLabel[eggid])) DestroyDynamic3DTextLabel(EggLabel[eggid]);
	
	//Erase database row
	new Query[64];
	format(Query,sizeof(Query),"DELETE FROM `eggs` WHERE `eggid` = '%d'",eggid);
	db_free_result(db_query(eggs_db,Query));
	
	//Reset Variable
	egg_info[eggid][valid] = false;
	
	eggcount --;
	return 1;
}



function CreateEgg(Float:eposx, Float:eposy, Float:eposz)
{
    new query[48], DBResult:res;
    for(new i=1; i < MAX_EGGS; i++)
	{
 		format(query,sizeof(query),"SELECT * FROM `eggs` WHERE `eggid` = '%d'",i);
        res = db_query(eggs_db,query);

		new lbl_text[16], rnd,  rnd_model;
        if(!db_num_rows(res))
        {
            //Attribute random egg model
            
			rnd = random(2);
			if(rnd == 0) rnd_model = 19344;
			else rnd_model = 19345;
			//Create egg pickup & label
            Egg[i] = CreateDynamicPickup(rnd_model, 1, eposx, eposy, eposz, -1, -1, -1, 100);
            egg_info[i][valid] = true;
            
            if(eggLabels)//Create the label only if labels are visible
			{
	            format(lbl_text, sizeof(lbl_text),"EggID: %d", i);
	            EggLabel[i] = CreateDynamic3DTextLabel(lbl_text, -1, eposx, eposy, eposz, 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 100);
   			}
            
            //Save data
            egg_info[i][emodel] = rnd_model, egg_info[i][posx] = eposx, egg_info[i][posy] = eposy, egg_info[i][posz] = eposz;
            new equery[128];
			format(equery,sizeof(equery),"INSERT INTO `eggs` (`eggid`,`model`,`posx`,`posy`,`posz`) VALUES('%d','%d','%f','%f','%f')",
			i, egg_info[i][emodel], egg_info[i][posx], egg_info[i][posy], egg_info[i][posz]);
			db_free_result(db_query(eggs_db,equery));
			
			eggcount ++;
            break;
        }
        db_free_result(res);
	}
	return 1;
}

function LoadEggs()
{
	//Opening EggHunt Database & Creating the Tables
    eggs_db = db_open("egghunt.db");
	db_free_result(db_query(eggs_db,"CREATE TABLE IF NOT EXISTS `eggs` (`eggid`, `model` ,`posx`,`posy`,`posz`)"));
	//Loading Eggs
	new query[48], DBResult:res;
	for(new i=1; i < MAX_EGGS; i++)
	{
 		format(query,sizeof(query),"SELECT * FROM `eggs` WHERE `eggid` = '%d'",i);
        res = db_query(eggs_db,query);

        if(db_num_rows(res))
        {
            eggcount ++;
			//Load the data in variables
            new field[50];
            db_get_field_assoc(res, "model", field, 50 );
            egg_info[i][emodel] = strval(field);
            db_get_field_assoc(res, "posx", field, 50 );
            egg_info[i][posx] = floatstr(field);
            db_get_field_assoc(res, "posy", field, 50 );
            egg_info[i][posy] = floatstr(field);
            db_get_field_assoc(res, "posz", field, 50 );
            egg_info[i][posz] = floatstr(field);
            //Create egg with the loaded data
            Egg[i] = CreateDynamicPickup(egg_info[i][emodel], 1, egg_info[i][posx], egg_info[i][posy], egg_info[i][posz], -1, -1, -1, 100);
            egg_info[i][valid] = true;
        }
        db_free_result(res);
	}
	printf("[EH]: %d easter eggs successfully loaded!", eggcount);
	return 1;
}

function EggLabels(bool:toggle)
{
	if(toggle)
	{
	    new lbl_text[16];
	    for(new i=0; i < MAX_EGGS; i++)
		{
		    if(egg_info[i][valid])
		    {
            	format(lbl_text, sizeof(lbl_text),"EggID: %d", i);
		    	EggLabel[i] = CreateDynamic3DTextLabel(lbl_text, -1, egg_info[i][posx], egg_info[i][posy], egg_info[i][posz], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 100);
			}
		}
		eggLabels = true;
	}
	else
	{
	    for(new i=0; i < MAX_EGGS; i++)
		{
		    if(egg_info[i][valid])
		    {
		        DestroyDynamic3DTextLabel(EggLabel[i]);
			}
		}
	    eggLabels = false;
	}
	return 1;
}

function ResetEggs()
{
    for(new i = 1; i < MAX_EGGS; i++)
	{
	    if(!IsValidDynamicPickup(Egg[i]) && egg_info[i][valid])
	    {
	        Egg[i] = CreateDynamicPickup(egg_info[i][emodel], 1, egg_info[i][posx], egg_info[i][posy], egg_info[i][posz], -1, -1, -1, 100);
	    }
	}
	return 1;
}

new prttime;
function EggParticle(eggid)
{
	new Float:ppos[3];
	Streamer_GetFloatData(1, eggid, E_STREAMER_X, ppos[0]);
	Streamer_GetFloatData(1, eggid, E_STREAMER_Y, ppos[1]);
	Streamer_GetFloatData(1, eggid, E_STREAMER_Z, ppos[2]);
	new eggprt = CreateObject(18670, ppos[0], ppos[1], ppos[2]-1, 0, 0, 0, 100);
	prttime = SetTimerEx("DelayDestroy", 500, false, "i", eggprt);
	return 1;
}

function DelayDestroy(prt)
{
	DestroyObject(prt);
	KillTimer(prttime);
	return 1;
}

/////////////////////////// PUBLICS ////////////////////////////////////////////

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(atEggHunt[playerid] && EggHunt)
	{
		for(new i = 1; i < MAX_EGGS; i++)
		{
		    if(pickupid == Egg[i] && egg_info[i][valid])
		    {
		        //Update Score
				pEggs[playerid] ++;
				new score[10];
				format(score, sizeof(score),"Eggs: %02d",pEggs[playerid]);
				PlayerTextDrawSetString(playerid,EggHUD[0],score);
				
				//Feedback
				EggParticle(pickupid);
				PlayerPlaySound(playerid, 5201 , 0.0, 0.0, 0.0);
				
				//Destroy EGG
				DestroyDynamicPickup(Egg[i]);
		    }
		}
	}
	if(pickupid == para[0] || pickupid == para[1] || pickupid == para[2])
	{
		if(!EggHunt)return 1;
	    if(!atEggHunt[playerid])return 1;
	    if(GetPlayerWeapon(playerid) == 46)return 1;
	    GivePlayerWeapon(playerid,46,1);
	    PlayerPlaySound(playerid, 5201 , 0.0, 0.0, 0.0);
	}
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if(atEggHunt[playerid] && EggHunt)
	{
		for(new i = 0; i < 3; i++)
		{
		    if(checkpointid == respawn_cp[i])
		    {
		        if(pSpawn[playerid] == i)return 1;
		        SCM(playerid,c_result,"[EH] - You respawn point has been set! Use /eh respawn to respawn here.");
				pSpawn[playerid] = i;
				PlayerPlaySound(playerid, 5201 , 0.0, 0.0, 0.0);
		    }
		}
	}
	return 1;
}

public OnFilterScriptInit()
{ 
	
    
    Command_AddAlt(YCMD:eh, "egghunt");
    
	LoadEggs();
	
	respawn_cp[0] = CreateDynamicCP(cp_pos[0][0], cp_pos[0][1], cp_pos[0][2], 2.0, -1, -1, -1, 10);
	respawn_cp[1] = CreateDynamicCP(cp_pos[1][0], cp_pos[1][1], cp_pos[1][2], 2.0, -1, -1, -1, 10);
	respawn_cp[2] = CreateDynamicCP(cp_pos[2][0], cp_pos[2][1], cp_pos[2][2], 2.0, -1, -1, -1, 10);
	respawn_cp[3] = CreateDynamicCP(cp_pos[3][0], cp_pos[3][1], cp_pos[3][2], 2.0, -1, -1, -1, 10);
	
	
	para[0] = CreateDynamicPickup(1310,1,3697.7871,1564.5208,134.3533,-1,-1,-1,100);
	para[1] = CreateDynamicPickup(1310,1,3810.9373,1562.4929,107.2776,-1,-1,-1,100);
	para[2] = CreateDynamicPickup(1310,1,3810.7764,1563.8136,144.2776,-1,-1,-1,100);
	
    mwall[0] = CreateDynamicObject(18766, 3817.752441, 1507.720581, 46.760246, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(mwall[0], 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0xFFFF0000);
    mwall[1] = CreateDynamicObject(18766, 3822.343017, 1516.291015, 46.760246, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(mwall[1], 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0xFFFF0000);
    
    mwall[2] = CreateDynamicObject(18766, 3799.752197, 1573.723022, 91.410224, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(mwall[2], 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0xFFFF0000);
    mwall[3] = CreateDynamicObject(18766, 3789.750732, 1552.921875, 91.410224, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(mwall[3], 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0xFFFF0000);
    mwall[4] = CreateDynamicObject(18766, 3783.452636, 1568.912719, 99.740203, 0.000000, -0.000015, -90.000030, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(mwall[4], 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0xFFFF0000);
    mwall[5] = CreateDynamicObject(18766, 3804.814453, 1558.911254, 99.740203, 0.000000, -0.000015, -90.000030, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(mwall[5], 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0xFFFF0000);
    mwall[6] = CreateDynamicObject(18766, 3799.752197, 1552.961425, 108.350128, -0.000007, -0.000022, 179.999893, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(mwall[6], 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0xFFFF0000);
    mwall[7] = CreateDynamicObject(18766, 3789.750732, 1573.082885, 108.350128, -0.000007, -0.000022, 179.999893, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(mwall[7], 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0xFFFF0000);
    mwall[8] = CreateDynamicObject(18766, 3804.736083, 1568.912719, 115.620155, -0.000007, -0.000015, -90.000007, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(mwall[8], 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0xFFFF0000);
    mwall[9] = CreateDynamicObject(18766, 3783.497070, 1558.911254, 115.620155, -0.000007, -0.000015, -90.000007, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(mwall[9], 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0xFFFF0000);
    mwall[10] = CreateDynamicObject(18766, 3799.752197, 1572.962158, 124.230079, -0.000007, -0.000030, 179.999847, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(mwall[10], 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0xFFFF0000);
    mwall[11] = CreateDynamicObject(18766, 3789.750732, 1552.931152, 124.230079, -0.000007, -0.000030, 179.999847, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(mwall[11], 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0xFFFF0000);
    
    /*spinner[0] = CreateObject(18980, 3795.014160, 1563.911987, 131.630096, 89.999992, -0.000030, 179.999847, 300.00);
    SetObjectMaterial(spinner[0], 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0xFFFF0000);
    spinner[1] = CreateObject(18980, 3795.014160, 1563.911987, 136.970138, 89.999992, -0.000030, 269.999847, 300.00);
    SetObjectMaterial(spinner[1], 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0xFFFF0000);*/
    
    platform[0] = CreateDynamicObject(18769, 3794.226562, 1563.399658, 84.539260, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(platform[0], 0, 19082, "laserpointer4", "laserbeam-4-64x64", 0x00000000);
    SetDynamicObjectMaterial(platform[0], 1, 18901, "matclothes", "bandanazigzag", 0x00000000);
    SetDynamicObjectMaterial(platform[0], 2, 18901, "matclothes", "bandanazigzag", 0x00000000);
    platform[1] = CreateDynamicObject(19278, 3681.181884, 1481.425048, 25.620777, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(platform[1], 0, -1, "none", "none", 0xFF000000);
    SetDynamicObjectMaterial(platform[1], 2, 18901, "matclothes", "bandanazigzag", 0x00000000);
    SetDynamicObjectMaterial(platform[1], 3, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    platform[2] = CreateDynamicObject(19278, 3698.701904, 1483.076049, 13.040745, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(platform[2], 0, -1, "none", "none", 0xFF000000);
    SetDynamicObjectMaterial(platform[2], 2, 18901, "matclothes", "bandanazigzag", 0x00000000);
    SetDynamicObjectMaterial(platform[2], 3, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    platform[3] = CreateDynamicObject(19278, 3717.631835, 1483.076049, 26.020784, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(platform[3], 0, -1, "none", "none", 0xFF000000);
    SetDynamicObjectMaterial(platform[3], 2, 18901, "matclothes", "bandanazigzag", 0x00000000);
    SetDynamicObjectMaterial(platform[3], 3, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    platform[4] = CreateDynamicObject(19278, 3735.893066, 1483.076049, 16.970783, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(platform[4], 0, -1, "none", "none", 0xFF000000);
    SetDynamicObjectMaterial(platform[4], 2, 18901, "matclothes", "bandanazigzag", 0x00000000);
    SetDynamicObjectMaterial(platform[4], 3, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);

    new tmpobjid;
	//Main Land (Leave Static)
    tmpobjid = CreateObject(17098, 3665.838378, 1542.627685, 8.894253, 0.000000, 0.000000, -51.099983, 300.00); 
    SetObjectMaterial(tmpobjid, 4, 10765, "airportgnd_sfse", "desgreengrass", 0x00000000);
    SetObjectMaterial(tmpobjid, 5, 12871, "ce_ground01", "sw_rockgrassB1", 0x00000000);
    tmpobjid = CreateObject(9249, 3689.634033, 1617.938598, 17.598688, 0.000000, 0.000000, 145.699981, 300.00); 
    SetObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "desgreengrass", 0x00000000);
    SetObjectMaterial(tmpobjid, 3, 10765, "airportgnd_sfse", "desgreengrass", 0x00000000);
    tmpobjid = CreateObject(13165, 3783.040771, 1616.161743, 9.195474, 4.000000, 0.000000, 164.299942, 300.00);
    SetObjectMaterial(tmpobjid, 4, 4811, "beach_las", "sandnew_law", 0x00000000);
    SetObjectMaterial(tmpobjid, 5, 4811, "beach_las", "sandnew_law", 0x00000000);
    tmpobjid = CreateObject(8003, 3760.584228, 1584.338134, -4.762374, 0.000000, 0.000000, 160.800033, 300.00);
    SetObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "desgreengrass", 0x00000000);
    SetObjectMaterial(tmpobjid, 2, 10765, "airportgnd_sfse", "desgreengrass", 0x00000000);
    SetObjectMaterial(tmpobjid, 5, 12871, "ce_ground01", "sw_rockgrassB1", 0x00000000);
    tmpobjid = CreateObject(9207, 3796.198486, 1627.675292, -59.474815, 0.000000, -9.399998, 36.900032, 300.00);
    SetObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "sw_rockgrass1", 0x00000000);
    SetObjectMaterial(tmpobjid, 1, 12871, "ce_ground01", "sw_rockgrass1", 0x00000000);
    SetObjectMaterial(tmpobjid, 2, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    SetObjectMaterial(tmpobjid, 3, 12871, "ce_ground01", "sw_rockgrass1", 0x00000000);
    SetObjectMaterial(tmpobjid, 4, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    SetObjectMaterial(tmpobjid, 5, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateObject(11694, 3684.257568, 1590.689941, 0.119493, 0.000000, 0.000000, 0.000000, 300.00);
    SetObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "desgreengrass", 0x00000000);
    SetObjectMaterial(tmpobjid, 2, 12871, "ce_ground01", "sw_rockgrassB1", 0x00000000);
    SetObjectMaterial(tmpobjid, 3, 12871, "ce_ground01", "sw_rockgrass1", 0x00000000);
    tmpobjid = CreateObject(16258, 3793.646484, 1601.817016, -27.629430, 0.000000, 0.000000, 0.000000, 300.00);
    SetObjectMaterial(tmpobjid, 2, 10765, "airportgnd_sfse", "desgreengrass", 0x00000000);
    SetObjectMaterial(tmpobjid, 5, 12871, "ce_ground01", "sw_rockgrassB1", 0x00000000);
    tmpobjid = CreateObject(16258, 3794.362548, 1593.977661, -27.629430, 0.000000, 0.000000, -27.799999, 300.00);
    SetObjectMaterial(tmpobjid, 2, 10765, "airportgnd_sfse", "desgreengrass", 0x00000000);
    SetObjectMaterial(tmpobjid, 5, 12871, "ce_ground01", "sw_rockgrassB1", 0x00000000);
    tmpobjid = CreateObject(16258, 3799.631835, 1596.694458, -27.629430, 0.000000, 0.000000, -57.399997, 300.00);
    SetObjectMaterial(tmpobjid, 2, 10765, "airportgnd_sfse", "desgreengrass", 0x00000000);
    SetObjectMaterial(tmpobjid, 5, 12871, "ce_ground01", "sw_rockgrassB1", 0x00000000);
    tmpobjid = CreateObject(6417, 3527.369140, 1553.510498, -10.017378, 0.000000, 0.000000, -1.799980, 300.00);
    tmpobjid = CreateObject(4842, 3586.161865, 1552.463623, -3.077477, -4.699999, 2.499999, 0.000000, 300.00);
    SetObjectMaterial(tmpobjid, 0, 4811, "beach_las", "sandnew_law", 0x00000000);
    
    //Other objects
    tmpobjid = CreateDynamicObject(900, 3779.507812, 1559.589233, 13.764067, 90.000000, -44.399997, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(900, 3796.593017, 1557.646484, 17.951997, -5.399991, 169.100006, -167.799972, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(900, 3773.239013, 1574.734863, 24.033023, 42.730445, 117.666305, -169.142669, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(900, 3781.347167, 1587.802124, 33.973892, 70.630439, 119.466331, 303.257354, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(900, 3769.972656, 1578.220947, 33.819183, 70.630439, 119.466331, 82.557380, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(899, 3773.055908, 1578.918945, 39.581569, 0.000000, 10.500000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(899, 3773.055908, 1580.112182, 33.721374, 0.000000, 10.500000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(899, 3758.155273, 1580.112182, 33.349510, 0.000000, 10.500000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(900, 3877.246337, 1550.231445, 14.976735, -75.042053, -107.502792, 143.248657, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(900, 3563.348144, 1587.920776, -6.199551, 86.132278, -204.844116, -158.737869, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(900, 3879.081787, 1557.671997, 13.796943, -75.042053, -107.502792, 139.048614, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(16139, 3608.789550, 1619.138916, 25.288257, 0.000000, 0.000000, -63.300029, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19344, "egg_texts", "easter_egg01", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19344, "egg_texts", "easter_egg02", 0x00000000);
    tmpobjid = CreateDynamicObject(16139, 3630.002685, 1594.704101, 25.288257, 0.000000, 0.000000, -63.300029, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19344, "egg_texts", "easter_egg03", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19344, "egg_texts", "easter_egg04", 0x00000000);
    tmpobjid = CreateDynamicObject(16139, 3640.657958, 1591.881835, 25.288257, 0.000000, 0.000000, -63.300029, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19344, "egg_texts", "easter_egg02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19344, "egg_texts", "easter_egg03", 0x00000000);
    tmpobjid = CreateDynamicObject(16139, 3633.028320, 1624.438842, 34.488265, 0.000000, 0.000000, -52.700027, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19344, "egg_texts", "easter_egg04", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19344, "egg_texts", "easter_egg05", 0x00000000);
    tmpobjid = CreateDynamicObject(16139, 3643.067382, 1624.958618, 30.728254, 9.399999, 5.299999, 90.399986, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19344, "egg_texts", "easter_egg01", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19344, "egg_texts", "easter_egg02", 0x00000000);
    tmpobjid = CreateDynamicObject(900, 3713.521240, 1628.224609, 22.865402, 82.386703, 188.340148, 133.757003, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(900, 3741.236083, 1601.641601, 28.021451, 79.569602, 98.566291, -146.942596, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(900, 3730.866210, 1612.162353, 27.519201, 78.569725, 124.306190, -168.126922, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(900, 3706.345458, 1633.357666, 20.585361, 84.439254, 160.915573, 161.011489, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(900, 3746.365966, 1571.561645, 32.421508, 100.430389, -81.433677, 68.657394, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3639.559570, 1518.307739, 33.644783, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(18766, 3764.325927, 1547.169311, 46.426139, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(3865, 3768.104492, 1556.499877, 50.276134, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3768.104492, 1552.379882, 52.196151, 0.000000, 90.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3768.104492, 1552.379882, 53.186157, 0.000000, 90.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(3865, 3768.194580, 1567.859619, 53.036151, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(3865, 3774.604492, 1574.289428, 53.036151, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3639.837646, 1517.550170, 38.466812, 52.040039, 56.857200, -50.369731, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3639.760498, 1519.061523, 38.513210, 52.040061, -56.857288, -129.630294, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3640.481201, 1518.210693, 38.080154, 82.099891, 179.999816, -89.999855, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3639.194091, 1518.260742, 38.853469, 35.899982, -0.000048, -89.999954, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3637.675048, 1519.186279, 40.746780, 52.040035, 56.857204, 109.630218, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3638.591552, 1518.307739, 36.267379, 0.000000, -12.599996, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3637.230468, 1517.739624, 40.793178, 52.040050, -56.857284, 30.369672, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3636.844238, 1518.785644, 40.360122, 82.099891, 179.999832, 70.000106, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3638.036621, 1518.298461, 41.133438, 35.899982, -0.000045, 70.000007, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3770.361328, 1574.290405, 51.116153, 0.000000, 90.000000, 900.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3768.361572, 1572.289306, 51.117153, 0.000000, 90.000000, 990.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(3865, 3785.696044, 1574.289428, 55.686138, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3680.468017, 1534.644897, 37.375438, 0.000000, 0.000014, 19.999998, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3768.226806, 1556.949829, -0.995778, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3768.256835, 1564.798217, 1.664219, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3776.833007, 1574.189331, 1.664219, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3785.401611, 1574.189331, 4.244217, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(18766, 3799.387207, 1574.127441, 52.543373, 90.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18766, 3801.878906, 1571.597412, 52.542373, 90.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3680.988525, 1534.028076, 42.197467, 52.040016, 56.857215, -30.369733, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3680.399169, 1535.421997, 42.243865, 52.040039, -56.857303, -109.630256, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3681.367431, 1534.868896, 41.810810, 82.099891, 179.999816, -69.999816, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3680.140869, 1534.475708, 42.584125, 35.899967, -0.000048, -69.999931, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3678.396728, 1534.825927, 44.477436, 52.040042, 56.857196, 129.630172, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3679.558593, 1534.313842, 39.998035, 0.000000, -12.599982, 19.999998, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3678.473876, 1533.314453, 44.523834, 52.040050, -56.857261, 50.369640, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3677.752929, 1534.165283, 44.090778, 82.099891, 179.999862, 90.000045, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3679.040283, 1534.115234, 44.864093, 35.899990, -0.000037, 89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3801.878906, 1563.856933, 52.542373, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3809.052978, 1563.866943, 52.542373, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3810.783935, 1562.007324, 55.502365, 0.000000, 90.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3724.208496, 1503.309936, 33.089653, 0.000004, 0.000029, 69.999984, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3812.463134, 1563.866943, 58.272369, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3810.783935, 1565.639160, 61.072338, 0.000000, 90.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3809.052978, 1563.866943, 63.552360, 0.000000, 90.000007, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3810.783935, 1562.007324, 66.512351, 0.000007, 90.000000, 89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3812.463134, 1563.866943, 69.282356, 0.000000, 90.000007, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3810.783935, 1565.639160, 72.082321, 0.000007, 90.000000, 89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3725.015380, 1503.312255, 37.911682, 52.040004, 56.857238, 19.630239, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3723.568847, 1503.756713, 37.958084, 52.040016, -56.857311, -59.630226, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3724.614990, 1504.143066, 37.525024, 82.099891, 179.999847, -19.999849, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3724.127929, 1502.950561, 38.298339, 35.899944, -0.000041, -19.999931, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3722.738281, 1501.839599, 40.191650, 52.040054, 56.857181, 179.630126, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3723.877441, 1502.400512, 35.712249, 0.000004, -12.599967, 69.999984, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3723.945800, 1500.927124, 40.238052, 52.040061, -56.857246, 100.369613, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3722.830566, 1500.921875, 39.804992, 82.099891, 179.999862, 140.000015, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3723.696533, 1501.875854, 40.578308, 35.899997, -0.000037, 139.999938, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3808.753662, 1567.660400, 72.081321, 0.000007, 90.000000, 179.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3805.773193, 1565.659790, 72.081321, 0.000007, 90.000000, 269.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3805.773193, 1560.669555, 72.081321, 0.000007, 90.000000, 269.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3757.654296, 1552.013183, 32.711952, 0.000018, 0.000034, -110.000007, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(900, 3797.945312, 1561.323974, 29.735374, 143.099960, 168.700012, -167.799972, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(900, 3804.756835, 1560.888061, 19.257083, 69.699966, 179.700012, -143.799972, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(900, 3796.017578, 1566.210327, 18.859420, 69.699966, 179.700012, -53.799972, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(900, 3795.883789, 1565.538940, 19.112661, 69.699966, 179.700012, -10.199976, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(900, 3795.527343, 1567.534179, 18.878423, 83.399955, -177.399963, 7.500021, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 12871, "ce_ground01", "cw2_mountrock", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3805.773193, 1549.609619, 69.661331, 0.000007, 90.000000, 269.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3756.847412, 1552.010864, 37.533977, 52.040004, 56.857261, -160.369766, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3758.293945, 1551.566406, 37.580379, 52.039993, -56.857295, 120.369735, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3757.247802, 1551.180053, 37.147319, 82.099891, 179.999938, 160.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3757.734863, 1552.372558, 37.920635, 35.899936, -0.000024, 160.000015, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3759.124511, 1553.483520, 39.813945, 52.040050, 56.857158, -0.369908, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3757.985351, 1552.922607, 35.334548, 0.000018, -12.599961, -110.000007, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3757.916992, 1554.395996, 39.860347, 52.040073, -56.857254, -79.630393, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3759.032226, 1554.401245, 39.427288, 82.099891, 179.999771, -39.999919, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3758.166259, 1553.447265, 40.200603, 35.899997, -0.000052, -40.000064, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3805.773193, 1534.507202, 65.741325, 0.000007, 90.000000, 269.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18767, 3810.311035, 1518.538452, 61.509403, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18767, 3807.218017, 1512.538452, 51.089424, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3795.301513, 1463.744995, 33.308956, 0.000012, 0.000031, -109.999984, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(18980, 3812.590576, 1509.538085, 43.753303, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18980, 3824.590820, 1521.558837, 43.752304, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18980, 3824.590820, 1548.628173, 46.182304, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18980, 3824.590820, 1578.309814, 53.624912, 0.000000, 66.299987, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(19545, 3822.284423, 1573.126220, 53.151683, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19545, 3822.284423, 1573.126220, 68.131675, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3794.494628, 1463.742675, 38.130981, 52.040000, 56.857250, -160.369720, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3795.941162, 1463.298217, 38.177383, 52.040000, -56.857303, 120.369712, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3794.895019, 1462.911865, 37.744323, 82.099891, 179.999893, 160.000015, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3795.382080, 1464.104370, 38.517639, 35.899940, -0.000033, 159.999984, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3796.771728, 1465.215332, 40.410949, 52.040050, 56.857170, -0.369917, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3795.632568, 1464.654418, 35.931552, 0.000012, -12.599964, -109.999984, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3795.564208, 1466.127807, 40.457351, 52.040061, -56.857250, -79.630378, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3796.679443, 1466.133056, 40.024291, 82.099891, 179.999816, -39.999961, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3795.813476, 1465.179077, 40.797607, 35.899990, -0.000046, -40.000061, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3865, 3824.681152, 1545.034790, 48.018848, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(3865, 3824.681152, 1554.093994, 48.018848, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(3865, 3824.519042, 1567.652954, 56.958847, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3857.601074, 1551.841552, 27.245258, 0.000004, 0.000029, -109.999961, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19756, 3824.549560, 1601.910400, 59.808681, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(5820, 3807.483154, 1640.189331, 12.998744, -0.000007, -0.000001, -106.400016, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3856.794189, 1551.839233, 32.067283, 52.039993, 56.857238, -160.369674, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3858.240722, 1551.394775, 32.113685, 52.040004, -56.857311, 120.369697, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3857.194580, 1551.008422, 31.680625, 82.099891, 179.999847, 160.000030, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3857.681640, 1552.200927, 32.453941, 35.899940, -0.000041, 159.999954, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3859.071289, 1553.311889, 34.347251, 52.040050, 56.857181, -0.369928, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3857.932128, 1552.750976, 29.867855, 0.000004, -12.599967, -109.999961, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3857.863769, 1554.224365, 34.393653, 52.040050, -56.857246, -79.630363, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3858.979003, 1554.229614, 33.960594, 82.099891, 179.999862, -40.000003, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3858.113037, 1553.275634, 34.733909, 35.899982, -0.000037, -40.000061, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3816.698242, 1532.034790, 29.031461, -0.000003, 0.000034, -19.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3824.651611, 1542.448730, -3.495779, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3824.651611, 1556.728271, -3.495779, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(18886, 3801.920410, 1574.085693, 52.114124, 180.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanataidai", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18901, "matclothes", "bandanataidai", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19307, "goflagx2", "goflag3", 0x00000000);
    tmpobjid = CreateDynamicObject(18886, 3524.865966, 1510.584594, 5.532961, 0.000000, 179.999984, -179.999938, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanataidai", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18901, "matclothes", "bandanataidai", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19307, "goflagx2", "goflag3", 0x00000000);
    tmpobjid = CreateDynamicObject(18886, 3726.651123, 1563.423706, 84.376846, 0.000000, 179.999984, -179.999938, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanataidai", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18901, "matclothes", "bandanataidai", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19307, "goflagx2", "goflag3", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3816.700683, 1531.227905, 33.853485, 52.039978, 56.857231, -70.369651, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3817.145019, 1532.674438, 33.899887, 52.040004, -56.857330, -149.630279, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3817.531494, 1531.628295, 33.466827, 82.099891, 179.999786, -109.999862, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3816.338867, 1532.115356, 34.240142, 35.899932, -0.000054, -110.000007, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3815.228027, 1533.505004, 36.133453, 52.040054, 56.857192, 89.630012, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3815.789062, 1532.365844, 31.654058, -0.000003, -12.599962, -19.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3814.315429, 1532.297485, 36.179855, 52.040035, -56.857231, 10.369617, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3814.310302, 1533.412719, 35.746795, 82.099891, 179.999938, 49.999889, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3815.264160, 1532.546752, 36.520111, 35.899982, -0.000024, 49.999904, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(18886, 3682.009277, 1561.084228, 41.972698, 0.000000, 179.999984, -179.999893, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanataidai", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18901, "matclothes", "bandanataidai", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19307, "goflagx2", "goflag3", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3860.620117, 1596.835571, 27.454309, -0.000007, 0.000040, -19.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3860.622558, 1596.028686, 32.276332, 52.039966, 56.857234, -70.369651, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3861.066894, 1597.475219, 32.322734, 52.040000, -56.857341, -149.630264, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3861.453369, 1596.429077, 31.889675, 82.099891, 179.999771, -109.999824, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3860.260742, 1596.916137, 32.662990, 35.899925, -0.000057, -109.999984, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3859.149902, 1598.305786, 34.556301, 52.040061, 56.857192, 89.629989, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3859.710937, 1597.166625, 30.076908, -0.000007, -12.599953, -19.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3858.237304, 1597.098266, 34.602703, 52.040035, -56.857219, 10.369606, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3858.232177, 1598.213500, 34.169643, 82.099891, 179.999969, 49.999847, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3859.186035, 1597.347534, 34.942958, 35.899986, -0.000018, 49.999889, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3785.091552, 1643.794921, 24.701381, -0.000007, 0.000040, -19.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19482, 3545.672851, 1675.942260, 51.500282, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, ")", 90, "Webdings", 199, 0, 0xFFFFFFFF, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 3545.692871, 1675.942260, 51.640281, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "Congratulations!", 70, "Fixedsys", 10, 0, 0xFFFF0000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 3828.190185, 1606.386474, 62.933204, -0.000007, 0.000007, -89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, ")", 90, "Webdings", 199, 0, 0xFFFFFFFF, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 3828.190185, 1606.366455, 63.073204, -0.000007, 0.000007, -89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "Congratulations!", 70, "Fixedsys", 10, 0, 0xFFFF0000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19756, 3824.482910, 1607.256591, 64.238853, 0.000007, 89.999977, 89.999839, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    tmpobjid = CreateDynamicObject(19756, 3824.473632, 1608.420410, 64.239852, -0.000007, 90.000022, -89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3785.093994, 1642.988037, 29.523405, 52.039966, 56.857234, -70.369651, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3785.538330, 1644.434570, 29.569807, 52.040000, -56.857341, -149.630264, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3785.924804, 1643.388427, 29.136747, 82.099891, 179.999771, -109.999824, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3784.732177, 1643.875488, 29.910062, 35.899925, -0.000057, -109.999984, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3783.621337, 1645.265136, 31.803373, 52.040061, 56.857192, 89.629989, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3784.182373, 1644.125976, 27.323980, -0.000007, -12.599953, -19.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3782.708740, 1644.057617, 31.849775, 52.040035, -56.857219, 10.369606, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3782.703613, 1645.172851, 31.416715, 82.099891, 179.999969, 49.999847, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3783.657470, 1644.306884, 32.190032, 35.899986, -0.000018, 49.999889, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3826.272216, 1608.042968, 67.727684, 76.399955, 82.700088, -90.000083, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3826.559082, 1608.042968, 68.913475, 76.399955, 82.700088, -90.000083, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(2782, 3824.564941, 1606.755371, 62.668579, -81.099975, 360.000030, 0.000109, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0xFF000000);
    tmpobjid = CreateDynamicObject(3498, 3740.982910, 1661.901611, 32.965782, -0.000009, 0.000048, 70.000015, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19329, 3825.458984, 1606.604736, 62.003299, -0.000022, -0.000007, -177.799850, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1376, "cranes_dyn2_cj", "ws_cablehang", 0x00000000);
    tmpobjid = CreateDynamicObject(19329, 3823.609375, 1606.574707, 62.003299, 0.000022, 0.000007, -0.400115, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1376, "cranes_dyn2_cj", "ws_cablehang", 0x00000000);
    tmpobjid = CreateDynamicObject(2835, 3825.068603, 1606.471435, 65.021804, -0.000007, 90.000022, -89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(2835, 3823.007812, 1606.471435, 65.021804, -0.000007, 90.000022, -89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(19844, 3823.497314, 1606.502929, 64.051498, 89.999992, 115.528770, -115.528808, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
    tmpobjid = CreateDynamicObject(19844, 3825.558349, 1606.502929, 64.051498, 89.999992, 115.528770, -115.528808, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
    tmpobjid = CreateDynamicObject(3497, 3741.789550, 1661.904052, 37.787803, 52.039955, 56.857238, 19.630334, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3740.343261, 1662.348388, 37.834205, 52.039993, -56.857353, -59.630252, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3741.389160, 1662.734863, 37.401145, 82.099891, 179.999755, -19.999809, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3740.902343, 1661.542236, 38.174461, 35.899913, -0.000059, -19.999986, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3739.512695, 1660.431396, 40.067771, 52.040065, 56.857192, 179.629943, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3740.651855, 1660.992431, 35.588378, -0.000009, -12.599946, 70.000015, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3740.720214, 1659.518798, 40.114173, 52.040035, -56.857208, 100.369575, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3739.604980, 1659.513671, 39.681114, 82.099891, 180.000000, 139.999771, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3740.470703, 1660.467529, 40.454433, 35.899990, -0.000012, 139.999847, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3826.312988, 1607.052001, 67.719291, 80.300018, 262.699859, -89.999992, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3826.518554, 1607.052001, 68.921852, 80.300018, 262.699859, -89.999992, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3822.962890, 1607.857666, 67.609359, 80.699981, 262.699859, 104.200195, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3689.003417, 1663.219726, 29.263528, -0.000001, 0.000050, 159.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3822.771484, 1607.809326, 68.813316, 80.699981, 262.699859, 104.200195, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3823.245117, 1606.906982, 67.617454, 76.799942, 82.699851, 104.200035, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3822.975097, 1606.838623, 68.805229, 76.799942, 82.699851, 104.200035, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3826.269775, 1608.022705, 67.728271, 76.399955, 82.700088, -90.000083, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFF9090);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3822.963867, 1607.847412, 67.609153, 80.699981, 262.699859, 104.200195, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFF9090);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19482, 3772.369140, 1468.687622, 38.574657, -0.000007, 0.000007, 75.599975, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, ")", 90, "Webdings", 199, 0, 0xFFFFFFFF, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(3497, 3689.000976, 1664.026367, 34.085548, 52.039955, 56.857250, 109.630302, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3688.556640, 1662.580078, 34.131950, 52.039981, -56.857345, 30.369731, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3688.170166, 1663.625976, 33.698890, 82.099891, 179.999801, 70.000122, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3689.362792, 1663.139160, 34.472206, 35.899906, -0.000050, 69.999984, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3690.473632, 1661.749511, 36.365516, 52.040061, 56.857181, -90.370033, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3689.912597, 1662.888671, 31.886125, -0.000001, -12.599944, 159.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3691.386230, 1662.957031, 36.411918, 52.040039, -56.857212, -169.630386, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3691.391357, 1661.841796, 35.978858, 82.099891, 179.999954, -130.000183, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3690.437500, 1662.707519, 36.752182, 35.899990, -0.000019, -130.000137, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19482, 3772.374023, 1468.707031, 38.714656, -0.000007, 0.000007, 75.599975, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "Congratulations!", 70, "Fixedsys", 10, 0, 0xFFFF0000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19756, 3775.743408, 1466.922851, 39.880306, 0.000007, 89.999977, -104.400123, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    tmpobjid = CreateDynamicObject(19756, 3775.462890, 1465.793212, 39.881305, -0.000007, 90.000022, 75.599975, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3673.800048, 1602.813720, 42.945991, 0.000000, 0.000043, -105.800010, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3773.814697, 1466.606201, 43.369136, 76.399940, 82.700088, 75.599868, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3773.536865, 1466.677490, 44.554927, 76.399940, 82.700088, 75.599868, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(2782, 3775.788574, 1467.428710, 38.310031, -81.099975, 360.000030, 165.600097, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0xFF000000);
    tmpobjid = CreateDynamicObject(19329, 3774.959960, 1467.796997, 37.644752, -0.000022, -0.000007, -12.199856, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1376, "cranes_dyn2_cj", "ws_cablehang", 0x00000000);
    tmpobjid = CreateDynamicObject(19329, 3776.759033, 1467.366088, 37.644752, 0.000022, 0.000007, 165.199783, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1376, "cranes_dyn2_cj", "ws_cablehang", 0x00000000);
    tmpobjid = CreateDynamicObject(2835, 3775.371337, 1467.828979, 40.663257, -0.000007, 90.000022, 75.599975, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(3497, 3672.995849, 1602.752197, 47.768009, 52.039962, 56.857246, -156.169662, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3674.470703, 1602.415039, 47.814411, 52.039981, -56.857334, 124.569702, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3673.455810, 1601.952880, 47.381351, 82.099891, 179.999816, 164.200057, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3673.854003, 1603.177978, 48.154666, 35.899909, -0.000048, 164.199935, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3675.158447, 1604.387695, 50.047977, 52.040050, 56.857181, 3.829962, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3674.063476, 1603.744750, 45.568588, 0.000000, -12.599950, -105.800010, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3673.887451, 1605.209472, 50.094379, 52.040035, -56.857223, -75.430366, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3674.999267, 1605.296264, 49.661319, 82.099891, 179.999923, -35.800144, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3674.205810, 1604.281494, 50.434642, 35.899982, -0.000025, -35.800136, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(2835, 3777.367431, 1467.316528, 40.663257, -0.000007, 90.000022, 75.599975, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(19844, 3776.885498, 1467.407714, 39.692951, 89.999992, 193.368469, -27.768531, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
    tmpobjid = CreateDynamicObject(19844, 3774.889160, 1467.920288, 39.692951, 89.999992, 193.368469, -27.768531, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
    tmpobjid = CreateDynamicObject(3498, 3747.577148, 1583.774414, 43.907947, -0.000007, 0.000040, -15.800013, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3774.021728, 1467.576171, 43.360744, 80.300018, 262.699859, 75.599960, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3773.822753, 1467.627197, 44.563304, 80.300018, 262.699859, 75.599960, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3777.066162, 1465.962646, 43.250812, 80.699966, 262.699859, -90.199783, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3777.263427, 1465.961914, 44.454769, 80.699966, 262.699859, -90.199783, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3777.029296, 1466.953613, 43.258907, 76.799926, 82.699851, -90.199928, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3777.307861, 1466.952636, 44.446681, 76.799926, 82.699851, -90.199928, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3747.638671, 1582.970214, 48.729965, 52.039955, 56.857234, -66.169654, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3747.975830, 1584.445068, 48.776367, 52.039989, -56.857341, -145.430267, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3748.437988, 1583.430175, 48.343307, 82.099891, 179.999755, -105.799873, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3747.212890, 1583.828369, 49.116622, 35.899909, -0.000057, -105.800048, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3746.003173, 1585.132812, 51.009933, 52.040050, 56.857192, 93.829925, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3746.645996, 1584.037841, 46.530544, -0.000007, -12.599952, -15.800013, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3745.181396, 1583.861816, 51.056335, 52.040023, -56.857219, 14.569619, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3745.094726, 1584.973632, 50.623275, 82.099891, 179.999969, 54.199790, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3746.109375, 1584.180175, 51.396598, 35.899978, -0.000018, 54.199844, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3773.822265, 1466.625244, 43.369724, 76.399940, 82.700088, 75.599868, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFF9090);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3777.067871, 1465.972900, 43.250606, 80.699966, 262.699859, -90.199783, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFF9090);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19538, 3724.397705, 1543.832031, 146.571701, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3698.871826, 1618.331176, 38.733787, -0.000009, 0.000048, -15.800012, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19538, 3682.884277, 1543.832031, 146.571701, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19482, 3528.419677, 1524.183593, 14.959063, -1.008380, 7.119656, -96.628158, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, ")", 90, "Webdings", 199, 0, 0xFFFFFFFF, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19482, 3528.417724, 1524.099609, 15.462568, -1.008380, 7.119656, -96.628158, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "Welcome to\nEgg Hunt Island!", 80, "Fixedsys", 10, 0, 0xFFFF0000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(19756, 3524.843505, 1525.305664, 16.427536, 1.008399, 82.880325, 83.371597, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    tmpobjid = CreateDynamicObject(19756, 3524.970214, 1526.453369, 16.572912, -1.008380, 97.119674, -96.628158, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3526.722900, 1525.437500, 19.954879, 73.776420, 109.030876, -122.170906, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3698.933349, 1617.526977, 43.555805, 52.039943, 56.857238, -66.169654, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3699.270507, 1619.001831, 43.602207, 52.039981, -56.857353, -145.430236, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3699.732666, 1617.986938, 43.169147, 82.099891, 179.999740, -105.799835, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3698.507568, 1618.385131, 43.942462, 35.899902, -0.000059, -105.800025, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3697.297851, 1619.689575, 45.835773, 52.040054, 56.857192, 93.829902, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3697.940673, 1618.594604, 41.356384, -0.000009, -12.599946, -15.800012, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3696.476074, 1618.418579, 45.882175, 52.040023, -56.857208, 14.569604, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3696.389404, 1619.530395, 45.449115, 82.099891, 180.000000, 54.199748, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3697.404052, 1618.736938, 46.222438, 35.899982, -0.000012, 54.199836, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3527.011718, 1525.255981, 21.126304, 73.776420, 109.030876, -122.170906, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(2782, 3524.861816, 1524.998657, 14.806043, -73.949424, 363.649353, -3.120648, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0xFF000000);
    tmpobjid = CreateDynamicObject(19329, 3525.730224, 1524.830078, 14.111578, -7.152299, -0.740796, 175.462768, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1376, "cranes_dyn2_cj", "ws_cablehang", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3655.131347, 1573.986816, 50.573398, -0.000011, 0.000056, -15.800012, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19329, 3523.889648, 1525.014160, 14.140424, 7.111289, 1.066162, -7.157399, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1376, "cranes_dyn2_cj", "ws_cablehang", 0x00000000);
    tmpobjid = CreateDynamicObject(2835, 3525.335937, 1524.366333, 17.096712, -1.008380, 97.119674, -96.628158, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(2835, 3523.289306, 1524.604003, 17.132970, -1.008380, 97.119674, -96.628158, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(19844, 3523.775878, 1524.700073, 16.165592, 82.809654, 171.917312, -178.608215, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
    tmpobjid = CreateDynamicObject(19844, 3525.823242, 1524.462280, 16.129331, 82.809654, 171.917312, -178.608215, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
    tmpobjid = CreateDynamicObject(19474, 3526.647705, 1524.457153, 19.823020, 77.157943, 296.586212, -129.971969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3655.192871, 1573.182617, 55.395416, 52.039932, 56.857242, -66.169654, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3655.530029, 1574.657470, 55.441818, 52.039978, -56.857364, -145.430191, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3655.992187, 1573.642578, 55.008758, 82.099891, 179.999725, -105.799797, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3654.767089, 1574.040771, 55.782073, 35.899894, -0.000061, -105.800003, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3653.557373, 1575.345214, 57.675384, 52.040061, 56.857192, 93.829879, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3654.200195, 1574.250244, 53.195995, -0.000011, -12.599938, -15.800012, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3652.735595, 1574.074218, 57.721786, 52.040023, -56.857196, 14.569595, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3652.648925, 1575.186035, 57.288726, 82.099891, 180.000030, 54.199707, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3653.663574, 1574.392578, 58.062049, 35.899986, -0.000007, 54.199825, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3526.855468, 1524.283081, 21.012519, 77.157943, 296.586212, -129.971969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3523.414306, 1525.651611, 19.872768, 77.671417, 227.047164, 132.579315, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3523.222656, 1525.475219, 21.064622, 77.671417, 227.047164, 132.579315, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3599.486083, 1533.738159, 32.136013, -0.000011, 0.000056, -15.800012, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3523.583496, 1524.681030, 19.758007, 74.339111, 55.245933, 124.134063, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3523.311035, 1524.496215, 20.932720, 74.339111, 55.245933, 124.134063, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3526.718017, 1525.417602, 19.952991, 73.776420, 109.030876, -122.170906, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFF9090);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3523.414062, 1525.641235, 19.871265, 77.671417, 227.047164, 132.579315, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFF9090);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19482, 3528.416259, 1524.199096, 14.678779, -1.008380, 7.119656, -96.628158, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterialText(tmpobjid, 0, "Enjoy your eggs!", 90, "Fixedsys", 10, 0, 0xFF000000, 0x00000000, 1);
    tmpobjid = CreateDynamicObject(16139, 3524.376953, 1665.880371, 24.579404, 16.500003, 13.399998, -108.700042, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19344, "egg_texts", "easter_egg01", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19344, "egg_texts", "easter_egg02", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3599.547607, 1532.933959, 36.958030, 52.039932, 56.857242, -66.169654, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3599.884765, 1534.408813, 37.004432, 52.039978, -56.857364, -145.430191, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3600.346923, 1533.393920, 36.571372, 82.099891, 179.999725, -105.799797, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3599.121826, 1533.792114, 37.344688, 35.899894, -0.000061, -105.800003, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3597.912109, 1535.096557, 39.237998, 52.040061, 56.857192, 93.829879, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3498, 3598.554931, 1534.001586, 34.758609, -0.000011, -12.599938, -15.800012, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "greendirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 4, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 5, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 6, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 7, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 8, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3597.090332, 1533.825561, 39.284400, 52.040023, -56.857196, 14.569595, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3597.003662, 1534.937377, 38.851341, 82.099891, 180.000030, 54.199707, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(3497, 3598.018310, 1534.143920, 39.624664, 35.899986, -0.000007, 54.199825, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "ab_wallpaper02", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 18065, "ab_sfammumain", "ab_wallpaper02", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 5150, "wiresetc_las2", "ganggraf01_LA_m", 0x00000000);
    tmpobjid = CreateDynamicObject(19756, 3544.802734, 1672.234985, 52.805931, 0.000000, 89.999984, 179.999908, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    tmpobjid = CreateDynamicObject(19756, 3543.638916, 1672.225585, 52.806930, 0.000000, 90.000015, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3544.016357, 1674.024291, 56.294757, 76.399986, 82.700057, -0.000077, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3544.016357, 1674.311157, 57.480548, 76.399986, 82.700057, -0.000077, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(2782, 3545.303955, 1672.317016, 51.235656, -81.099975, 359.999969, 90.000045, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0xFF000000);
    tmpobjid = CreateDynamicObject(19329, 3545.454589, 1673.211181, 50.570377, -0.000014, 0.000000, -87.799964, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1376, "cranes_dyn2_cj", "ws_cablehang", 0x00000000);
    tmpobjid = CreateDynamicObject(19329, 3545.484619, 1671.361572, 50.570377, 0.000014, 0.000000, 89.599945, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 1376, "cranes_dyn2_cj", "ws_cablehang", 0x00000000);
    tmpobjid = CreateDynamicObject(2835, 3545.587890, 1672.820678, 53.588878, 0.000000, 90.000015, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(2835, 3545.587890, 1670.760009, 53.588878, 0.000000, 90.000015, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(19844, 3545.556396, 1671.249389, 52.618572, 89.999992, 179.999984, -89.999984, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
    tmpobjid = CreateDynamicObject(19844, 3545.556396, 1673.310424, 52.618572, 89.999992, 179.999984, -89.999984, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
    tmpobjid = CreateDynamicObject(19474, 3545.007324, 1674.064941, 56.286373, 80.300033, 262.699829, 0.000017, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3545.007324, 1674.270507, 57.488933, 80.300033, 262.699829, 0.000017, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3544.201660, 1670.714843, 56.176437, 80.700004, 262.699890, -165.799789, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3544.250000, 1670.523681, 57.380393, 80.700004, 262.699890, -165.799789, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3545.152343, 1670.997314, 56.184528, 76.799957, 82.699890, -165.799926, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3545.220703, 1670.727294, 57.372303, 76.799957, 82.699890, -165.799926, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14530, "estate2", "mp_bobbie_carpet", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3544.036621, 1674.021850, 56.295349, 76.399986, 82.700057, -0.000077, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFF9090);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19474, 3544.211914, 1670.716064, 56.176231, 80.700004, 262.699890, -165.799789, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFF9090);
    SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 19480, "signsurf", "sign", 0x00000000);
    tmpobjid = CreateDynamicObject(19742, 3603.632324, 1544.874023, 31.335432, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19742, 3603.632324, 1544.874023, 36.335433, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19742, 3603.632324, 1544.874023, 41.345474, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19742, 3603.632324, 1544.874023, 46.335494, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3609.864013, 1548.806762, 48.860736, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3622.353515, 1548.806762, 48.860736, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3634.852050, 1548.806762, 48.860736, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19752, 3643.764404, 1550.117431, 48.860736, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3645.060791, 1558.995849, 48.860736, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3646.371093, 1567.846069, 48.860736, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3651.680419, 1567.846069, 48.860736, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19742, 3648.999511, 1565.175659, 51.360729, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3652.980957, 1558.915771, 53.860736, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3652.980957, 1546.426635, 53.860736, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19770, 3652.980957, 1537.135864, 53.250747, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19771, 3652.980957, 1531.975952, 49.800796, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19752, 3654.300781, 1526.265502, 49.190792, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3663.212646, 1525.015258, 49.180717, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19743, 3669.461669, 1528.995605, 46.680725, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19752, 3672.111328, 1526.326049, 44.190723, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3673.412353, 1535.155517, 44.190696, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3674.711914, 1544.075927, 44.190696, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3680.031494, 1544.025878, 44.190696, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19752, 3682.650878, 1538.715087, 44.190696, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19752, 3687.980712, 1538.715087, 44.190696, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3690.612548, 1544.025878, 44.190696, -0.000014, 0.000000, -89.999954, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3695.932128, 1543.975830, 44.190696, 0.000000, -0.000014, 179.999908, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19752, 3698.561279, 1538.715087, 44.190696, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19752, 3703.890869, 1538.715087, 44.190696, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3705.192382, 1547.615722, 44.190696, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19761, 3705.192382, 1557.025268, 44.189697, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19761, 3705.192382, 1569.436401, 44.959682, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19761, 3705.192382, 1572.386230, 46.629680, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3705.187988, 1551.759521, -5.875778, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19761, 3705.192382, 1561.395874, 44.189697, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19745, 3701.218994, 1595.444824, 46.199687, -0.000007, 0.000000, 90.000022, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19737, 3705.192382, 1590.483764, 47.449672, -0.000007, 0.000000, 90.000022, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19737, 3705.192382, 1600.414062, 44.949699, -0.000007, 0.000000, 90.000022, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19738, 3705.192382, 1607.883422, 44.949699, -0.000007, 0.000000, 90.000022, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19764, 3703.209960, 1615.941894, 44.888706, -0.000007, 0.000000, 1035.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19745, 3698.638671, 1618.964477, 43.639698, -0.000007, 0.000000, 90.000022, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19745, 3698.638671, 1618.964477, 41.139709, -0.000007, 0.000000, 90.000022, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3702.638427, 1625.254516, 39.919700, -0.000007, 0.000000, 90.000022, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19752, 3701.337158, 1634.164550, 39.919700, -0.000007, 0.000000, 180.000030, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3692.438232, 1635.474365, 39.919700, -0.000007, 0.000000, 180.000030, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3683.539306, 1636.804321, 39.919700, -0.000007, 0.000000, 360.000030, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3683.539306, 1642.134521, 39.919700, -0.000007, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19742, 3686.199462, 1639.483642, 42.449680, -0.000007, 0.000000, 900.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3688.830078, 1642.154541, 44.949691, -0.000007, 0.000000, 900.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3690.136962, 1633.244140, 44.959701, -0.000007, 0.000000, 270.000030, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3688.830078, 1624.324462, 44.949691, -0.000007, 0.000000, 1530.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3679.937255, 1623.014038, 44.959701, -0.000007, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19769, 3670.576904, 1623.014038, 45.169689, -0.000007, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19761, 3664.675292, 1623.014038, 46.099678, -0.000007, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19769, 3658.403564, 1623.014038, 47.279140, -0.000007, 9.100000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19769, 3653.008789, 1623.014038, 49.468185, -0.000007, 19.999998, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19769, 3648.222900, 1623.014038, 52.569953, -0.000007, 30.899993, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3643.171142, 1624.284057, 54.529945, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19752, 3640.550537, 1629.603881, 54.529945, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19752, 3635.210449, 1629.603881, 54.529945, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3632.582031, 1624.284057, 54.529945, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19737, 3624.931884, 1622.974121, 54.529945, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3617.277343, 1624.284057, 54.529945, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19752, 3614.656738, 1629.603881, 54.529945, 0.000000, -0.000007, 179.999954, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19752, 3609.316650, 1629.603881, 54.529945, -0.000007, 0.000000, -89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3606.688232, 1624.284057, 54.529945, 0.000007, 0.000000, 89.999977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3601.356201, 1624.284057, 54.529945, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19743, 3596.056640, 1626.963989, 52.019943, 0.000000, 0.000007, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19737, 3600.031982, 1631.953613, 49.509918, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19752, 3598.726806, 1639.615478, 49.519912, 0.000000, -0.000007, 179.999954, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3593.427246, 1642.226196, 49.519912, 0.000000, -0.000007, 359.999938, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3593.427246, 1647.546752, 49.519912, 0.000000, -0.000007, 629.999938, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19752, 3598.726806, 1650.166015, 49.519912, 0.000000, -0.000007, 449.999938, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19752, 3598.726806, 1655.486816, 49.519912, 0.000000, -0.000007, 539.999938, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3593.427246, 1658.089355, 49.519912, 0.000000, 0.000000, -0.000060, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19753, 3593.427246, 1663.409912, 49.519912, -0.000007, -0.000007, -90.000038, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19752, 3598.726806, 1666.026245, 49.519912, 0.000000, -0.000007, 449.999938, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19754, 3595.906005, 1650.195556, 46.676715, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19754, 3595.906005, 1663.936401, 45.866760, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19752, 3598.726806, 1671.326782, 49.519912, 0.000000, -0.000007, 539.999938, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19769, 3592.943847, 1672.643798, 49.728927, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19767, 3586.832519, 1672.643798, 50.948932, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3577.493164, 1672.643798, 51.148918, 0.000000, 0.000000, 900.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3565.002685, 1672.643798, 51.148918, 0.000000, 0.000000, 900.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19738, 3556.251220, 1672.643798, 51.148918, 0.000000, 0.000000, 900.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19756, 3549.949218, 1672.420898, 47.790153, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19754, 3593.989990, 1672.407226, 43.556835, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19760, 3584.999511, 1672.407226, 43.556835, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19760, 3581.037109, 1672.407226, 43.556835, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19760, 3576.598632, 1672.407226, 43.556835, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19760, 3572.636230, 1672.407226, 43.556835, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19760, 3568.666748, 1672.407226, 43.556835, 0.000000, 0.000014, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3664.316162, 1623.014038, 42.379711, -0.000007, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19770, 3556.529296, 1672.420898, 47.190212, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19771, 3561.690917, 1672.420898, 43.740226, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3676.796630, 1623.014038, 42.379711, -0.000007, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19740, 3686.237060, 1623.015014, 42.377712, -0.000007, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(16139, 3705.995605, 1664.288452, 23.988256, 0.000000, 0.000000, 153.300003, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19344, "egg_texts", "easter_egg01", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19344, "egg_texts", "easter_egg02", 0x00000000);
    tmpobjid = CreateDynamicObject(16139, 3599.548583, 1680.600341, 22.553846, -6.000000, -10.899999, -41.800025, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19344, "egg_texts", "easter_egg03", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19344, "egg_texts", "easter_egg04", 0x00000000);
    tmpobjid = CreateDynamicObject(16139, 3618.852539, 1507.717285, 24.314001, -4.300001, 11.399996, -42.199977, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19344, "egg_texts", "easter_egg03", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19344, "egg_texts", "easter_egg04", 0x00000000);
    tmpobjid = CreateDynamicObject(16139, 3753.898925, 1522.656372, 22.792762, -7.599997, 14.600000, -52.700027, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19344, "egg_texts", "easter_egg04", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19344, "egg_texts", "easter_egg05", 0x00000000);
    tmpobjid = CreateDynamicObject(16139, 3866.656982, 1578.348144, 24.123218, 1.600000, 14.600000, -15.000026, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19344, "egg_texts", "easter_egg04", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19344, "egg_texts", "easter_egg05", 0x00000000);
    tmpobjid = CreateDynamicObject(16139, 3714.446777, 1471.042724, 15.078848, 0.000000, 10.399999, 153.300003, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19344, "egg_texts", "easter_egg01", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19344, "egg_texts", "easter_egg02", 0x00000000);
    tmpobjid = CreateDynamicObject(19741, 3543.020019, 1672.420898, 45.610157, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19741, 3549.310546, 1672.420898, 42.790161, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19741, 3543.128662, 1672.420898, 39.490207, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(18768, 3685.154052, 1563.399658, 132.689270, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 18901, "matclothes", "bandanazigzag", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(18771, 3684.243164, 1563.399658, 83.439277, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 18901, "matclothes", "bandanazigzag", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18771, 3684.243164, 1563.399658, 33.809261, 0.000000, 0.000000, 14.199996, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 18901, "matclothes", "bandanazigzag", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(19447, 3685.156738, 1573.850463, 133.251113, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(19411, 3685.156738, 1567.429565, 133.261108, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(19699, 3683.231201, 1563.912353, 120.775283, 0.000000, 90.000022, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(19699, 3685.220703, 1563.001464, 120.775283, 0.000000, 89.999977, 179.999862, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(19699, 3683.231201, 1563.912353, 95.795265, 0.000000, 90.000030, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(19699, 3685.220703, 1563.001464, 95.795265, 0.000000, 89.999969, 179.999816, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(19699, 3683.231201, 1563.912353, 70.785247, 0.000000, 90.000038, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(19699, 3685.220703, 1563.001464, 70.785247, 0.000000, 89.999961, 179.999771, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(19699, 3683.232177, 1563.913330, 57.495258, 0.000000, 90.000053, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(19699, 3685.220703, 1563.001464, 45.845272, 0.000000, 89.999954, 179.999725, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(19699, 3683.770996, 1562.462524, 120.775283, 0.000000, 90.000030, 89.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(19699, 3684.682128, 1564.452026, 120.775283, 0.000000, 89.999969, -90.000122, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(19699, 3683.770996, 1562.462524, 95.795265, 0.000000, 90.000038, 89.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(19699, 3684.682128, 1564.452026, 95.795265, 0.000000, 89.999961, -90.000167, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(19699, 3683.770996, 1562.462524, 70.785247, 0.000000, 90.000045, 89.999969, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(19699, 3684.682128, 1564.452026, 70.785247, 0.000000, 89.999954, -90.000213, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(19699, 3683.770019, 1562.463500, 57.495258, 0.000007, 90.000053, 89.999946, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(19699, 3684.682128, 1564.452026, 45.845272, 0.000000, 89.999946, -90.000259, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 3684.163330, 1563.117187, 40.339370, 0.000000, 0.000000, 33.399993, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(16667, 3665.787597, 1549.732299, 40.533363, 6.799999, 11.200000, 616.299987, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19344, "egg_texts", "easter_egg03", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19344, "egg_texts", "easter_egg01", 0x00000000);
    tmpobjid = CreateDynamicObject(19362, 3685.156738, 1565.008789, 133.260101, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18768, 3739.367431, 1563.399658, 84.539260, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 18901, "matclothes", "bandanazigzag", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(18768, 3794.226562, 1563.399658, 84.539260, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanazigzag", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 18901, "matclothes", "bandanazigzag", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 18901, "matclothes", "bandanazigzag", 0x00000000);
    tmpobjid = CreateDynamicObject(19278, 3810.783203, 1563.864868, 93.710800, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 18901, "matclothes", "bandanazigzag", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(19278, 3810.783203, 1563.864868, 56.710838, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
    SetDynamicObjectMaterial(tmpobjid, 2, 18901, "matclothes", "bandanazigzag", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 3, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 3773.391845, 1470.986206, 28.605417, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(1598, 3785.746582, 1474.309326, 33.977630, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 3783.370605, 1470.986206, 28.605417, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 3783.370605, 1480.955810, 28.605417, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18765, 3773.390380, 1480.955810, 28.605417, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18814, 3778.421386, 1476.046508, 21.185447, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "purpledirt1", 0x00000000);
    SetDynamicObjectMaterial(tmpobjid, 1, 19655, "mattubes", "purpledirt1", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3608.334960, 1548.812133, -1.205785, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3639.635009, 1548.812133, -1.205785, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3652.992431, 1561.322631, 3.734211, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3652.992431, 1540.331542, 3.734211, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3662.685546, 1525.007690, -0.995786, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3685.637451, 1537.467895, -5.875778, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3701.016357, 1537.467895, -5.875778, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19669, 3778.385253, 1475.882446, 48.958812, 180.000000, 0.000000, 49.600017, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19655, "mattubes", "purpledirt1", 0x00000000);
    tmpobjid = CreateDynamicObject(19756, 3778.972167, 1475.671752, 52.412639, 0.000000, 0.000000, -129.899993, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000000);
    tmpobjid = CreateDynamicObject(4206, 3778.421386, 1476.046508, 33.965454, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2212, "burger_tray", "chickenskin", 0x99FFFFFF);
    tmpobjid = CreateDynamicObject(1598, 3777.108154, 1483.369018, 33.977630, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    tmpobjid = CreateDynamicObject(1598, 3779.796386, 1475.929443, 33.977630, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    tmpobjid = CreateDynamicObject(1598, 3779.796386, 1470.729125, 33.977630, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    tmpobjid = CreateDynamicObject(1598, 3774.545410, 1473.999267, 33.977630, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    tmpobjid = CreateDynamicObject(1598, 3771.235351, 1477.799682, 33.977630, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    tmpobjid = CreateDynamicObject(1598, 3782.425537, 1477.799682, 33.977630, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    tmpobjid = CreateDynamicObject(1598, 3782.425537, 1483.230224, 33.977630, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    tmpobjid = CreateDynamicObject(1598, 3786.708007, 1478.800537, 33.977630, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    tmpobjid = CreateDynamicObject(1598, 3786.708007, 1471.250610, 33.977630, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    tmpobjid = CreateDynamicObject(1598, 3776.729003, 1468.500122, 33.977630, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    tmpobjid = CreateDynamicObject(1598, 3772.668701, 1481.120239, 33.977630, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 19058, "xmasboxes", "silk8-128x128", 0x00000000);
    tmpobjid = CreateDynamicObject(2643, 3778.083007, 1479.822631, 33.965732, -69.100028, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4810, "griffobs_las", "Gen_Log_End", 0xFFFF9020);
    tmpobjid = CreateDynamicObject(2643, 3779.023925, 1472.624389, 33.891353, -102.400085, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4810, "griffobs_las", "Gen_Log_End", 0xFFFF9020);
    tmpobjid = CreateDynamicObject(2643, 3783.587890, 1475.305908, 33.993907, -99.800056, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4810, "griffobs_las", "Gen_Log_End", 0xFFFF9020);
    tmpobjid = CreateDynamicObject(2643, 3773.596191, 1475.305908, 33.902141, -84.300056, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4810, "griffobs_las", "Gen_Log_End", 0xFFFF9020);
    tmpobjid = CreateDynamicObject(2643, 3775.067382, 1480.856445, 33.926292, -84.300056, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4810, "griffobs_las", "Gen_Log_End", 0xFFFF9020);
    tmpobjid = CreateDynamicObject(2643, 3776.185058, 1485.566528, 33.945396, -84.300056, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4810, "griffobs_las", "Gen_Log_End", 0xFFFF9020);
    tmpobjid = CreateDynamicObject(2643, 3780.717041, 1485.566528, 33.935283, -84.300056, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4810, "griffobs_las", "Gen_Log_End", 0xFFFF9020);
    tmpobjid = CreateDynamicObject(2643, 3783.498291, 1479.956665, 33.979614, -84.300056, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 4810, "griffobs_las", "Gen_Log_End", 0xFFFF9020);
    tmpobjid = CreateDynamicObject(2806, 3777.684326, 1481.646850, 33.935443, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(2806, 3777.684326, 1476.436889, 33.935443, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(2806, 3784.662841, 1476.436889, 33.935443, 0.000000, 0.000000, 135.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(2806, 3781.424072, 1479.675292, 33.935443, 0.000000, 0.000000, 225.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(2806, 3784.720947, 1482.970581, 33.935443, 0.000000, 0.000000, 315.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(2806, 3772.211181, 1470.462036, 33.935443, 0.000000, 0.000000, 315.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(2806, 3768.921386, 1473.749877, 33.935443, 0.000000, 0.000000, 405.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(2806, 3783.962646, 1470.419677, 33.935443, 0.000000, 0.000000, 405.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(2806, 3788.488525, 1474.945190, 33.935443, 0.000000, 0.000000, 495.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(2806, 3779.118408, 1484.314697, 33.935443, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(2806, 3772.137207, 1484.314697, 33.935443, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(2806, 3772.137207, 1466.125366, 33.935443, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(1303, 3779.925048, 1480.105346, 33.843700, 180.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2212, "burger_tray", "fries_cb", 0x00000000);
    tmpobjid = CreateDynamicObject(1303, 3786.395751, 1481.015869, 33.843700, 180.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2212, "burger_tray", "fries_cb", 0x00000000);
    tmpobjid = CreateDynamicObject(1303, 3783.316406, 1485.206054, 33.843700, 180.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2212, "burger_tray", "fries_cb", 0x00000000);
    tmpobjid = CreateDynamicObject(1303, 3783.736816, 1477.826049, 33.843700, 180.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2212, "burger_tray", "fries_cb", 0x00000000);
    tmpobjid = CreateDynamicObject(1303, 3781.985839, 1472.155639, 33.843700, 180.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2212, "burger_tray", "fries_cb", 0x00000000);
    tmpobjid = CreateDynamicObject(1303, 3787.867675, 1472.505981, 33.843700, 180.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2212, "burger_tray", "fries_cb", 0x00000000);
    tmpobjid = CreateDynamicObject(1303, 3775.955566, 1474.066650, 33.843700, 180.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2212, "burger_tray", "fries_cb", 0x00000000);
    tmpobjid = CreateDynamicObject(1303, 3778.245605, 1487.116455, 33.843700, 180.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2212, "burger_tray", "fries_cb", 0x00000000);
    tmpobjid = CreateDynamicObject(1303, 3778.245605, 1468.656494, 33.843700, 180.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2212, "burger_tray", "fries_cb", 0x00000000);
    tmpobjid = CreateDynamicObject(1303, 3769.601074, 1470.697631, 33.843700, 180.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2212, "burger_tray", "fries_cb", 0x00000000);
    tmpobjid = CreateDynamicObject(1303, 3769.601074, 1479.478515, 33.843700, 180.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 2212, "burger_tray", "fries_cb", 0x00000000);
    tmpobjid = CreateDynamicObject(856, 3780.781494, 1481.155273, 31.638277, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 804, "gta_proc_grasslanda", "veg_leaf", 0xFF20FF20);
    tmpobjid = CreateDynamicObject(856, 3780.781494, 1470.134277, 31.638277, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 804, "gta_proc_grasslanda", "veg_leaf", 0xFF20FF20);
    tmpobjid = CreateDynamicObject(856, 3773.501708, 1472.064208, 31.638277, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 804, "gta_proc_grasslanda", "veg_leaf", 0xFF20FF20);
    tmpobjid = CreateDynamicObject(856, 3772.232177, 1478.064819, 31.638277, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 804, "gta_proc_grasslanda", "veg_leaf", 0xFF20FF20);
    tmpobjid = CreateDynamicObject(19756, 3783.006591, 1471.197998, 34.648162, 0.789569, -37.392875, 67.567176, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(3499, 3785.734863, 1477.818481, 40.060596, 52.599998, 178.699966, 158.599990, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
    tmpobjid = CreateDynamicObject(19756, 3783.020263, 1471.232421, 34.599708, -0.789542, 37.392875, -112.432723, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0xFFFFFFFF);
    tmpobjid = CreateDynamicObject(3499, 3789.133300, 1485.809814, 46.697246, 52.599998, -1.299991, 158.599945, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
    SetDynamicObjectMaterial(tmpobjid, 1, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
    tmpobjid = CreateDynamicObject(19761, 3705.192382, 1565.256225, 44.459690, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19761, 3705.192382, 1574.835205, 48.689674, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19761, 3705.192382, 1577.355102, 50.659660, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 18901, "matclothes", "bandanaflag", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3705.187988, 1556.949829, -5.875778, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3705.187988, 1561.400634, -5.875778, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3705.187988, 1565.341918, -5.735775, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3705.187988, 1569.532958, -5.355772, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3705.187988, 1572.443359, -3.445772, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3705.187988, 1574.893554, -1.345774, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3705.187988, 1574.893554, -1.345774, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3705.187988, 1577.304321, 0.634225, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3705.187988, 1586.513549, -2.675774, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3705.187988, 1602.202636, -5.205774, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3702.657226, 1621.402832, -10.135784, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3695.264892, 1635.473510, -10.135784, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3690.116699, 1629.742675, -5.065771, 0.000000, 0.000000, 450.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3684.433837, 1623.032226, -5.065771, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3668.934326, 1623.032226, -4.775769, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3664.836181, 1623.032226, -4.105768, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3659.626464, 1623.032226, -3.205769, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3647.087402, 1623.032226, 3.114228, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3625.898681, 1622.982177, 4.534231, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3637.929931, 1630.933471, 4.534231, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3603.768066, 1623.012207, 4.534231, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3600.045898, 1628.752807, -0.545767, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3600.045898, 1652.914428, -0.545767, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3600.045898, 1668.954345, -0.545767, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3593.726318, 1672.625488, -0.455767, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3584.895996, 1672.405273, -6.565766, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3581.005615, 1672.405273, -6.565766, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3576.664062, 1672.405273, -6.565766, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3572.634033, 1672.405273, -6.565766, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3568.783203, 1672.405273, -6.565766, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3561.676269, 1672.625488, 1.034232, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3556.539062, 1672.405273, -2.955769, 0.000000, 0.000000, 720.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3595.924560, 1649.813598, -3.865767, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(19757, 3595.924560, 1663.943603, -4.795764, 0.000000, 0.000000, 630.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 14651, "ab_trukstpd", "Bow_bar_pool_tablebase", 0x00000000);
    tmpobjid = CreateDynamicObject(18763, 3758.154785, 1562.471069, 86.709526, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18763, 3761.114013, 1562.471069, 89.699523, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18763, 3766.093750, 1562.471069, 92.659530, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18763, 3770.083740, 1562.471069, 90.519477, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18763, 3771.082519, 1562.471069, 86.529502, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3759.804931, 1555.262695, 85.203323, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3761.935791, 1551.922729, 87.103324, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3766.558593, 1551.922729, 87.103324, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18763, 3766.558593, 1555.983520, 88.413299, 0.000000, 0.000007, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3772.963378, 1555.983520, 87.103324, 0.000000, 90.000022, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18762, 3776.953613, 1555.983520, 87.103324, 0.000000, 0.000022, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18766, 3763.438476, 1572.460083, 86.171455, 0.000000, 0.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18766, 3770.928955, 1572.460083, 86.171455, 0.000000, 90.000000, 540.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(19362, 3685.156738, 1573.350463, 130.950103, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18767, 3732.640625, 1556.433349, 34.592678, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18767, 3733.232177, 1556.433349, 39.402675, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18766, 3724.388916, 1554.960327, 44.096138, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18766, 3728.882080, 1547.169311, 46.426139, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(18766, 3746.325927, 1547.169311, 46.426139, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(13120, 3600.586669, 1640.088745, -12.395377, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(13120, 3651.835693, 1712.318603, -10.065373, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00); 
    
    tmpobjid = CreateDynamicObject(19341, 3639.874023, 1518.313964, 38.529338, 0.000000, 31.000022, 0.000000, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3637.379638, 1518.480957, 40.809307, 0.000001, 31.000022, 159.999893, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3680.761474, 1534.758300, 42.259994, 0.000000, 31.000038, 19.999998, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3678.360351, 1534.062011, 44.539962, 0.000007, 31.000007, 179.999801, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3724.310302, 1503.607666, 37.974212, 0.000004, 31.000053, 69.999984, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3723.300292, 1501.320800, 40.254180, 0.000007, 30.999992, -130.000228, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3757.552490, 1551.715454, 37.596508, 0.000018, 31.000057, -110.000007, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3758.562500, 1554.002319, 39.876476, -0.000003, 30.999980, 49.999744, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3795.199707, 1463.447265, 38.193511, 0.000012, 31.000055, -109.999984, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3796.209716, 1465.734130, 40.473480, 0.000000, 30.999986, 49.999732, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(5820, 3812.599853, 1648.793701, 5.388749, 0.000001, -0.000007, 163.599914, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3857.499267, 1551.543823, 32.129814, 0.000004, 31.000053, -109.999961, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3858.509277, 1553.830688, 34.409782, 0.000007, 30.999992, 49.999732, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3816.996093, 1531.932983, 33.916015, -0.000003, 31.000059, -19.999969, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3814.709228, 1532.942993, 36.195983, 0.000018, 30.999992, 139.999694, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3860.917968, 1596.733764, 32.338863, -0.000007, 31.000066, -19.999969, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3858.631103, 1597.743774, 34.618831, 0.000023, 30.999986, 139.999694, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3785.389404, 1643.693115, 29.585935, -0.000007, 31.000066, -19.999969, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3783.102539, 1644.703125, 31.865903, 0.000023, 30.999986, 139.999694, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3741.084472, 1662.199462, 37.850334, -0.000009, 31.000074, 70.000015, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3740.074707, 1659.912597, 40.130302, 0.000028, 30.999980, -130.000289, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3688.705566, 1663.321289, 34.148078, -0.000001, 31.000076, 159.999969, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3690.992431, 1662.311523, 36.428047, 0.000022, 30.999975, -40.000286, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3673.720703, 1602.509277, 47.830539, 0.000000, 31.000068, -105.800010, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3674.560302, 1604.863891, 50.110507, 0.000017, 30.999980, 54.199695, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3747.881591, 1583.695068, 48.792495, -0.000007, 31.000066, -15.800013, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3745.526855, 1584.534667, 51.072463, 0.000023, 30.999984, 144.199645, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3699.176269, 1618.251831, 43.618335, -0.000009, 31.000074, -15.800012, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3696.821533, 1619.091430, 45.898303, 0.000028, 30.999979, 144.199645, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3655.435791, 1573.907470, 55.457946, -0.000011, 31.000082, -15.800012, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3653.081054, 1574.747070, 57.737915, 0.000031, 30.999973, 144.199645, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3599.790527, 1533.658813, 37.020561, -0.000011, 31.000082, -15.800012, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19341, 3597.435791, 1534.498413, 39.300529, 0.000031, 30.999973, 144.199645, -1, -1, -1, 300.00, 300.00); 
    tmpobjid = CreateDynamicObject(19741, 3824.549560, 1607.550659, 55.868682, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(19741, 3824.549560, 1602.290771, 52.418685, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(19741, 3824.549560, 1607.390869, 48.558692, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(19741, 3824.549560, 1602.290771, 44.438678, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(19741, 3824.549560, 1607.390869, 39.268688, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(19741, 3824.549560, 1602.290771, 34.038673, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 3967, "cj_airprt", "CJ_BLACK_RUB2", 0x00000000);
    tmpobjid = CreateDynamicObject(19133, 3700.519531, 1564.523559, 134.453308, 59.300006, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);

    for(new i = 0; i < MAX_PLAYERS; i++)
    { 
        if(!IsPlayerConnected(i)) continue; 
        OnPlayerConnect(i); 
    } 

    return 1; 

} 

public OnFilterScriptExit()
{ 
	KillTimer(wallstimer);
	KillTimer(pltftimer);
	db_close(eggs_db);
} 



public OnPlayerConnect(playerid)
{
	ClearVars(playerid);
	
	EggHUD[0] = CreatePlayerTextDraw(playerid,56.000000, 328.000000, "Eggs: 0");
	PlayerTextDrawBackgroundColor(playerid,EggHUD[0], 255);
	PlayerTextDrawFont(playerid,EggHUD[0], 3);
	PlayerTextDrawLetterSize(playerid,EggHUD[0], 0.450000, 1.100000);
	PlayerTextDrawColor(playerid,EggHUD[0], 9449727);
	PlayerTextDrawSetOutline(playerid,EggHUD[0], 1);
	PlayerTextDrawSetProportional(playerid,EggHUD[0], 1);
	PlayerTextDrawSetSelectable(playerid,EggHUD[0], 0);

	EggHUD[1] = CreatePlayerTextDraw(playerid,56.000000, 319.000000, "00:00");
	PlayerTextDrawBackgroundColor(playerid,EggHUD[1], 255);
	PlayerTextDrawFont(playerid,EggHUD[1], 2);
	PlayerTextDrawLetterSize(playerid,EggHUD[1], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,EggHUD[1], -10485505);
	PlayerTextDrawSetOutline(playerid,EggHUD[1], 1);
	PlayerTextDrawSetProportional(playerid,EggHUD[1], 1);
	PlayerTextDrawSetSelectable(playerid,EggHUD[1], 0);

	EggHUD[2] = CreatePlayerTextDraw(playerid,29.000000, 313.000000, "egg");
	PlayerTextDrawBackgroundColor(playerid,EggHUD[2], 0);
	PlayerTextDrawFont(playerid,EggHUD[2], 5);
	PlayerTextDrawLetterSize(playerid,EggHUD[2], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,EggHUD[2], 16777215);
	PlayerTextDrawSetOutline(playerid,EggHUD[2], 0);
	PlayerTextDrawSetProportional(playerid,EggHUD[2], 1);
	PlayerTextDrawSetShadow(playerid,EggHUD[2], 0);
	PlayerTextDrawUseBox(playerid,EggHUD[2], 1);
	PlayerTextDrawBoxColor(playerid,EggHUD[2], 0);
	PlayerTextDrawTextSize(playerid,EggHUD[2], 26.000000, 27.000000);
	PlayerTextDrawSetPreviewModel(playerid, EggHUD[2], 19343);
	PlayerTextDrawSetPreviewRot(playerid, EggHUD[2], 0.000000, 0.000000, -55.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid,EggHUD[2], 0);
	return 1;
} 

public OnPlayerDisconnect(playerid, reason)
{
    PlayerTextDrawDestroy(playerid, EggHUD[0]);
    PlayerTextDrawDestroy(playerid, EggHUD[1]);
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
    if(success)
    {
        new pip[16];
        for(new i = GetPlayerPoolSize(); i != -1; --i) //Loop through all players
        {
            GetPlayerIp(i, pip, sizeof(pip));
            if(!strcmp(ip, pip, true)) //If a player's IP is the IP that failed the login
            {
                if(!eggLabels) EggLabels(true);
            }
        }
    }
    return 1;
}
public OnPlayerSpawn(playerid)
{
    #if JOIN_TP == true
	if(EggHunt && atEggHunt[playerid])
    {
		respawn_timer[playerid] = SetTimerEx("DelaySpawn",500,false,"i",playerid);
    }
    #endif
    return 1;
}

function DelaySpawn(playerid)
{
	new r = pSpawn[playerid];
	//KillTimer
	KillTimer(respawn_timer[playerid]);
	
	//Teleport Player
	SetPlayerPos(playerid,cp_pos[r][0],cp_pos[r][1],cp_pos[r][2]);
 	SetPlayerFacingAngle(playerid,cp_pos[r][3]);
  	SetCameraBehindPlayer(playerid);
   	SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
	return 1;
}

////////////////////////// EGGY COMMANDS ///////////////////////////////////////

CMD:gotoeh(playerid, params[])
{
	#pragma unused params
	#if ADMIN_REQ == true
	if(!IsPlayerAdmin(playerid))return SCM(playerid,c_warn, m_admin);
	#endif

	SetPlayerPos(playerid,3634.7517,1517.7566,30.3753);
	SetPlayerFacingAngle(playerid,329.8396);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	return 1;
}

CMD:cegg(playerid, params[])
{
	#pragma unused params
	#if ADMIN_REQ == true
	if(!IsPlayerAdmin(playerid))return SCM(playerid,c_warn, m_admin);
	#endif
	if(EggHunt)return SCM(playerid, c_warn, "(!) You can't edit the eggs while the event is running!");
	if(eggcount == MAX_EGGS-1)return SCM(playerid, c_warn, "(!) You can't add any more eggs!");
	new Float:pPos[3];
	GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
	CreateEgg(pPos[0], pPos[1], pPos[2]);

	SCM(playerid, c_result, "[EH] - New egg created.");
	return 1;
}

CMD:degg(playerid, params[])
{
    #if ADMIN_REQ == true
	if(!IsPlayerAdmin(playerid))return SCM(playerid,c_warn, m_admin);
	#endif
	if(EggHunt)return SCM(playerid, c_warn, "(!) You can't edit the eggs while the event is running!");

	new eggid;
	if(sscanf(params,"d", eggid))return SCM(playerid, c_cmd, "[EH] - Type: /degg [EggID]");
	if(!egg_info[eggid][valid] || !IsValidDynamicPickup(Egg[eggid]))return SCM(playerid, c_warn, "(!) Invalid Egg ID!");

	DeleteEgg(eggid);

	new msg[64];
	format(msg, sizeof(msg), "[EH] - Egg %d was deleted.", eggid);
	SCM(playerid, c_result, msg);
	return 1;
}

CMD:epos(playerid, params[])
{
    #if ADMIN_REQ == true
	if(!IsPlayerAdmin(playerid))return SCM(playerid,c_warn, m_admin);
	#endif
	if(EggHunt)return SCM(playerid, c_warn, "(!) You can't edit the eggs while the event is running!");

	new eggid;
	if(sscanf(params,"d", eggid))return SCM(playerid, c_cmd, "[EH] - Type: /epos [EggID]");
	if(!egg_info[eggid][valid] || !IsValidDynamicPickup(Egg[eggid]))return SCM(playerid, c_warn, "(!) Invalid Egg ID!");

	//Load player's coords into the vars
	GetPlayerPos(playerid, egg_info[eggid][posx], egg_info[eggid][posy], egg_info[eggid][posz]);

	//Updating Pickup Pos
	Streamer_SetFloatData(1, Egg[eggid], E_STREAMER_X, egg_info[eggid][posx]);
	Streamer_SetFloatData(1, Egg[eggid], E_STREAMER_Y, egg_info[eggid][posy]);
	Streamer_SetFloatData(1, Egg[eggid], E_STREAMER_Z, egg_info[eggid][posz]);

	//Updating 3DLabel Pos
	if(eggLabels)
	{
		Streamer_SetFloatData(5, EggLabel[eggid], E_STREAMER_X, egg_info[eggid][posx]);
		Streamer_SetFloatData(5, EggLabel[eggid], E_STREAMER_Y, egg_info[eggid][posy]);
		Streamer_SetFloatData(5, EggLabel[eggid], E_STREAMER_Z, egg_info[eggid][posz]);
	}

	//Save In DB
	new query[300];
	format(query,sizeof(query),"UPDATE `eggs` SET `posx` = '%f', `posy` = '%f', `posz` = '%f' WHERE `eggid` = '%d'",
	egg_info[eggid][posx], egg_info[eggid][posy], egg_info[eggid][posz], eggid);
	db_free_result(db_query(eggs_db,query));

	new msg[128];
	format(msg, sizeof(msg),"[EH] - Egg %d position updated.");
	SCM(playerid, c_result, msg);
	return 1;
}

CMD:elabels(playerid, params[])
{
    #pragma unused params
	#if ADMIN_REQ == true
	if(!IsPlayerAdmin(playerid))return SCM(playerid,c_warn, m_admin);
	#endif

	if(eggLabels)
	{
	    SCM(playerid, c_result, "[EH] - Egg labels hidden.");
		EggLabels(false);
	}
	else
	{
	    if(EggHunt)return SCM(playerid, c_warn, "(!) You can't edit the eggs while the event is running!");
	    SCM(playerid, c_result, "[EH] - Egg labels displayed.");
		EggLabels(true);
	}
	return 1;
}

////////////////////////////////STOCKS//////////////////////////////////////////

stock PlaySoundForAll(soundid)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        PlayerPlaySound(i,soundid,0,0,0);
	    }
	}
	return 1;
}

stock strmatch(const String1[], const String2[])
{
    if ((strcmp(String1, String2, true, strlen(String2)) == 0) && (strlen(String2) == strlen(String1)))
    {
        return true;
    }
    else
    {
        return false;
    }
}

stock GetPlayerHighestScores(array[][rankingEnum], left, right)
{
    new
        tempLeft = left,
        tempRight = right,
        pivot = array[(left + right) / 2][player_Score],
        tempVar
    ;
    while(tempLeft <= tempRight)
    {
        while(array[tempLeft][player_Score] > pivot) tempLeft++;
        while(array[tempRight][player_Score] < pivot) tempRight--;

        if(tempLeft <= tempRight)
        {
            tempVar = array[tempLeft][player_Score], array[tempLeft][player_Score] = array[tempRight][player_Score], array[tempRight][player_Score] = tempVar;
            tempVar = array[tempLeft][player_ID], array[tempLeft][player_ID] = array[tempRight][player_ID], array[tempRight][player_ID] = tempVar;
            tempLeft++, tempRight--;
        }
    }
    if(left < tempRight) GetPlayerHighestScores(array, left, tempRight);
    if(tempLeft < right) GetPlayerHighestScores(array, tempLeft, right);
}

stock pname(playerid)
{
	new name[32];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

///////////////////////////////OTHER FUNCTIONS//////////////////////////////////

function MoveWalls()
{
	if(wstate)
	{
	    MoveDynamicObject(mwall[0], 3817.752441, 1507.720581, 46.760246, 10);
	    MoveDynamicObject(mwall[1], 3822.343017, 1516.291015, 46.760246, 10);

    	MoveDynamicObject(mwall[2], 3799.752197, 1573.723022, 91.410224, 10);
	    MoveDynamicObject(mwall[3], 3789.750732, 1552.921875, 91.410224, 10);
	    MoveDynamicObject(mwall[4], 3783.452636, 1568.912719, 99.740203, 10);
	    MoveDynamicObject(mwall[5], 3804.814453, 1558.911254, 99.740203, 10);
	    MoveDynamicObject(mwall[6], 3799.752197, 1552.961425, 108.350128, 10);
	    MoveDynamicObject(mwall[7], 3789.750732, 1573.082885, 108.350128, 10);
	    MoveDynamicObject(mwall[8], 3804.736083, 1568.912719, 115.620155, 10);
	    MoveDynamicObject(mwall[9], 3783.497070, 1558.911254, 115.620155, 10);
	    MoveDynamicObject(mwall[10], 3799.752197, 1572.962158, 124.230079, 10);
	    MoveDynamicObject(mwall[11], 3789.750732, 1552.931152, 124.230079, 10);

	    MoveDynamicObject(platform[1], 3681.181884, 1481.425048, 25.620777, 6);
	    MoveDynamicObject(platform[2], 3698.701904, 1483.076049, 15.040745, 6);
	    MoveDynamicObject(platform[3], 3717.631835, 1483.076049, 25.620777, 6);
	    MoveDynamicObject(platform[4], 3735.893066, 1483.076049, 15.040745, 6);
	    wstate = false;
	}
	else
	{
	    MoveDynamicObject(mwall[0], 3817.752441, 1511.620605, 46.760246, 10);
	    MoveDynamicObject(mwall[1], 3826.523437, 1516.291015, 46.760246, 10);

	    MoveDynamicObject(mwall[2], 3799.752197, 1552.742187, 91.410224, 10);
	    MoveDynamicObject(mwall[3], 3789.750732, 1573.742797, 91.410224, 10);
	    MoveDynamicObject(mwall[4], 3804.806884, 1568.912719, 99.740203, 10);
	    MoveDynamicObject(mwall[5], 3783.653076, 1558.911254, 99.740203, 10);
	    MoveDynamicObject(mwall[6], 3799.752197, 1573.082031, 108.350128, 10);
	    MoveDynamicObject(mwall[7], 3789.750732, 1552.112548, 108.350128, 10);
	    MoveDynamicObject(mwall[8], 3783.516113, 1568.912719, 115.620155, 10);
	    MoveDynamicObject(mwall[9], 3804.900878, 1558.911254, 115.620155, 10);
	    MoveDynamicObject(mwall[10], 3799.752197, 1552.932006, 124.230079, 10);
	    MoveDynamicObject(mwall[11], 3789.750732, 1573.121948, 124.230079, 10);

	    MoveDynamicObject(platform[1], 3681.181884, 1481.425048, 15.070780, 6);
	    MoveDynamicObject(platform[2], 3698.701904, 1483.076049, 25.640762, 6);
	    MoveDynamicObject(platform[3], 3717.631835, 1483.076049, 15.640782, 6);
	    MoveDynamicObject(platform[4], 3735.893066, 1483.076049, 25.130784, 6);
	    wstate = true;
	}
	return 1;
}



function MovePlatforms()
{
	if(pstate)
	{
	    MoveDynamicObject(platform[0],3794.226562, 1563.399658, 84.539260, 3);

	    /*MoveObject(spinner[0],3795.014160, 1563.911987, 131.630096+0.0001, 0.0001, 90, 0, 180);
	    MoveObject(spinner[1],3795.014160, 1563.911987, 136.970138+0.0001, 0.0001, 90, 0, 270);*/
	    pstate = false;
	}
	else
	{
	    MoveDynamicObject(platform[0],3794.226562, 1563.399658, 84.539260+55, 3);

	    /*MoveObject(spinner[0],3795.014160, 1563.911987, 131.630096-0.0001, 0.0001, 90, 0, 0);
	    MoveObject(spinner[1],3795.014160, 1563.911987, 136.970138-0.0001, 0.0001, 90, 0, 0);*/
	    pstate = true;
	}
	return 1;
}

function EggHuntTimer()
{
	if(EggHunt)
	{
	    //Update Time
		ehTime --;
		new time[8];
		format(time,sizeof(time),"%02d:%02d",ehTime/60, ehTime%60);
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
		    if(IsPlayerConnected(i) && atEggHunt[i])
		    {
		        PlayerTextDrawSetString(i, EggHUD[1],time);
		    }
		}
		if(ehTime == EGG_HUNT_TIME/2)
		{
		    SendClientMessageToAll(c_cmd,"[Event]: Half of the time in the Egg Hunt has passed! Hurry up! Collect 'em all!");
		    PlaySoundForAll(1057);
		}
		
	 	if(ehTime <= 0)//Time's Up
	  	{
	  	    //Pick Winner (This bit of code is not created by myself)
			new
				playerScores[MAX_PLAYERS][rankingEnum],
				index;
			for(new i; i != MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i) && atEggHunt[i])
				{
					playerScores[index][player_Score] = pEggs[i];
					playerScores[index++][player_ID] = i;
				}
			}
			GetPlayerHighestScores(playerScores, 0, index);
			
			for(new i; i < 3; ++i)
			{
				if(i < index)
				{
				    new score_Text[256], player_Name[MAX_PLAYER_NAME];
					GetPlayerName(playerScores[i][player_ID], player_Name, sizeof(player_Name));
					format(score_Text, sizeof(score_Text), "[Event]: The Egg Hunt ended! The winner is %s with a total of %d eggs collected.",player_Name, playerScores[i][player_Score]);
					SendClientMessageToAll(c_result,score_Text);
					PlaySoundForAll(1058);
					break;
				}
				else
				{
					SendClientMessageToAll(c_result,"[Event]: The Egg Hunt has come to an end! Unfortunately no eggs were collected.");
					PlaySoundForAll(1058);
				}
			}
			
			//End Event
	  	    EggHunt = false;
	  	    ResetEggs();
	  	    //Kill Timers
			KillTimer(ehTimer);
			KillTimer(wallstimer);
			KillTimer(pltftimer);
			
			//Respawn Players
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i) && atEggHunt[i])
				{
				    #if JOIN_TP == true
				    SpawnPlayer(i);
				    #endif
					ClearVars(i);
					EggHuntHUD(i);
				}
			}
	  	}
  	}
	return 1;
}

function ClearVars(playerid)
{
	atEggHunt[playerid] = false;
	pEggs[playerid] = 0;
	pSpawn[playerid] = 0;
	return 1;
}

