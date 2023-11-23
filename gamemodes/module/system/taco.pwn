forward StopGetFrozenBeef(playerid);
public StopGetFrozenBeef(playerid)
{
    SetPlayerAttachedObject(playerid, 4, 2806, 1, 0.184699, 0.426247, 0.000000, 259.531341, 80.949592, 0.000000, 0.476124, 0.468181, 0.470769);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.0, 0, 0, 0, 0, 0, 1);
    SCM(playerid, COLOR_WHITE, "You successfully get the Frozen Beef from the Refrigerator");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Frozen Beef from the Refrigerator.", GetRPName(playerid));
    PlayerInfo[playerid][pFrozenBeef] = 1;
    ClearAnimations(playerid, 1);
}

forward StopGetFrozenPork(playerid);
public StopGetFrozenPork(playerid)
{
    SetPlayerAttachedObject(playerid, 4, 2804, 1, 0.184699, 0.426247, 0.000000, 259.531341, 80.949592, 0.000000, 0.476124, 0.468181, 0.470769);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.0, 0, 0, 0, 0, 0, 1);
    SCM(playerid, COLOR_WHITE, "You successfully get the Frozen Pork from the Refrigerator");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Frozen Pork from the Refrigerator.", GetRPName(playerid));
    PlayerInfo[playerid][pFrozenPork] = 1;
    ClearAnimations(playerid, 1);
}

forward StopChoppingBeef(playerid);
public StopChoppingBeef(playerid)
{
    RemovePlayerAttachedObject(playerid, 4);
    SetPlayerAttachedObject(playerid, 1, 2805, 6, 0.308999, 0.020000, 0.000000, 15.600001, -103.199974, -2.500001, 1.000000, 1.000000, 1.000000);
    SCM(playerid, COLOR_WHITE, "You successfully chop the Frozen Beef.");
    SCM(playerid, COLOR_WHITE, "You can now cook the chopped Beef on the Cooking Area");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has chopped the Frozen Beef Successfully.", GetRPName(playerid));
    PlayerInfo[playerid][pFrozenBeef] = 0;
    PlayerInfo[playerid][pChopBeef] = 1;
    ClearAnimations(playerid, 1);
}

forward StopChoppingPork(playerid);
public StopChoppingPork(playerid)
{
    RemovePlayerAttachedObject(playerid, 4);
    SetPlayerAttachedObject(playerid, 1, 2805, 6, 0.308999, 0.020000, 0.000000, 15.600001, -103.199974, -2.500001, 1.000000, 1.000000, 1.000000);
    SCM(playerid, COLOR_WHITE, "You successfully chop the Frozen Pork.");
    SCM(playerid, COLOR_WHITE, "You can now cook the chopped Pork on the Cooking Area");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has chopped the Frozen Pork Successfully", GetRPName(playerid));
    PlayerInfo[playerid][pFrozenPork] = 0;
    PlayerInfo[playerid][pChopPork] = 1;
    ClearAnimations(playerid, 1);
}

forward StopMakingCocaCola(playerid);
public StopMakingCocaCola(playerid)
{
    SetPlayerAttachedObject(playerid, 4, 2219, 1, 0.184699, 0.426247, 0.000000, 259.531341, 80.949592, 0.000000, 0.476124, 0.468181, 0.470769);
    SCM(playerid, COLOR_WHITE, "You successfully make a CocaCola Drinks from the Drinks Machine");
    SCM(playerid, COLOR_WHITE, "The drink that you prepare automatically stored in the stocks");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has make CocaCola from the Drinks Machine", GetRPName(playerid));
    ClearAnimations(playerid, 1);
	TacoShopInfo[PlayerInfo[playerid][pFaction]][CocaColaMenu] += 1;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET cocacolamenu = %i WHERE id = %i", TacoShopInfo[PlayerInfo[playerid][pFaction]][CocaColaMenu], PlayerInfo[playerid][pFaction]);
	mysql_tquery(connectionID, queryBuffer);
}

forward StopMakingPepsi(playerid);
public StopMakingPepsi(playerid)
{
    SetPlayerAttachedObject(playerid, 4, 2219, 1, 0.184699, 0.426247, 0.000000, 259.531341, 80.949592, 0.000000, 0.476124, 0.468181, 0.470769);
    SCM(playerid, COLOR_WHITE, "You successfully make a Pepsi Drinks from the Drinks Machine");
    SCM(playerid, COLOR_WHITE, "The drink that you prepare automatically stored in the stocks");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has make Pepsi from the Drinks Machine", GetRPName(playerid));
    ClearAnimations(playerid, 1);
	TacoShopInfo[PlayerInfo[playerid][pFaction]][PepsiMenu] += 1;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET pepsimenu = %i WHERE id = %i", TacoShopInfo[PlayerInfo[playerid][pFaction]][PepsiMenu], PlayerInfo[playerid][pFaction]);
	mysql_tquery(connectionID, queryBuffer);
}

forward StopCookingBeef(playerid);
public StopCookingBeef(playerid)
{
    SCM(playerid, COLOR_WHITE, "You successfully cooked the Burito.");
    SCM(playerid, COLOR_WHITE, "The food that you cooked automatically stored in the stocks");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has cooked Burito from Cooking Area Successfully", GetRPName(playerid));
    PlayerInfo[playerid][pChopBeef] = 0;
    ClearAnimations(playerid, 1);
	TacoShopInfo[PlayerInfo[playerid][pFaction]][BuritoMenu] += 1;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET buritomenu = %i WHERE id = %i", TacoShopInfo[PlayerInfo[playerid][pFaction]][BuritoMenu], PlayerInfo[playerid][pFaction]);
	mysql_tquery(connectionID, queryBuffer);
}

forward StopCookingPork(playerid);
public StopCookingPork(playerid)
{
    SCM(playerid, COLOR_WHITE, "You successfully cooked the Taco.");
    SCM(playerid, COLOR_WHITE, "The food that you cooked automatically stored in the stocks");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has cooked taco from Cooking Area Successfully", GetRPName(playerid));
    PlayerInfo[playerid][pChopPork] = 0;
    ClearAnimations(playerid, 1);
	TacoShopInfo[PlayerInfo[playerid][pFaction]][TacoMenu] += 1;

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE factions SET tacomenu = %i WHERE id = %i", TacoShopInfo[PlayerInfo[playerid][pFaction]][TacoMenu], PlayerInfo[playerid][pFaction]);
	mysql_tquery(connectionID, queryBuffer);
}

CMD:getfrozen(playerid, params[])
{
    new option[12];
    if(GetFactionType(playerid) != FACTION_TACO)
	{
  	  return SendClientMessage(playerid, COLOR_SYNTAX, "You cant use this command unless you are part of Taco Gala");
	}
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1011.631225, -1358.617553, 13.547862))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not at the kitchen of the Taco Gala");
	}
	if(sscanf(params, "s[12]", option))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /getfrozen [Beef/Pork]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Beef, Pork");
	    return 1;
	}
	
	if(!strcmp(option, "Beef", true))
	{
	    ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 6.0, 0, 0, 0, 0, 0);
		
        SetTimerEx("StopGetFrozenBeef", 6000, false, "i", playerid);
        GameTextForPlayer(playerid, "~w~GETTING FROZEN BEEF.....", 6000, 3);
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("UnfreezePlayerEx", 6000, false, "i", playerid);
	}
	else if(!strcmp(option, "Pork", true))
	{
	    ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 6.0, 0, 0, 0, 0, 0);
		
        SetTimerEx("StopGetFrozenPork", 6000, false, "i", playerid);
        GameTextForPlayer(playerid, "~w~GETTING FROZEN PORK.....", 6000, 3);
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("UnfreezePlayerEx", 6000, false, "i", playerid);
	}
	return 1;
}

CMD:getmenustock(playerid, params[])
{
    if(GetFactionType(playerid) != FACTION_TACO)
	{
  	  return SendClientMessage(playerid, COLOR_SYNTAX, "You cant use this command unless you are part of Taco Gala");
	}
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1011.631225, -1358.617553, 13.547862))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not at the kitchen of the Taco Gala");
	}
	ShowDialogToPlayer(playerid, DIALOG_TACOPRODUCT);
	return 1;
}

CMD:makedrinks(playerid, params[])
{
    new option[12];
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1009.104418, -1359.590454, 13.547863))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not at the kitchen of the Taco Gala");
	}
	if(GetFactionType(playerid) != FACTION_TACO)
	{
  	  return SendClientMessage(playerid, COLOR_SYNTAX, "You cant use this command unless you are part of Taco Gala");
	}
	if(sscanf(params, "s[12]", option))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /makedrinks [CocaCola/Pepsi]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: CocaCola, Pepsi");
	    return 1;
	}
	
	if(!strcmp(option, "CocaCola", true))
	{
	    ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.0, 0, 0, 0, 0, 0);
		
        SetTimerEx("StopMakingCocaCola", 4000, false, "i", playerid);
        GameTextForPlayer(playerid, "~w~MAKING COCACOLA DRINKS.....", 4000, 3);
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("UnfreezePlayerEx", 4000, false, "i", playerid);
	}
	else if(!strcmp(option, "Pepsi", true))
	{
	    ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.0, 0, 0, 0, 0, 0);
		
        SetTimerEx("StopMakingPepsi", 4000, false, "i", playerid);
        GameTextForPlayer(playerid, "~w~MAKING PEPSI DRINKS.....", 4000, 3);
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("UnfreezePlayerEx", 4000, false, "i", playerid);
	}
	return 1;
}

CMD:chopfood(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1011.152404, -1359.598754, 13.547862))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not at the kitchen of the Taco Gala");
	}
	if(GetFactionType(playerid) != FACTION_TACO)
	{
  	  return SendClientMessage(playerid, COLOR_SYNTAX, "You cant use this command unless you are part of Taco Gala");
	}
	if(PlayerInfo[playerid][pFrozenBeef])
	{
	    ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 5.0, 0, 0, 0, 0, 0);
		
        SetTimerEx("StopChoppingBeef", 5000, false, "i", playerid);
        GameTextForPlayer(playerid, "~w~CHOPPING BEEF.....", 5000, 3);
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("UnfreezePlayerEx", 5000, false, "i", playerid);
	}
	if(PlayerInfo[playerid][pFrozenPork])
	{
	    ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 5.0, 0, 0, 0, 0, 0);
		
        SetTimerEx("StopChoppingPork", 5000, false, "i", playerid);
        GameTextForPlayer(playerid, "~w~CHOPPING PORK.....", 5000, 3);
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("UnfreezePlayerEx", 5000, false, "i", playerid);
	}
	return 1;
}

CMD:cook(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1007.146850, -1359.502929, 13.547863))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not at the kitchen of the Taco Gala");
	}
	if(GetFactionType(playerid) != FACTION_TACO)
	{
  	  return SendClientMessage(playerid, COLOR_SYNTAX, "You cant use this command unless you are part of Taco Gala");
	}
	if(PlayerInfo[playerid][pChopBeef])
	{
	    ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 5.0, 0, 0, 0, 0, 0);
		
        SetTimerEx("StopCookingBeef", 5000, false, "i", playerid);
        GameTextForPlayer(playerid, "~w~COOKING BURITO.....", 5000, 3);
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("UnfreezePlayerEx", 5000, false, "i", playerid);
	}
	if(PlayerInfo[playerid][pChopPork])
	{
	    ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 5.0, 0, 0, 0, 0, 0);
		
        SetTimerEx("StopCookingPork", 5000, false, "i", playerid);
        GameTextForPlayer(playerid, "~w~COOKING TACO.....", 5000, 3);
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("UnfreezePlayerEx", 5000, false, "i", playerid);
	}
	return 1;
}



CMD:order(playerid, params[])
{
    new factionid;
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1008.962707, -1353.723876, 13.547863))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not on the Taco Gala Menu.");
	}
	
	new string[3000];
	
	format(string, sizeof(string), "Taco Gala - Menu\n\
    "WHITE"Taco\t$110\t%s\n\
    "WHITE"Burito\t$110\t%s\n\
    "WHITE"CocaCola\t$50\t%s\n\
    "WHITE"Pepsi\t$50\t%s",
    TacoShopInfo[factionid][TacoMenu] ? ("{13FF00}Available{FFFFFF}") : ("{ff0000}Out Of Stock{FFFFFF}"),
    TacoShopInfo[factionid][BuritoMenu] ? ("{13FF00}Available{FFFFFF}") : ("{ff0000}Out Of Stock{FFFFFF}"),
    TacoShopInfo[factionid][CocaColaMenu] ? ("{13FF00}Available{FFFFFF}") : ("{ff0000}Out Of Stock{FFFFFF}"),
    TacoShopInfo[factionid][PepsiMenu] ? ("{13FF00}Available{FFFFFF}") : ("{ff0000}Out Of Stock{FFFFFF}"));
	ShowPlayerDialog(playerid, DIALOG_TACOMENU, DIALOG_STYLE_TABLIST_HEADERS, "Asian Town Roleplay - Taco Gala Menu", string, "Select", "Cancel");
	return 1;
}

CMD:setoutofstock(playerid, params[])
{
    new option[12], factionid;
    if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2 || GetFactionType(playerid) != FACTION_TACO)
    {
		return SendMessage(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2);
	}
    if(sscanf(params, "s[12]", option))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setoutofstock [option]");
    	SendClientMessage(playerid, COLOR_SYNTAX, "Available Options: Taco, Burito, CocaCola, Pepsi");
	    return 1;
	}
	
	if(!strcmp(option, "Taco", true))
	{
        TacoShopInfo[factionid][TacoMenu] = 0;
	    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_WHITE, ""GREEN"[TACO NEWS]: "WHITE"%s has set the Taco "RED"Out Of Stock!!", GetRPName(playerid));
	
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE tacos SET tacomenu = %i WHERE id = %i", TacoShopInfo[factionid][TacoMenu], factionid);
        mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "Burito", true))
	{
	    TacoShopInfo[factionid][BuritoMenu] = 0;
	    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_WHITE, ""GREEN"[TACO NEWS]: "WHITE"%s has set the Burito "RED"Out Of Stock!!", GetRPName(playerid));
	
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE tacos SET buritomenu = %i WHERE id = %i", TacoShopInfo[factionid][BuritoMenu], factionid);
        mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "CocaCola", true))
	{
	    TacoShopInfo[factionid][CocaColaMenu] = 0;
	    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_WHITE, ""GREEN"[TACO NEWS]: "WHITE"%s has set the CocaCola "RED"Out Of Stock!!", GetRPName(playerid));
	
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE tacos SET cocacolamenu = %i WHERE id = %i", TacoShopInfo[factionid][CocaColaMenu], factionid);
        mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "Pepsi", true))
	{
	    TacoShopInfo[factionid][PepsiMenu] = 0;
	    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_WHITE, ""GREEN"[TACO NEWS]: "WHITE"%s has set the Pepsi "RED"Out Of Stock!!", GetRPName(playerid));
    
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE tacos SET pepsimenu = %i WHERE id = %i", TacoShopInfo[factionid][PepsiMenu], factionid);
        mysql_tquery(connectionID, queryBuffer);
	}
	return 1;
}

CMD:setavailable(playerid, params[])
{
    new option[12], factionid;
    if(PlayerInfo[playerid][pFactionRank] < FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2 || GetFactionType(playerid) != FACTION_TACO)
    {
		return SendMessage(playerid, COLOR_SYNTAX, "You need to be at least rank %i+ to use this command.", FactionInfo[PlayerInfo[playerid][pFaction]][fRankCount] - 2);
	}
    if(sscanf(params, "s[12]", option))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /editmenu [option]");
    	SendClientMessage(playerid, COLOR_SYNTAX, "Available Options: Taco, Burito, CocaCola, Pepsi");
	    return 1;
	}
	
	if(!strcmp(option, "Taco", true))
	{
        TacoShopInfo[factionid][TacoMenu] = 1;
	    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_WHITE, ""GREEN"[TACO NEWS]: "WHITE"%s has set the Taco "GREEN"Available!!", GetRPName(playerid));
	
	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE tacos SET tacomenu = %i WHERE id = %i", TacoShopInfo[factionid][TacoMenu], factionid);
        mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "Burito", true))
	{
	    TacoShopInfo[factionid][BuritoMenu] = 1;
	    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_WHITE, ""GREEN"[TACO NEWS]: "WHITE"%s has set the Burito "GREEN"Available!!", GetRPName(playerid));
	
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE tacos SET buritomenu = %i WHERE id = %i", TacoShopInfo[factionid][BuritoMenu], factionid);
        mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "CocaCola", true))
	{
	    TacoShopInfo[factionid][CocaColaMenu] = 1;
	    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_WHITE, ""GREEN"[TACO NEWS]: "WHITE"%s has set the CocaCola "GREEN"Available!!", GetRPName(playerid));
	
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE tacos SET cocacolamenu = %i WHERE id = %i", TacoShopInfo[factionid][CocaColaMenu], factionid);
        mysql_tquery(connectionID, queryBuffer);
	}
	else if(!strcmp(option, "Pepsi", true))
	{
	    TacoShopInfo[factionid][PepsiMenu] = 1;
	    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_WHITE, ""GREEN"[TACO NEWS]: "WHITE"%s has set the Pepsi "GREEN"Available!!", GetRPName(playerid));
    
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE tacos SET pepsimenu = %i WHERE id = %i", TacoShopInfo[factionid][PepsiMenu], factionid);
        mysql_tquery(connectionID, queryBuffer);
	}
	return 1;
}

CMD:orderdineout(playerid, params[])
{
    if(PlayerInfo[playerid][pPendingOrder])
    {
        return SCM(playerid, COLOR_SYNTAX, "You have already pending orders, you can't order at the moment");
    }
	new string[3000];
	
	format(string, sizeof(string), ""ORANGE2"[ Taco Gala MENU ]\n\
    "WHITE"Menu 1\t"ORANGE2"(Have 2 Taco, 2 Cocola)\t"WHITE"$500\n\
    "WHITE"Menu 2\t"ORANGE2"(Have 4 Taco, 4 Cocola)\t"WHITE"$1000\n\
    "WHITE"Menu 3\t"ORANGE2"(Have 6 Taco, 3 Burito, 6 Cocola)\t"WHITE"$1500\n\
    "WHITE"Menu 4\t"ORANGE2"(Have 8 Taco, 6 Burito, 9 Cocola)\t"WHITE"$2000");
	ShowPlayerDialog(playerid, DIALOG_TACODINEOUT, DIALOG_STYLE_TABLIST_HEADERS, "Asian Town Roleplay - Taco Gala Menu", string, "Select", "Cancel");
	return 1;
}

CMD:acceptorder(playerid, params[])
{
	if(GetFactionType(playerid) == FACTION_TACO)
	{
		new targetid;
		if(sscanf(params, "u", targetid))
		{
			return SCM(playerid, COLOR_SYNTAX, "Usage: /acceptorder [playerid]");
		}
		if(IsPlayerConnected(targetid))
		{
		    /*if(targetid == playerid)
		    {
		        SCM(playerid, COLOR_AQUA, "You can't accept your own Emergency Dispatch call!");
				return 1;
		    }*/
		    if(!PlayerInfo[targetid][pPendingOrder])
		    {
		        SCM(playerid, COLOR_SYNTAX, "That person is doesnt have pending order!");
		        return 1;
		    }
			if(!IsPlayerConnected(PlayerInfo[targetid][pAcceptedOrder]))
			{
				SM(playerid, COLOR_WHITE, ""ORANGE2"* You have accepted %s order(s) you can get dineout order on Taco Kitchen", GetRPName(targetid));
				SM(targetid, COLOR_WHITE, ""SKYBLUE"[Taco] "WHITE"%s has accepted your order, your order is on the way!", GetPlayerNameEx(playerid));
				SM(targetid, COLOR_WHITE, ""SKYBLUE"NOTE: Dont move to your position right now, to avoid reporting by Fake Booking!!");
				SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_WHITE, ""ORANGE2" Taco %s has accepted order(s) from %s", GetRPName(playerid), GetRPName(targetid));
				PlayerInfo[targetid][pAcceptedOrder] = playerid;
				PlayerInfo[playerid][pProcessingOrder] = 1;
                PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
                new Float:ppos[3];
				GetPlayerPosEx(targetid, ppos[0], ppos[1], ppos[2]);
	    		SetPlayerCheckpoint(playerid, ppos[0],ppos[1],ppos[2], 3.0);
			}
			if(!IsPlayerConnected(PlayerInfo[targetid][pAcceptedDineIn]))
			{
				SM(playerid, COLOR_WHITE, ""ORANGE2"* You have accepted %s order(s), please prepare his/her order immediately.", GetRPName(targetid));
				SM(targetid, COLOR_WHITE, ""GREEN"[TACO] "WHITE"%s has accepted your order, your order is preparing by the Taco Staff.", FactionRanks[PlayerInfo[playerid][pFaction]][PlayerInfo[playerid][pFactionRank]], GetPlayerNameEx(playerid));
				SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_WHITE, ""ORANGE2" %s %s has accepted order(s) from %s", GetRPName(playerid), GetRPName(targetid));
				PlayerInfo[targetid][pAcceptedDineIn] = playerid;
				PlayerInfo[playerid][pProcessingOrder] = 1;
			}
			else
			{
				SCM(playerid, COLOR_WHITE, "Someone has already accepted that orders!");
			}
		}
	}
	return 1;
}

CMD:listorders(playerid, params[])
{
	if(GetFactionType(playerid) != FACTION_TACO)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a Taco Employee.");
	    return 1;
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	SendClientMessage(playerid, COLOR_GREEN, "Taco Gala Menu Order List:");
	foreach(new i : Player)
	{
		if(PlayerInfo[i][pPendingOrder])
		{
		    new accepted[24], acceptedd[24];
		    if(IsPlayerConnected(PlayerInfo[i][pAcceptedOrder]))
		    {
				accepted = GetRPName(PlayerInfo[i][pAcceptedOrder]);
		    }
		    else
		    {
		        accepted = "None";
		    }
		    if(PlayerInfo[i][pOrderMenu1])
		    {
		        SendMessage(playerid, COLOR_SYNTAX, ""GREEN"[Pending DineOutOrder]: "WHITE"%s(%i) has ordered a Menu 1 at DineOut Menu(s) Location: %s - Processing by: %s", GetRPName(i), playerid, GetPlayerZoneName(i), accepted);
		    }
		    if(PlayerInfo[i][pOrderMenu2])
		    {
		        SendMessage(playerid, COLOR_SYNTAX, ""GREEN"[Pending DineOutOrder]: "WHITE"%s(%i) has ordered a Menu 2 at DineOut Menu(s) Location: %s - Processing by: %s", GetRPName(i), playerid, GetPlayerZoneName(i), accepted);
		    }
		    if(PlayerInfo[i][pOrderMenu3])
		    {
		        SendMessage(playerid, COLOR_SYNTAX, ""GREEN"[Pending DineOutOrder]: "WHITE"%s(%i) has ordered a Menu 3 at DineOut Menu(s) Location: %s - Processing by: %s", GetRPName(i), playerid, GetPlayerZoneName(i), accepted);
		    }
		    if(PlayerInfo[i][pOrderMenu4])
		    {
		        SendMessage(playerid, COLOR_SYNTAX, ""GREEN"[Pending DineOutOrder]: "WHITE"%s(%i) has ordered a Menu 4 at DineOut Menu(s) Location: %s - Processing by: %s", GetRPName(i), playerid, GetPlayerZoneName(i), accepted);
		    }
    		if(IsPlayerConnected(PlayerInfo[i][pAcceptedDineIn]))
		    {
				acceptedd = GetRPName(PlayerInfo[i][pAcceptedDineIn]);
		    }
		    else
		    {
		        acceptedd = "None";
		    }
		    if(PlayerInfo[playerid][pOrderTaco])
		    {
		        SendMessage(i, COLOR_WHITE, ""GREEN"[Pending DineInOrder]:"ORANGE2" %s(ID: %i) has ordered %i Pcs Of Taco Location: %s - Processing by: %s", GetRPName(playerid), playerid, PlayerInfo[playerid][pTacoAmount], GetPlayerZoneName(playerid), accepted);
		    }
		    if(PlayerInfo[playerid][pOrderBurito])
		    {
		        SendMessage(i, COLOR_WHITE, ""GREEN"[Pending DineInOrder]:"ORANGE2" %s(ID: %i) has ordered %i Pcs Of Burito Location: %s - Processing by: %s", GetRPName(playerid), playerid, PlayerInfo[playerid][pBuritoAmount], GetPlayerZoneName(playerid), accepted);
		    }
		    if(PlayerInfo[playerid][pOrderCocaCola])
		    {
		        SendMessage(i, COLOR_WHITE, ""GREEN"[Pending DineInOrder]:"ORANGE2" %s(ID: %i) has ordered %i Pcs Of Cola Location: %s - Processing by: %s", GetRPName(playerid), playerid, PlayerInfo[playerid][pCocaColaAmount], GetPlayerZoneName(playerid), accepted);
		    }
		    if(PlayerInfo[playerid][pOrderPepsi])
		    {
		        SendMessage(i, COLOR_WHITE, ""GREEN"[Pending DineInOrder]:"ORANGE2" %s(ID: %i) has ordered %i Pcs Of Pepsi Location: %s - Processing by: %s", GetRPName(playerid), playerid, PlayerInfo[playerid][pPepsiAmount], GetPlayerZoneName(playerid), accepted);
		    }
		}
	}
	SendClientMessage(playerid, COLOR_WHITE, "Use /acceptorder [playerid] to accept their order(s)");
	return 1;
}

CMD:graborders(playerid, params[])
{
    new option[12];
    if(GetFactionType(playerid) != FACTION_TACO)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a Taco Employee.");
	    return 1;
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(!PlayerInfo[playerid][pProcessingOrder])
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You are not accept pending orders at the moment.");
	}
	if(PlayerInfo[playerid][pCarryingOrders])
        return SCM(playerid, SERVER_COLOR, "Error:"WHITE" You are already carrying a Order to be put on Taco Motor(s) for delivery!");
        
	if(sscanf(params, "s[12]", option))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /pickorders [option]");
    	SendClientMessage(playerid, COLOR_SYNTAX, "Available Options: Menu1, Menu2, Menu3, Menu4");
	    return 1;
	}
	
	if(!strcmp(option, "Menu1", true))
	{
	    if(PlayerInfo[playerid][pCarryingOrders])
	    {
	        return SCM(playerid, COLOR_SYNTAX, "You're carrying orders already.");
	    }
        PlayerInfo[playerid][pCarryingOrders] = 1;
        SetPlayerAttachedObject(playerid, 1, 2663, 6, 0.308999, 0.020000, 0.000000, 15.600001, -103.199974, -2.500001, 1.000000, 1.000000, 1.000000);
        SCM(playerid, COLOR_WHITE, ""ORANGE2"** You have grabbed the Menu1 Order(s) from Dineout at the Taco, put it on the Taco Vehicles and go to specific location of the customer.");
        SCM(playerid, SERVER_COLOR, ""SKYBLUE"NOTE: "WHITE"type the command "WHITE"'/orderin'"SVRCLR" at the back of the Taco Delivering Motor's put the order inside.");
	}
	else if(!strcmp(option, "Menu2", true))
	{
	    if(PlayerInfo[playerid][pCarryingOrders])
	    {
	        return SCM(playerid, COLOR_SYNTAX, "You're carrying orders already.");
	    }
        PlayerInfo[playerid][pCarryingOrders] = 1;
        SetPlayerAttachedObject(playerid, 1, 2663, 6, 0.308999, 0.020000, 0.000000, 15.600001, -103.199974, -2.500001, 1.000000, 1.000000, 1.000000);
        SCM(playerid, COLOR_WHITE, ""ORANGE2"** You have grabbed the Menu2 Order(s) from Dineout at the Taco, put it on the Taco Vehicles and go to specific location of the customer.");
        SCM(playerid, SERVER_COLOR, ""SKYBLUE"NOTE: "WHITE"type the command "WHITE"'/orderin'"SVRCLR" at the back of the Taco Delivering Motor's put the order inside.");
	}
	else if(!strcmp(option, "Menu3", true))
	{
	    if(PlayerInfo[playerid][pCarryingOrders])
	    {
	        return SCM(playerid, COLOR_SYNTAX, "You're carrying orders already.");
	    }
        PlayerInfo[playerid][pCarryingOrders] = 1;
        SetPlayerAttachedObject(playerid, 1, 2663, 6, 0.308999, 0.020000, 0.000000, 15.600001, -103.199974, -2.500001, 1.000000, 1.000000, 1.000000);
        SCM(playerid, COLOR_WHITE, ""ORANGE2"** You have grabbed the Menu3 Order(s) from Dineout at the Taco, put it on the Taco Vehicles and go to specific location of the customer.");
        SCM(playerid, SERVER_COLOR, ""SKYBLUE"NOTE: "WHITE"type the command "WHITE"'/orderin'"SVRCLR" at the back of the Taco Delivering Motor's put the order inside.");
	}
	else if(!strcmp(option, "Menu4", true))
	{
	    if(PlayerInfo[playerid][pCarryingOrders])
	    {
	        return SCM(playerid, COLOR_SYNTAX, "You're carrying orders already.");
	    }
        PlayerInfo[playerid][pCarryingOrders] = 1;
        SetPlayerAttachedObject(playerid, 1, 2663, 6, 0.308999, 0.020000, 0.000000, 15.600001, -103.199974, -2.500001, 1.000000, 1.000000, 1.000000);
        SCM(playerid, COLOR_WHITE, ""ORANGE2"** You have grabbed the Menu4 Order(s) from Dineout at the Taco, put it on the Taco Vehicles and go to specific location of the customer.");
        SCM(playerid, SERVER_COLOR, ""SKYBLUE"NOTE: "WHITE"type the command "WHITE"'/orderin'"SVRCLR" at the back of the Taco Delivering Motor's put the order inside.");
	}
    return 1;
}

CMD:orderin(playerid, params[])
{
    if(GetFactionType(playerid) != FACTION_TACO)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a Taco Employee.");
	    return 1;
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	
    if(!PlayerInfo[playerid][pCarryingOrders])
        return SCM(playerid, SERVER_COLOR, "Error:"WHITE" You are not carrying Menu Order(s) at the moment");

    new i = GetNearbyVehicle(playerid);

    if(GetVehicleModel(i) == 448)
    {
        if(VehicleInfo[i][vMeal])
            return SCM(playerid, SERVER_COLOR, "Error:"WHITE" This vehicle has a Order loaded already!");

        PlayerInfo[playerid][pCarryingOrders] = 0;

        VehicleInfo[i][vMeal] = true;

        RemovePlayerAttachedObject(playerid, 1);
   
        SCM(playerid, SERVER_COLOR, "** You have loaded the Taco Motor(s) with a Order please deliver it to Specific Customer.");
        SCM(playerid, SERVER_COLOR, "Type "WHITE"'/pickorder'"SVRCLR" from the Taco Motor's, to give it from customer that have Pending Orders");
    }
    else
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't put Taco Order's Unless its a Taco Motor(s)");
    }
    return 1;
}

CMD:pickorder(playerid, params[])
{
    if(GetFactionType(playerid) != FACTION_TACO)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a Taco Employee.");
	    return 1;
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	
	
    if(PlayerInfo[playerid][pCarryingOrders])
        return SCM(playerid, SERVER_COLOR, "Error:"WHITE" You carrying Menu Order(s) already");
        
    new i = GetNearbyVehicle(playerid);
    
    if(!VehicleInfo[i][vMeal])
        return SCM(playerid, SERVER_COLOR, "Error:"WHITE" This vehicle has no order loaded into it!");

    PlayerInfo[playerid][pCarryingOrders] = 1;
    SetPlayerAttachedObject(playerid, 1, 2663, 6, 0.308999, 0.020000, 0.000000, 15.600001, -103.199974, -2.500001, 1.000000, 1.000000, 1.000000);

    VehicleInfo[i][vMeal] = false;

    SCM(playerid, COLOR_YELLOW, "** You grabbed the order to be delivered, Type /deliverorder to deliver it to Customer.");
    return 1;
}

CMD:giveorder(playerid, params[])
{
    new targetid;
    if(GetFactionType(playerid) != FACTION_TACO)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a Taco Employee.");
	    return 1;
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "ui", targetid))
	{
    	return SCM(playerid, COLOR_SYNTAX, "Usage: /giveorder [playerid]");
	}
    if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected or out of range.");
    }
    /*if(targetid == playerid)
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "You can't give yourself a order.");
    }*/
    if(!PlayerInfo[playerid][pProcessingOrder])
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You are not accept pending orders at the moment.");
	}
    
    PlayerInfo[targetid][pOrderOffer] = playerid;
    TogglePlayerControllable(targetid, 1);

    if(PlayerInfo[targetid][pOrderTaco])
    {
        if(PlayerInfo[playerid][pTacoo] != PlayerInfo[targetid][pTacoAmount])
        {
            return SM(playerid, COLOR_SYNTAX, ""RED"ERROR: "WHITE"The person has ordered %i Taco, you have only %i", PlayerInfo[targetid][pTacoAmount], PlayerInfo[playerid][pTacoo]);
        }
        else
        {
            new tacoprice = PlayerInfo[playerid][pTacoAmount] * 100;
            PlayerInfo[playerid][pTacoPrice] = tacoprice;
            SM(targetid, COLOR_AQUA, ""ORANGE2"** %s offered you to recieve & pay your order for $%i (/accept order).", GetRPName(playerid), tacoprice);
            SM(playerid, COLOR_AQUA, "** You have offered %s to recieve and pay his/her order.", GetRPName(targetid));
        }
    }
    else if(PlayerInfo[targetid][pOrderBurito])
    {
        if(PlayerInfo[playerid][pTacoBurito] != PlayerInfo[targetid][pBuritoAmount])
        {
            return SM(playerid, COLOR_SYNTAX, ""RED"ERROR: "WHITE"The person has ordered %i Burito, you have only %i", PlayerInfo[targetid][pBuritoAmount], PlayerInfo[playerid][pTacoBurito]);
        }
        else
        {
            new buritoprice = PlayerInfo[targetid][pBuritoAmount] * 100;
            PlayerInfo[playerid][pBuritoPrice] = buritoprice;
            SM(targetid, COLOR_AQUA, ""ORANGE2"** %s offered you to recieve & pay your order for $%i (/accept order).", GetRPName(playerid), buritoprice);
            SM(playerid, COLOR_AQUA, "** You have offered %s to recieve and pay his/her order.", GetRPName(targetid));
        }
    }
    else if(PlayerInfo[targetid][pOrderCocaCola])
    {
        if(PlayerInfo[playerid][pTacoCocaCola] != PlayerInfo[targetid][pCocaColaAmount])
        {
            return SM(playerid, COLOR_SYNTAX, ""RED"ERROR: "WHITE"The person has ordered %i Cola, you have only %i", PlayerInfo[targetid][pCocaColaAmount], PlayerInfo[playerid][pTacoCocaCola]);
        }
        else
        {
            new colaprice = PlayerInfo[targetid][pCocaColaAmount] * 50;
            PlayerInfo[playerid][pColaPrice] = colaprice;
            SM(targetid, COLOR_AQUA, ""ORANGE2"** %s offered you to recieve & pay your order for $%i (/accept order).", GetRPName(playerid), colaprice);
            SM(playerid, COLOR_AQUA, "** You have offered %s to recieve and pay his/her order.", GetRPName(targetid));
        }
    }
    else if(PlayerInfo[targetid][pOrderPepsi])
    {
        if(PlayerInfo[playerid][pTacoPepsi] != PlayerInfo[targetid][pPepsiAmount])
        {
            return SM(playerid, COLOR_SYNTAX, ""RED"ERROR: "WHITE"The person has ordered %i Pepsi, you have only %i", PlayerInfo[targetid][pPepsiAmount], PlayerInfo[playerid][pTacoPepsi]);
        }
        else
        {
            new pepsiprice = PlayerInfo[targetid][pPepsiAmount] * 50;
            PlayerInfo[playerid][pPepsiPrice] = pepsiprice;
            SM(targetid, COLOR_AQUA, ""ORANGE2"** %s offered you to recieve & pay your order for $%i (/accept order).", GetRPName(playerid), pepsiprice);
            SM(playerid, COLOR_AQUA, "** You have offered %s to recieve and pay his/her order.", GetRPName(targetid));
        }
    }
    return 1;
}

CMD:deliverorder(playerid, params[])
{
    new targetid;
    if(GetFactionType(playerid) != FACTION_TACO)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command as you aren't a Taco Employee.");
	    return 1;
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(sscanf(params, "u", targetid))
	{
    	return SCM(playerid, COLOR_SYNTAX, "Usage: /deliverorder [playerid]");
	}
	
    if(!PlayerInfo[playerid][pCarryingOrders])
        return SCM(playerid, SERVER_COLOR, "Error:"WHITE" You are not carrying Menu Order(s) at the moment");
        
    PlayerInfo[targetid][pOrderOffer] = playerid;
    TogglePlayerControllable(targetid, 1);

    if(PlayerInfo[targetid][pOrderMenu1])
    {
        SM(targetid, COLOR_AQUA, ""ORANGE2"** %s offered you to recieve & pay your order for $500 (/accept order).", GetRPName(playerid));
        SM(playerid, COLOR_AQUA, "** You have offered %s to recieve and pay his/her order.", GetRPName(targetid));
    }
    else if(PlayerInfo[targetid][pOrderMenu2])
    {
        SM(targetid, COLOR_AQUA, ""ORANGE2"** %s offered you to recieve & pay your order for $1000 (/accept order).", GetRPName(playerid));
        SM(playerid, COLOR_AQUA, "** You have offered %s to recieve and pay his/her order.", GetRPName(targetid));
    }
    else if(PlayerInfo[targetid][pOrderMenu3])
    {
        SM(targetid, COLOR_AQUA, ""ORANGE2"** %s offered you to recieve & pay your order for $1500 (/accept order).", GetRPName(playerid));
        SM(playerid, COLOR_AQUA, "** You have offered %s to recieve and pay his/her order.", GetRPName(targetid));
    }
    else if(PlayerInfo[targetid][pOrderMenu4])
    {
        SM(targetid, COLOR_AQUA, ""ORANGE2"** %s offered you to recieve & pay your order for $2000 (/accept order).", GetRPName(playerid));
        SM(playerid, COLOR_AQUA, "** You have offered %s to recieve and pay his/her order.", GetRPName(targetid));
    }
    return 1;
}

CMD:eat(playerid, params[])
{
    new option[12];
    if(sscanf(params, "s[12]", option))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /eat [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Taco, Burito");
	    return 1;
	}
	
	if(!strcmp(option, "Taco", true))
	{
	    if(!PlayerInfo[playerid][pTacoo])
	    {
	       SendClientMessage(playerid, COLOR_SYNTAX, "You dont have Taco");
	    }
	
	    PlayerInfo[playerid][pTacoo] -= 1;
	    SM(playerid, COLOR_WHITE, "You eat Taco Successfully Taco Left: %i", PlayerInfo[playerid][pTacoo]);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has eat Taco successfully.", GetRPName(playerid));
	
	    PlayerInfo[playerid][pHunger] += 10;
	    if(PlayerInfo[playerid][pHunger] > 100)
		{
			PlayerInfo[playerid][pHunger] = 100;
	    }
		ApplyAnimationEx(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
	}
	else if(!strcmp(option, "Burito", true))
	{
	    if(!PlayerInfo[playerid][pTacoBurito])
	    {
	       SendClientMessage(playerid, COLOR_SYNTAX, "You dont have Burito");
	    }
	
	    PlayerInfo[playerid][pTacoBurito] -= 1;
	    SM(playerid, COLOR_WHITE, "You eat Taco Successfully Taco Left: %i", PlayerInfo[playerid][pTacoBurito]);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has eat Taco successfully.", GetRPName(playerid));
	
	    PlayerInfo[playerid][pHunger] += 10;
	    if(PlayerInfo[playerid][pHunger] > 100)
		{
			PlayerInfo[playerid][pHunger] = 100;
	    }
		ApplyAnimationEx(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
	}
	return 1;
}

CMD:drink(playerid, params[])
{
    new option[12];
    if(sscanf(params, "s[12]", option))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /drink [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: CocaCola, Pepsi");
	    return 1;
	}
	
	if(!strcmp(option, "CocaCola", true))
	{
	    if(!PlayerInfo[playerid][pTacoCocaCola])
	    {
	       SendClientMessage(playerid, COLOR_SYNTAX, "You dont have Coke");
	    }
	
	    PlayerInfo[playerid][pTacoCocaCola] -= 1;
	    SM(playerid, COLOR_WHITE, "You eat Taco Successfully Taco Left: %i", PlayerInfo[playerid][pTacoCocaCola]);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has eat Taco successfully.", GetRPName(playerid));
	
	    PlayerInfo[playerid][pThirst] += 10;
		if(PlayerInfo[playerid][pThirst] > 100)
        {
		    PlayerInfo[playerid][pThirst] = 100;
	    }
	    ApplyAnimationEx(playerid, "BAR", "dnk_stndF_loop", 4.0, 1, 0, 0, 0, 0);
	}
	else if(!strcmp(option, "Pepsi", true))
	{
	    if(!PlayerInfo[playerid][pTacoPepsi])
	    {
	       SendClientMessage(playerid, COLOR_SYNTAX, "You dont have Pepsi");
	    }
	
	    PlayerInfo[playerid][pTacoPepsi] -= 1;
	    SM(playerid, COLOR_WHITE, "You eat Taco Successfully Taco Left: %i", PlayerInfo[playerid][pTacoCocaCola]);
	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has eat Taco successfully.", GetRPName(playerid));
	
	    PlayerInfo[playerid][pThirst] += 10;
		if(PlayerInfo[playerid][pThirst] > 100)
        {
		    PlayerInfo[playerid][pThirst] = 100;
	    }
	    ApplyAnimationEx(playerid, "BAR", "dnk_stndF_loop", 4.0, 1, 0, 0, 0, 0);
	}
	return 1;
}