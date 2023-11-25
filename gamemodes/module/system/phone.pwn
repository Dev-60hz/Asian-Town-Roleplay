forward SavePhoneVariables(playerid);
public SavePhoneVariables(playerid)
{
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phonebattery = %i WHERE uid = %i", PlayerInfo[playerid][pPhoneBattery], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phonebrand = %i WHERE uid = %i", PlayerInfo[playerid][pPhoneBrand], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phoneload = %i WHERE uid = %i", PlayerInfo[playerid][pPhoneLoad], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phoneexpired = %i WHERE uid = %i", PlayerInfo[playerid][pPhoneExpired], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phonecharger = %i WHERE uid = %i", PlayerInfo[playerid][pPhoneCharger], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phonesim = %i WHERE uid = %i", PlayerInfo[playerid][pPhoneSim], PlayerInfo[playerid][pID]);
    mysql_tquery(connectionID, queryBuffer);
}

forward ResetPhoneVariables(playerid);
public ResetPhoneVariables(playerid)
{
    PlayerInfo[playerid][pPhoneLoad] = 0;
	PlayerInfo[playerid][pPhoneSim] = 0;
	PlayerInfo[playerid][pPhoneBrand] = 0;
	PlayerInfo[playerid][pPhoneBattery] = 0;
	PlayerInfo[playerid][pPhoneCharger] = 0;
	PlayerInfo[playerid][pPhoneExpired] = 0;
    SavePhoneVariables(playerid);
}

GetCellphoneBrand(playerid)
{
	new string[35];
	switch(PlayerInfo[playerid][pPhoneBrand])
	{
	    case 0: string = "None";
	    case 1: string = "Samsung Galaxy";
        case 2: string = "Oppo";
        case 3: string = "Vivo";
        case 4: string = "Realme";
        case 5: string = "IPhone";
	}
	return string;
}

GetCellphoneSim(playerid)
{
	new string[35];
	switch(PlayerInfo[playerid][pPhoneSim])
	{
	    case 0: string = "None";
	    case 1: string = "Dito";
        case 2: string = "Globe";
        case 3: string = "TM";
        case 4: string = "Smart";
        case 5: string = "Tnt";
	}
	return string;
}

CMD:buyphone(playerid, params[])
{
    new businessid = GetInsideBusiness(playerid);

	if(businessid == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of Telecom Business where you can buy stuff.");
	}
    if(PlayerInfo[playerid][pPhoneBrand])
        return SendClientMessage(playerid, COLOR_SYNTAX, "You already have a cellphone wait for it to expire to buy again");
        
    switch(BusinessInfo[businessid][bType])
	{
	    case BUSINESS_TELECOM:
	    {
           new string[128 * 2], header[128];
           strcat(string, "Cellphone Brand:\tPrice:\tExpiration:");
           format(header, sizeof(header), "Cellphone Brand Shop");
           format(string, sizeof(string), "%s\n\
           {FFFFFF}Samsung Galaxy\t$15,000\t15 Days\n\
           {FFFFFF}Oppo\t$25,000\t18 Days\n\
           {FFFFFF}Vivo\t$35,000\t20 Days\n\
           {FFFFFF}Realme\t$85,000\t25 Days\n\
           {FFFFFF}Iphone\t$100,000\t30 Days", string);
           ShowPlayerDialog(playerid, DIALOG_BUY_PHONE, DIALOG_STYLE_TABLIST_HEADERS, header, string, "Buy", "Cancel");
        }
    }
    return 1;
}

CMD:buyload(playerid, params[])
{
    new businessid = GetInsideBusiness(playerid);

	if(businessid == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of Telecom Business where you can buy stuff.");
	}
    if(!PlayerInfo[playerid][pPhoneBrand])
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have any brand of cellphone");
    
    if(!PlayerInfo[playerid][pPhoneSim])
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have sim card");
     
    switch(BusinessInfo[businessid][bType])
    {
	   case BUSINESS_TELECOM:
	   {
          new string[128 * 2], header[128];
          strcat(string, "Load List:\tPrice:");
          format(header, sizeof(header), "Cellphone Brand Shop");
          format(string, sizeof(string), "%s\n\
          {FFFFFF}20 Load Text & Call\t$500\n\
          {FFFFFF}25 Load Text & Call\t$750\n\
          {FFFFFF}35 Load Text & Call\t$900\n\
          {FFFFFF}40 Load Text & Call\t$1,000\n\
          {FFFFFF}50 Load Text & Call\t$5,000", string);
          ShowPlayerDialog(playerid, DIALOG_LOAD_PHONE, DIALOG_STYLE_TABLIST_HEADERS, header, string, "Buy", "Cancel");
       }
    }
    return 1;
}

CMD:buysim(playerid, params[])
{
    new businessid = GetInsideBusiness(playerid);

	if(businessid == -1)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of Telecom Business where you can buy stuff.");
	}
    if(!PlayerInfo[playerid][pPhoneBrand])
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have any brand of cellphone");
    
    switch(BusinessInfo[businessid][bType])
	{
	    case BUSINESS_TELECOM:
	    {
           new string[128 * 2], header[128];
           strcat(string, "Simcard:\tPrice:");
           format(header, sizeof(header), "Cellphone Brand Shop");
           format(string, sizeof(string), "%s\n\
           {FFFFFF}Dito\t$300\n\
           {FFFFFF}Globe\t$300\n\
           {FFFFFF}TM\t$300\n\
           {FFFFFF}Smart\t$300\n\
           {FFFFFF}Tnt\t$300", string);
           ShowPlayerDialog(playerid, DIALOG_SIM_PHONE, DIALOG_STYLE_TABLIST_HEADERS, header, string, "Buy", "Cancel");
        }
    }
    return 1;
}

CMD:myphone(playerid, params[])
{
    if(!PlayerInfo[playerid][pPhoneBrand])
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have any brand of cellphone");
        
    new string[128 * 2], header[128], expiration[32];
	expiration = formatdate(PlayerInfo[playerid][pPhoneExpired], 4);

    strcat(string, "List:\tInfo:");
    format(header, sizeof(header), "Cellphone Brand: %s", GetCellphoneBrand(playerid));
    format(string, sizeof(string), "%s\n\
    {FFFFFF}Expiration\t{FDE364}%s\n\
    {FFFFFF}Number\t{FDE364}%d\n\
    {FFFFFF}Battery\t{FDE364}%d%%\n\
    {FFFFFF}Load\t%d\n\
    {FFFFFF}Sim Card\t%s", 
    string,
    expiration,
    PlayerInfo[playerid][pPhone],
    PlayerInfo[playerid][pPhoneBattery],
    PlayerInfo[playerid][pPhoneLoad],
    GetCellphoneSim(playerid),
    string);
    ShowPlayerDialog(playerid, DIALOG_MAIN_PHONE, DIALOG_STYLE_TABLIST_HEADERS, header, string, "Okay", "");
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_BUY_PHONE)
	{
		if(response) 
		{
			switch(listitem)
            {
                case 0:
                {
                    PlayerInfo[playerid][pPhone] = random(100000) + 899999;
                    PlayerInfo[playerid][pPhoneBrand] = 1;
                    PlayerInfo[playerid][pPhoneBattery] = 100;
                    PlayerInfo[playerid][pPhoneExpired] = gettime() + (15 * 86400);

                    SavePhoneVariables(playerid);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phone = %i WHERE uid = %i", PlayerInfo[playerid][pPhone], PlayerInfo[playerid][pID]);
	                mysql_tquery(connectionID, queryBuffer);
	
                    SendClientMessage(playerid, COLOR_YELLOW, "Thankyou for buying Samsung Galaxy Brand!");
                    SendMessage(playerid, COLOR_SYNTAX, "Your new phone number is %i.", PlayerInfo[playerid][pPhone]);
                }
                case 1:
                {
	                PlayerInfo[playerid][pPhone] = random(100000) + 899999;
                    PlayerInfo[playerid][pPhoneBrand] = 2;
                    PlayerInfo[playerid][pPhoneBattery] = 100;
                    PlayerInfo[playerid][pPhoneExpired] = gettime() + (18 * 86400);

                    SavePhoneVariables(playerid);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phone = %i WHERE uid = %i", PlayerInfo[playerid][pPhone], PlayerInfo[playerid][pID]);
	                mysql_tquery(connectionID, queryBuffer);
	
                    SendClientMessage(playerid, COLOR_YELLOW, "Thankyou for buying Oppo Brand!");
                    SendMessage(playerid, COLOR_SYNTAX, "Your new phone number is %i.", PlayerInfo[playerid][pPhone]);
                }
                case 2:
                {
	                PlayerInfo[playerid][pPhone] = random(100000) + 899999;
                    PlayerInfo[playerid][pPhoneBrand] = 3;
                    PlayerInfo[playerid][pPhoneBattery] = 100;
                    PlayerInfo[playerid][pPhoneExpired] = gettime() + (20 * 86400);

                    SavePhoneVariables(playerid);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phone = %i WHERE uid = %i", PlayerInfo[playerid][pPhone], PlayerInfo[playerid][pID]);
	                mysql_tquery(connectionID, queryBuffer);
	
                    SendClientMessage(playerid, COLOR_YELLOW, "Thankyou for buying Vivo Brand!");
                    SendMessage(playerid, COLOR_SYNTAX, "Your new phone number is %i.", PlayerInfo[playerid][pPhone]);
                }
                case 3:
                {
	                PlayerInfo[playerid][pPhone] = random(100000) + 899999;
                    PlayerInfo[playerid][pPhoneBrand] = 4;
                    PlayerInfo[playerid][pPhoneBattery] = 100;
                    PlayerInfo[playerid][pPhoneExpired] = gettime() + (25 * 86400);

                    SavePhoneVariables(playerid);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phone = %i WHERE uid = %i", PlayerInfo[playerid][pPhone], PlayerInfo[playerid][pID]);
	                mysql_tquery(connectionID, queryBuffer);
	
                    SendClientMessage(playerid, COLOR_YELLOW, "Thankyou for buying Realme Brand!");
                    SendMessage(playerid, COLOR_SYNTAX, "Your new phone number is %i.", PlayerInfo[playerid][pPhone]);
                }
                case 4:
                {
	                PlayerInfo[playerid][pPhone] = random(100000) + 899999;
                    PlayerInfo[playerid][pPhoneBrand] = 5;
                    PlayerInfo[playerid][pPhoneBattery] = 100;
                    PlayerInfo[playerid][pPhoneExpired] = gettime() + (30 * 86400);

                    SavePhoneVariables(playerid);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET phone = %i WHERE uid = %i", PlayerInfo[playerid][pPhone], PlayerInfo[playerid][pID]);
	                mysql_tquery(connectionID, queryBuffer);
	
                    SendClientMessage(playerid, COLOR_YELLOW, "Thankyou for buying IPhone Brand!");
                    SendMessage(playerid, COLOR_SYNTAX, "Your new phone number is %i.", PlayerInfo[playerid][pPhone]);
                }
            }
        }
    }
    if(dialogid == DIALOG_LOAD_PHONE)
	{
	    if(response) 
		{
			switch(listitem)
	        {
	            case 0:
	            {
	                PlayerInfo[playerid][pPhoneLoad] = 20;
					SavePhoneVariables(playerid);
					
					SendClientMessage(playerid, COLOR_YELLOW, "Thankyou for buying 20x text and call load!");
	            }
	            case 1:
	            {
	                PlayerInfo[playerid][pPhoneLoad] = 25;
					SavePhoneVariables(playerid);
					
					SendClientMessage(playerid, COLOR_YELLOW, "Thankyou for buying 25x text and call load!");
	            }
				case 2:
	            {
	                PlayerInfo[playerid][pPhoneLoad] = 35;
					SavePhoneVariables(playerid);
					
					SendClientMessage(playerid, COLOR_YELLOW, "Thankyou for buying 35x text and call load!");
	            }
				case 3:
	            {
	                PlayerInfo[playerid][pPhoneLoad] = 40;
					SavePhoneVariables(playerid);
					
					SendClientMessage(playerid, COLOR_YELLOW, "Thankyou for buying 40x text and call load!");
	            }
				case 4:
	            {
	                PlayerInfo[playerid][pPhoneLoad] = 50;
					SavePhoneVariables(playerid);
					
					SendClientMessage(playerid, COLOR_YELLOW, "Thankyou for buying 50x text and call load!");
	            }
	        }
	    }
	}
	if(dialogid == DIALOG_SIM_PHONE)
	{
	    if(response) 
		{
			switch(listitem)
	        {
	            case 0:
	            {
	                PlayerInfo[playerid][pPhoneSim] = 1;
	                GivePlayerCash(playerid, -300);
					SavePhoneVariables(playerid);
					
					SendClientMessage(playerid, COLOR_YELLOW, "Thankyou for buying DITO sim card");
	            }
	            case 1:
	            {
	                PlayerInfo[playerid][pPhoneSim] = 2;
	                GivePlayerCash(playerid, -300);
					SavePhoneVariables(playerid);
					
					SendClientMessage(playerid, COLOR_YELLOW, "Thankyou for buying Globe sim card");
	            }
				case 2:
	            {
	                PlayerInfo[playerid][pPhoneSim] = 3;
	                GivePlayerCash(playerid, -300);
					SavePhoneVariables(playerid);
					
					SendClientMessage(playerid, COLOR_YELLOW, "Thankyou for buying TM sim card");
	            }
				case 3:
	            {
	                PlayerInfo[playerid][pPhoneSim] = 4;
	                GivePlayerCash(playerid, -300);
					SavePhoneVariables(playerid);
					
					SendClientMessage(playerid, COLOR_YELLOW, "Thankyou for buying Smart sim card");
	            }
				case 4:
	            {
	                PlayerInfo[playerid][pPhoneSim] = 5;
	                GivePlayerCash(playerid, -300);
					SavePhoneVariables(playerid);
					
					SendClientMessage(playerid, COLOR_YELLOW, "Thankyou for buying Tnt sim card");
	            }
	        }
	    }
	}
	#if defined Phone_OnDialogResponse
		return Phone_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnDialogResponse
	#undef OnDialogResponse
#else
	#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse Phone_OnDialogResponse
#if defined Phone_OnDialogResponse
	forward Phone_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif