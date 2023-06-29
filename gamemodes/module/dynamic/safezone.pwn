//============================================================================//
// SAFEZONE SYSTEM - ADRIAN
//============================================================================//
#define MAX_GREENZONES 				100

enum gzData
{
	GZID,
	GZExists,
	Float:GZPos[3],
	Text3D:GZText,
	GZPickup,
	Float:GZRange
};

new GZData[MAX_GREENZONES][gzData];

stock Greenzone_Refresh(speedid)
{
	if(speedid != -1 && GZData[speedid][GZExists])
	{
	    if(IsValidDynamic3DTextLabel(GZData[speedid][GZText]))
	        DestroyDynamic3DTextLabel(GZData[speedid][GZText]);

        if(IsValidDynamicPickup(GZData[speedid][GZPickup]))
	        DestroyDynamicPickup(GZData[speedid][GZPickup]);

		new
			string[128];
		format(string, sizeof(string), "Greenzone (%d)\n"YELLOW"Range: %.2f\n"RED"Punishment Activated", speedid, GZData[speedid][GZRange]);
		GZData[speedid][GZText] = CreateDynamic3DTextLabel(string, COLOR_GREY, GZData[speedid][GZPos][0], GZData[speedid][GZPos][1], GZData[speedid][GZPos][2], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

		GZData[speedid][GZPickup] = CreateDynamicPickup(19134, 1, GZData[speedid][GZPos][0], GZData[speedid][GZPos][1], GZData[speedid][GZPos][2], .worldid = 0, .interiorid = 0);
	}
	return 1;
}

stock Greenzone_Save(speedid)
{
	new
	    query[255];

	format(query, sizeof(query), "UPDATE `greenzone` SET `gzrange` = '%.4f', `gzX` = '%.4f', `gzY` = '%.4f', `gzZ` = '%.4f' WHERE `gzID` = '%d'",
	    GZData[speedid][GZRange],
	    GZData[speedid][GZPos][0],
	    GZData[speedid][GZPos][1],
	    GZData[speedid][GZPos][2],
	    GZData[speedid][GZID]
	);
	return mysql_tquery(connectionID, query);
}

stock Greenzone_Delete(speedid)
{
    if(speedid != -1 && GZData[speedid][GZExists])
	{
	    new
	        string[64];

        if(IsValidDynamic3DTextLabel(GZData[speedid][GZText]))
	        DestroyDynamic3DTextLabel(GZData[speedid][GZText]);

        if(IsValidDynamicPickup(GZData[speedid][GZPickup]))
	        DestroyDynamicPickup(GZData[speedid][GZPickup]);

		format(string, sizeof(string), "DELETE FROM `greenzone` WHERE `gzID` = '%d'", GZData[speedid][GZID]);
		mysql_tquery(connectionID, string);

		GZData[speedid][GZExists] = false;
		GZData[speedid][GZRange] = 0.0;
		GZData[speedid][GZID] = 0;
	}
	return 1;
}

stock Greenzone_Create(playerid, Float:range)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(playerid, x, y, z);

	for (new i = 0; i < MAX_GREENZONES; i ++) if(!GZData[i][GZExists])
	{
	    GZData[i][GZExists] = true;
	    GZData[i][GZRange] = range;

		GZData[i][GZPos][0] = x;
	    GZData[i][GZPos][1] = y;
	    GZData[i][GZPos][2] = z;

	    Greenzone_Refresh(i);
	    mysql_tquery(connectionID, "INSERT INTO `greenzone` (`gzrange`) VALUES(0.0)", "OnGreenzoneCreated", "d", i);
	    return i;
	}
	return -1;
}

forward OnGreenzoneCreated(speedid);
public OnGreenzoneCreated(speedid)
{
	if(speedid == -1 || !GZData[speedid][GZExists])
	    return 0;

	GZData[speedid][GZID] = cache_insert_id(connectionID);
	Greenzone_Save(speedid);

	return 1;
}

stock Greenzone_Nearest(playerid)
{
	for (new i = 0; i < MAX_GREENZONES; i ++) if(GZData[i][GZExists] && IsPlayerInRangeOfPoint(playerid, GZData[i][GZRange], GZData[i][GZPos][0], GZData[i][GZPos][1], GZData[i][GZPos][2]))
	    return i;

	return -1;
}

/*stock SZ_OnPlayerKeyState(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_FIRE) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && Greenzone_Nearest(playerid) != -1 && CanPlayerUseAnims(playerid) && !IsLawEnforcement(playerid))
	{
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 2.0, 0, 0, 0, 0, 0);
	}
}

stock SZ_OnPlayerUpdate(playerid)
{
	if(Greenzone_Nearest(playerid) != -1)
	{
		SetPlayerArmedWeapon(playerid, 0);
	}
}

stock SZ_OnPlayerDamage(&playerid, &Float:amount, &issuerid, &weapon, &bodypart)
{
    if(issuerid != INVALID_PLAYER_ID)
    {
		if(Greenzone_Nearest(playerid) != -1)
		{
			GameTextForPlayer(issuerid, "That Player is in the parameter of the safezone", 5000, 5);
			return 0;
		}
		if(Greenzone_Nearest(issuerid) != -1)
		{
			GameTextForPlayer(issuerid, "You are in the parameter of the safezone", 5000, 5);
			return 0;
		}
	}
	return 1;
}*/

CMD:createsafezone(playerid, params[])
{
	static
	    id = -1,
		range;

    if(PlayerInfo[playerid][pAdmin] < 5 && !PlayerInfo[playerid][pCSR])
	{
		return SCM(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(sscanf(params, "d", range))
	{
	    SCM(playerid, COLOR_LIGHTBLUE, "Usage: "WHITE"/createsafezone [range]");
		return 1;
	}
	if(range < 1 || range > 85)
	    return SCM(playerid, COLOR_SYNTAX, "The specified type can't be below 1 or above 85.");

	id = Greenzone_Create(playerid, range);

	if(id == -1)
	    return SCM(playerid, COLOR_SYNTAX, "The server has reached the limit for greenzone.");

	SM(playerid, COLOR_LIME, "[Safezone System]: "WHITE"You have successfully created greenzone ID: %d.", id);
	return 1;
}

CMD:destroysafezone(playerid, params[])
{
	static
	    id = 0;

    if(PlayerInfo[playerid][pAdmin] < 5 && !PlayerInfo[playerid][pCSR])
		return SCM(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	if(sscanf(params, "d", id))
	    return SCM(playerid, COLOR_LIGHTBLUE, "Usage: "WHITE"/destroysafezone [greenzone id]");

	if((id < 0 || id >= MAX_GREENZONES) || !GZData[id][GZExists])
	    return SCM(playerid, COLOR_SYNTAX, "You have specified an invalid greenzone ID.");

	Greenzone_Delete(id);
	SM(playerid, COLOR_LIME, "[Safezone System]: "WHITE"You have successfully destroyed greenzone ID: %d.", id);
	return 1;
}
