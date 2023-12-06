//============================================================================//
// CAR TUNING SYSTEM
//============================================================================//


enum MechEnum
{
	Float:MechX,
	Float:MechY,
	Float:MechZ
};
/*new const MechStation[][MechEnum] =
{
	{1263.013427, -1814.558227, 13.785120},
	{1263.013738, -1809.745361, 13.785120},
	{1262.914062, -1804.689575, 13.785120},
	{1263.112670, -1799.824340, 13.785120}
};*/

IsNearTrunk(vehicle, playerid, Float: dist = 4.0)
{
	new Float: x, Float: y, Float: z;
    GetVehicleBoot(vehicle, x, y, z);

    if (GetPlayerDistanceFromPoint(playerid, x, y, z) > dist) return 0;

	return 1;
}

//native IsValidVehicle(vehicleid);

GetVehicleBoot(vehicleid, &Float:x, &Float:y, &Float:z)
{
	if(IsValidVehicle(vehicleid))
	{
		new
			Float:pos[7];

		GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
		GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
		GetVehicleZAngle(vehicleid, pos[6]);

		x = pos[3] - (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
		y = pos[4] - (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
 		z = pos[5];
		return 1;
	}

	x = 0.0;
	y = 0.0;
	z = 0.0;

	return 0;
}

forward StopGettingWheels1(playerid);
public StopGettingWheels1(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1025, 1, 0.1930, 0.5370, -0.0230, 2.0000, 2.0000, 2.0000, 0.8000, 0.8000, 0.8000);

    SCM(playerid, COLOR_WHITE, "You successfully get the Offroad Wheels");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Offroad Wheels from the Wheels Area.", GetRPName(playerid));
    PlayerInfo[playerid][pOffroad] = 1;
    PlayerInfo[playerid][pCarryWheels] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
    ClearAnimations(playerid, 1);
}

forward StopAddingWheels1(playerid);
public StopAddingWheels1(playerid)
{   
    new car = GetNearbyVehicle(playerid);
    
    AddVehicleComponent(car,1025);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pOffroad] = 0;
    PlayerInfo[playerid][pCarryWheels] = 0;
    
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Offroad Wheels to the vehicle", GetRPName(playerid));
}


forward StopGettingWheels2(playerid);
public StopGettingWheels2(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1074, 1, 0.1930, 0.5370, -0.0230, 2.0000, 2.0000, 2.0000, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Mega Wheels");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Mega Wheels from the Wheels Area.", GetRPName(playerid));
    PlayerInfo[playerid][pMega] = 1;
    PlayerInfo[playerid][pCarryWheels] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
    ClearAnimations(playerid, 1);
}

forward StopAddingWheels2(playerid);
public StopAddingWheels2(playerid)
{
    new car = GetNearbyVehicle(playerid);
    
    AddVehicleComponent(car,1074);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pMega] = 0;
    PlayerInfo[playerid][pCarryWheels] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Mega Wheels Succesfully", GetRPName(playerid));
}

forward StopGettingWheels3(playerid);
public StopGettingWheels3(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1076, 1, 0.1930, 0.5370, -0.0230, 2.0000, 2.0000, 2.0000, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Wires Wheels");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Wires Wheels from the Wheels Area.", GetRPName(playerid));
    PlayerInfo[playerid][pWires] = 1;
    PlayerInfo[playerid][pCarryWheels] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingWheels3(playerid);
public StopAddingWheels3(playerid)
{
    new car = GetNearbyVehicle(playerid);
    
    AddVehicleComponent(car,1076);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pWires] = 0;
    PlayerInfo[playerid][pCarryWheels] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Wires Wheels Succesfully", GetRPName(playerid));
}

forward StopGettingWheels4(playerid);
public StopGettingWheels4(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1078, 1, 0.1930, 0.5370, -0.0230, 2.0000, 2.0000, 2.0000, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Twist Wheels");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Twist Wheels from the Wheels Area.", GetRPName(playerid));
    PlayerInfo[playerid][pTwist] = 1;
    PlayerInfo[playerid][pCarryWheels] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingWheels4(playerid);
public StopAddingWheels4(playerid)
{
    new car = GetNearbyVehicle(playerid);
    
    AddVehicleComponent(car,1078);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pTwist] = 0;
    PlayerInfo[playerid][pCarryWheels] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Twist Wheels Succesfully", GetRPName(playerid));
}

forward StopGettingWheels5(playerid);
public StopGettingWheels5(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1081, 1, 0.1930, 0.5370, -0.0230, 2.0000, 2.0000, 2.0000, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Grove Wheels");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Grove Wheels from the Wheels Area.", GetRPName(playerid));
    PlayerInfo[playerid][pGrove] = 1;
    PlayerInfo[playerid][pCarryWheels] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingWheels5(playerid);
public StopAddingWheels5(playerid)
{
    new car = GetNearbyVehicle(playerid);

    AddVehicleComponent(car,1081);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pGrove] = 0;
    PlayerInfo[playerid][pCarryWheels] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Grove Wheels Succesfully", GetRPName(playerid));
}

forward StopGettingWheels6(playerid);
public StopGettingWheels6(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1082, 1, 0.1930, 0.5370, -0.0230, 2.0000, 2.0000, 2.0000, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Import Wheels");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Import Wheels from the Wheels Area.", GetRPName(playerid));
    PlayerInfo[playerid][pImport] = 1;
    PlayerInfo[playerid][pCarryWheels] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingWheels6(playerid);
public StopAddingWheels6(playerid)
{
    new car = GetNearbyVehicle(playerid);
    
    AddVehicleComponent(car,1082);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pImport] = 0;
    PlayerInfo[playerid][pCarryWheels] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Import Wheels Succesfully", GetRPName(playerid));
}

forward StopGettingWheels7(playerid);
public StopGettingWheels7(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1085, 1, 0.1930, 0.5370, -0.0230, 2.0000, 2.0000, 2.0000, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Atomic Wheels");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Atomic Wheels from the Wheels Area.", GetRPName(playerid));
    PlayerInfo[playerid][pAtomic] = 1;
    PlayerInfo[playerid][pCarryWheels] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingWheels7(playerid);
public StopAddingWheels7(playerid)
{
    new car = GetNearbyVehicle(playerid);
    
    AddVehicleComponent(car,1085);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pAtomic] = 0;
    PlayerInfo[playerid][pCarryWheels] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Atomic Wheels Succesfully", GetRPName(playerid));
}

forward StopGettingWheels8(playerid);
public StopGettingWheels8(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1096, 1, 0.1930, 0.5370, -0.0230, 2.0000, 2.0000, 2.0000, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Ahab Wheels");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Ahab Wheels from the Wheels Area.", GetRPName(playerid));
    PlayerInfo[playerid][pAhab] = 1;
    PlayerInfo[playerid][pCarryWheels] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingWheels8(playerid);
public StopAddingWheels8(playerid)
{
    new car = GetNearbyVehicle(playerid);
    
    AddVehicleComponent(car,1096);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pAhab] = 0;
    PlayerInfo[playerid][pCarryWheels] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Ahab Wheels Succesfully", GetRPName(playerid));
}

forward StopGettingWheels9(playerid);
public StopGettingWheels9(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1097, 1, 0.1930, 0.5370, -0.0230, 2.0000, 2.0000, 2.0000, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Virtual Wheels");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Virtual Wheels from the Wheels Area.", GetRPName(playerid));
    PlayerInfo[playerid][pVirtual] = 1;
    PlayerInfo[playerid][pCarryWheels] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingWheels9(playerid);
public StopAddingWheels9(playerid)
{
    new car = GetNearbyVehicle(playerid);
    
    AddVehicleComponent(car,1097);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pVirtual] = 0;
    PlayerInfo[playerid][pCarryWheels] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Virtual Wheels Succesfully", GetRPName(playerid));
}

forward StopGettingWheels10(playerid);
public StopGettingWheels10(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1098, 1, 0.1930, 0.5370, -0.0230, 2.0000, 2.0000, 2.0000, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Access Wheels");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Access Wheels from the Wheels Area.", GetRPName(playerid));
    PlayerInfo[playerid][pAccess] = 1;
    PlayerInfo[playerid][pCarryWheels] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingWheels10(playerid);
public StopAddingWheels10(playerid)
{
    new car = GetNearbyVehicle(playerid);
    
    AddVehicleComponent(car,1098);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pAccess] = 0;
    PlayerInfo[playerid][pCarryWheels] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Access Wheels Succesfully", GetRPName(playerid));
}

forward StopGettingWheels11(playerid);
public StopGettingWheels11(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1084, 1, 0.1930, 0.5370, -0.0230, 2.0000, 2.0000, 2.0000, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Trance Wheels");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Trance Wheels from the Wheels Area.", GetRPName(playerid));
    PlayerInfo[playerid][pTrance] = 1;
    PlayerInfo[playerid][pCarryWheels] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingWheels11(playerid);
public StopAddingWheels11(playerid)
{
    new car = GetNearbyVehicle(playerid);
    
    AddVehicleComponent(car,1084);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pTrance] = 0;
    PlayerInfo[playerid][pCarryWheels] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Trance Wheels Succesfully", GetRPName(playerid));
}

forward StopGettingWheels12(playerid);
public StopGettingWheels12(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1073, 1, 0.1930, 0.5370, -0.0230, 2.0000, 2.0000, 2.0000, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Shadow Wheels");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Shadow Wheels from the Wheels Area.", GetRPName(playerid));
    PlayerInfo[playerid][pShadow] = 1;
    PlayerInfo[playerid][pCarryWheels] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingWheels12(playerid);
public StopAddingWheels12(playerid)
{
    new car = GetNearbyVehicle(playerid);
    
    AddVehicleComponent(car,1073);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pShadow] = 0;
    PlayerInfo[playerid][pCarryWheels] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Shadow Wheels Succesfully", GetRPName(playerid));
}

forward StopGettingWheels13(playerid);
public StopGettingWheels13(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1075, 1, 0.1930, 0.5370, -0.0230, 2.0000, 2.0000, 2.0000, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Rimshine Wheels");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Rimshine Wheels from the Wheels Area.", GetRPName(playerid));
    PlayerInfo[playerid][pRimshine] = 1;
    PlayerInfo[playerid][pCarryWheels] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingWheels13(playerid);
public StopAddingWheels13(playerid)
{
    new car = GetNearbyVehicle(playerid);
    
    AddVehicleComponent(car,1075);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pRimshine] = 0;
    PlayerInfo[playerid][pCarryWheels] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Rimshine Wheels Succesfully", GetRPName(playerid));
}

forward StopGettingWheels14(playerid);
public StopGettingWheels14(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1077, 1, 0.1930, 0.5370, -0.0230, 2.0000, 2.0000, 2.0000, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Classic Wheels");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Classic Wheels from the Wheels Area.", GetRPName(playerid));
    PlayerInfo[playerid][pClassic] = 1;
    PlayerInfo[playerid][pCarryWheels] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingWheels14(playerid);
public StopAddingWheels14(playerid)
{
    new car = GetNearbyVehicle(playerid);
    
    AddVehicleComponent(car,1077);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pClassic] = 0;
    PlayerInfo[playerid][pCarryWheels] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Classic Wheels Succesfully", GetRPName(playerid));
}

forward StopGettingWheels15(playerid);
public StopGettingWheels15(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1079, 1, 0.1930, 0.5370, -0.0230, 2.0000, 2.0000, 2.0000, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Cutter Wheels");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Cutter Wheels from the Wheels Area.", GetRPName(playerid));
    PlayerInfo[playerid][pCutter] = 1;
    PlayerInfo[playerid][pCarryWheels] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingWheels15(playerid);
public StopAddingWheels15(playerid)
{
    new car = GetNearbyVehicle(playerid);
    
    AddVehicleComponent(car,1079);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pCutter] = 0;
    PlayerInfo[playerid][pCarryWheels] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Cutter Wheels Succesfully", GetRPName(playerid));
}

forward StopGettingWheels16(playerid);
public StopGettingWheels16(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1080, 1, 0.1930, 0.5370, -0.0230, 2.0000, 2.0000, 2.0000, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Switch Wheels");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Switch Wheels from the Wheels Area.", GetRPName(playerid));
    PlayerInfo[playerid][pSwitch] = 1;
    PlayerInfo[playerid][pCarryWheels] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingWheels16(playerid);
public StopAddingWheels16(playerid)
{
    new car = GetNearbyVehicle(playerid);
    
    AddVehicleComponent(car,1080);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pSwitch] = 0;
    PlayerInfo[playerid][pCarryWheels] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Switch Wheels Succesfully", GetRPName(playerid));
}

forward StopGettingWheels17(playerid);
public StopGettingWheels17(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1083, 1, 0.1930, 0.5370, -0.0230, 2.0000, 2.0000, 2.0000, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Dollar Wheels");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Dollar Wheels from the Wheels Area.", GetRPName(playerid));
    PlayerInfo[playerid][pDollWheel] = 1;
    PlayerInfo[playerid][pCarryWheels] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingWheels17(playerid);
public StopAddingWheels17(playerid)
{
    new car = GetNearbyVehicle(playerid);
    
    AddVehicleComponent(car,1083);
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pDollWheel] = 0;
    PlayerInfo[playerid][pCarryWheels] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Offroad Wheels Succesfully", GetRPName(playerid));
}

forward StopGettingRbump1(playerid);
public StopGettingRbump1(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1141, 1, 0.3439, 0.8950, 0.7500, -81.7000, 89.7999, 78.7999, 0.6999, 0.6999, 0.6999);
    SCM(playerid, COLOR_WHITE, "You successfully get the Alien Rear Bumper. ");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Alien Rear Bumper from the Bumpers Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pAlienRBump] = 1;
    PlayerInfo[playerid][pCarryBumpers] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingRBumpers1(playerid);
public StopAddingRBumpers1(playerid)
{
	new car = GetNearbyVehicle(playerid);
	
    if(GetVehicleModel(car) == 562) // Elegy
    {
	    AddVehicleComponent(car,1149);
        PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");       
	
	    PlayerInfo[playerid][pAlienRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Rear Bumpers Succesfully", GetRPName(playerid));
	 }
	 else if(GetVehicleModel(car) == 565) // Flash
	 {
		 AddVehicleComponent(car,1150);
	     PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	     SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
	
	     PlayerInfo[playerid][pAlienRBump] = 0;
         PlayerInfo[playerid][pCarryBumpers] = 0;
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
         ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
         RemovePlayerAttachedObject(playerid, 8);
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
         ClearAnimations(playerid, 1);
         GameTextForPlayer(playerid, "~g~Success", 4000, 3);
         SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Rear Bumpers Succesfully", GetRPName(playerid));
	 }
     else if(GetVehicleModel(car) == 559) // Jetser
     {
	     AddVehicleComponent(car,1159);
	     PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		 SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		 PlayerInfo[playerid][pAlienRBump] = 0;
         PlayerInfo[playerid][pCarryBumpers] = 0;
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
         ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
         RemovePlayerAttachedObject(playerid, 8);
         ClearAnimations(playerid, 1);
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
         GameTextForPlayer(playerid, "~g~Success", 4000, 3);
         SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Rear Bumpers Succesfully", GetRPName(playerid));
	 }
	 else if(GetVehicleModel(car) == 561) // Stratum
     {
	     AddVehicleComponent(car,1154);
         PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	     SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
	
	     PlayerInfo[playerid][pAlienRBump] = 0;
         PlayerInfo[playerid][pCarryBumpers] = 0;
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
         ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
         ClearAnimations(playerid, 1);
         RemovePlayerAttachedObject(playerid, 8);
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
         GameTextForPlayer(playerid, "~g~Success", 4000, 3);
         SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Rear Bumpers Succesfully", GetRPName(playerid));
	 }
	 else if(GetVehicleModel(car) == 560) // Sultan
	 {
	     AddVehicleComponent(car,1141);
	     PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		 SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		 PlayerInfo[playerid][pAlienRBump] = 0;
         PlayerInfo[playerid][pCarryBumpers] = 0;
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
         ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
         ClearAnimations(playerid, 1);
         RemovePlayerAttachedObject(playerid, 8);
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
         GameTextForPlayer(playerid, "~g~Success", 4000, 3);
         SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Rear Bumpers Succesfully", GetRPName(playerid));
	 }
	 else if(GetVehicleModel(car) == 558)  // Uranus
	 {
		 AddVehicleComponent(car,1168);
	     PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		 SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		 PlayerInfo[playerid][pAlienRBump] = 0;
         PlayerInfo[playerid][pCarryBumpers] = 0;
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
         ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
         ClearAnimations(playerid, 1);
         RemovePlayerAttachedObject(playerid, 8);
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
         GameTextForPlayer(playerid, "~g~Success", 4000, 3);
         SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Rear Bumpers Succesfully", GetRPName(playerid));
     }
     else
     {
         GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
         SCM(playerid, COLOR_SYNTAX, "You cant install the bumpers to this car");
         RemovePlayerAttachedObject(playerid, 8);
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
     }
}

forward StopGettingFbump1(playerid);
public StopGettingFbump1(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1157, 1, 0.0780, 0.7710, 0.7700, -81.7000, -86.5000, 93.0999, 0.6999, 0.6999, 0.6999);
    SCM(playerid, COLOR_WHITE, "You successfully get the Alien Front Bumper. ");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Alien Front Bumper from the Bumpers Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pAlienFBump] = 1;
    PlayerInfo[playerid][pCarryBumpers] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingFBumpers1(playerid);
public StopAddingFBumpers1(playerid)
{
	new car = GetNearbyVehicle(playerid);   
 
    if(GetVehicleModel(car) == 562) // Elegy
    {
		AddVehicleComponent(car,1171);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlienFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Front Bumpers Succesfully", GetRPName(playerid));
    }
    else if(GetVehicleModel(car) == 565) // Flash
    {
	    AddVehicleComponent(car,1153);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlienFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Front Bumpers Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 559) // Jester
	{
       AddVehicleComponent(car,1160);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pAlienFBump] = 0;
       PlayerInfo[playerid][pCarryBumpers] = 0;
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
       ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Front Bumpers Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 561) // Stratum
	{
	    AddVehicleComponent(car,1155);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlienFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Front Bumpers Succesfully", GetRPName(playerid));
     }
	 else if(GetVehicleModel(car) == 560) // Sultan
	 {
	    AddVehicleComponent(car,1169);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlienFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Front Bumpers Succesfully", GetRPName(playerid));
	 }
	 else if(GetVehicleModel(car) == 558) // Uranus
     {
	     AddVehicleComponent(car,1166);
	     PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	     SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
	
	     SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
         PlayerInfo[playerid][pAlienFBump] = 0;
         PlayerInfo[playerid][pCarryBumpers] = 0;
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
         ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
         ClearAnimations(playerid, 1);
         RemovePlayerAttachedObject(playerid, 8);
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
         GameTextForPlayer(playerid, "~g~Success", 4000, 3);
         SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Front Bumpers Succesfully", GetRPName(playerid));
     }
     else
     {
         GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
         SCM(playerid, COLOR_SYNTAX, "You cant install the bumpers to this car");
         RemovePlayerAttachedObject(playerid, 8);
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
         SCM(playerid, COLOR_SYNTAX, "You cant install the bumpers to this car");
     }
}

forward StopGettingRbump2(playerid);
public StopGettingRbump2(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1141, 1, 0.3439, 0.8950, 0.7500, -81.7000, 89.7999, 78.7999, 0.6999, 0.6999, 0.6999);
    SCM(playerid, COLOR_WHITE, "You successfully get the X-Flow Rear Bumper. ");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the X-Flow Rear Bumper from the Bumpers Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pXFlowRBump] = 1;
    PlayerInfo[playerid][pCarryBumpers] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingRBumpers2(playerid);
public StopAddingRBumpers2(playerid)
{
	new car = GetNearbyVehicle(playerid);
	
    if(GetVehicleModel(car) == 562) // Elegy
    {
	   AddVehicleComponent(car,1148);
       PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
	
	   PlayerInfo[playerid][pXFlowRBump] = 0;
       PlayerInfo[playerid][pCarryBumpers] = 0;
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
       ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added X-Flow Rear Bumpers Succesfully", GetRPName(playerid));
    }
	else if(GetVehicleModel(car) == 565) // Flash
	{
		AddVehicleComponent(car,1151);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
	    PlayerInfo[playerid][pXFlowRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added X-Flow Rear Bumpers Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 559) // Jetser
	{
		AddVehicleComponent(car,1161);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
	    PlayerInfo[playerid][pXFlowRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added X-Flow Rear Bumpers Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 561) // Stratum
	{
		AddVehicleComponent(car,1156);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		PlayerInfo[playerid][pXFlowRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added X-Flow Rear Bumpers Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 560) // Sultan
	{
		AddVehicleComponent(car,1140);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
	
        PlayerInfo[playerid][pXFlowRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added X-Flow Rear Bumpers Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 558)  // Uranus
	{
		AddVehicleComponent(car,1167);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		PlayerInfo[playerid][pXFlowRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added X-Flow Rear Bumpers Succesfully", GetRPName(playerid));
	}
	else
    {
        GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the bumpers to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    }
}

forward StopGettingFbump2(playerid);
public StopGettingFbump2(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1157, 1, 0.0780, 0.7710, 0.7700, -81.7000, -86.5000, 93.0999, 0.6999, 0.6999, 0.6999);
    SCM(playerid, COLOR_WHITE, "You successfully get the X-Flow Front Bumper. ");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the X-Flow Front Bumper from the Bumpers Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pXFlowFBump] = 1;
    PlayerInfo[playerid][pCarryBumpers] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingFBumpers2(playerid);
public StopAddingFBumpers2(playerid)
{
	new car = GetNearbyVehicle(playerid);   
 
    if(GetVehicleModel(car) == 562) // Elegy
    {
		AddVehicleComponent(car,1172);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
        SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
        
        SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pXFlowFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has XFlow Front Bumpers Succesfully", GetRPName(playerid));
    }
    else if(GetVehicleModel(car) == 565) // Flash
    {
	    AddVehicleComponent(car,1152);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pXFlowFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has XFlow Front Bumpers Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 559) // Jester
	{
        AddVehicleComponent(car,1173);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pXFlowFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has XFlow Front Bumpers Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 561) // Stratum
	{
	    AddVehicleComponent(car,1157);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pXFlowFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has XFlow Front Bumpers Succesfully", GetRPName(playerid));
     }
	 else if(GetVehicleModel(car) == 560) // Sultan
	 {
	     AddVehicleComponent(car,1170);
	     PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		 SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		 SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
         PlayerInfo[playerid][pXFlowFBump] = 0;
         PlayerInfo[playerid][pCarryBumpers] = 0;
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
         ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
         ClearAnimations(playerid, 1);
         RemovePlayerAttachedObject(playerid, 8);
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
         GameTextForPlayer(playerid, "~g~Success", 4000, 3);
         SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has XFlow Front Bumpers Succesfully", GetRPName(playerid));
	 }
	 else if(GetVehicleModel(car) == 558) // Uranus
     {
	     AddVehicleComponent(car,1165);
	     PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	     SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
	
	     SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
         PlayerInfo[playerid][pXFlowFBump] = 0;
         PlayerInfo[playerid][pCarryBumpers] = 0;
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
         ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
         ClearAnimations(playerid, 1);
         RemovePlayerAttachedObject(playerid, 8);
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
         GameTextForPlayer(playerid, "~g~Success", 4000, 3);
         SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has XFlow Front Bumpers Succesfully", GetRPName(playerid));
     }
     else
     {
         GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
         SCM(playerid, COLOR_SYNTAX, "You cant install the bumpers to this car");
         RemovePlayerAttachedObject(playerid, 8);
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
     }
}

forward StopGettingRbump3(playerid);
public StopGettingRbump3(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1141, 1, 0.3439, 0.8950, 0.7500, -81.7000, 89.7999, 78.7999, 0.6999, 0.6999, 0.6999);
    SCM(playerid, COLOR_WHITE, "You successfully get the Chromer Rear Bumper. ");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Chromer Rear Bumper from the Bumpers Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pChromerRBump] = 1;
    PlayerInfo[playerid][pCarryBumpers] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingRBumpers3(playerid);
public StopAddingRBumpers3(playerid)
{
	new car = GetNearbyVehicle(playerid);
	
    if(GetVehicleModel(car) == 575) // Brodway
    {
	    AddVehicleComponent(car,1176);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
	
	    PlayerInfo[playerid][pChromerRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Rear Bumpers Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 534)// Remington
	{
		AddVehicleComponent(car,1180);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		PlayerInfo[playerid][pChromerRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Rear Bumpers Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 567)// Savanna
	{
		AddVehicleComponent(car,1187);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
	
        PlayerInfo[playerid][pChromerRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Rear Bumpers Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 536) // Blade
	{
	    AddVehicleComponent(car,1184);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		PlayerInfo[playerid][pChromerRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Rear Bumpers Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 535) // Slamvan
	{
		AddVehicleComponent(car,1109);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		PlayerInfo[playerid][pChromerRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Rear Bumpers Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 576) // Tornado
	{
		AddVehicleComponent(car,1192);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		PlayerInfo[playerid][pChromerRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Rear Bumpers Succesfully", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the bumpers to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingFbump3(playerid);
public StopGettingFbump3(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1157, 1, 0.0780, 0.7710, 0.7700, -81.7000, -86.5000, 93.0999, 0.6999, 0.6999, 0.6999);
    SCM(playerid, COLOR_WHITE, "You successfully get the Chromer Front Bumper. ");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Chromer Front Bumper from the Bumpers Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pChromerFBump] = 1;
    PlayerInfo[playerid][pCarryBumpers] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingFBumpers3(playerid);
public StopAddingFBumpers3(playerid)
{
	new car = GetNearbyVehicle(playerid);   
 
    if(GetVehicleModel(car) == 575) // Brodway
    {
	    AddVehicleComponent(car,1174);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChromerFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Front Bumpers Succesfully", GetRPName(playerid));  
	}
	else if(GetVehicleModel(car) == 534)// Remington
	{
		AddVehicleComponent(car,1179);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChromerFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Front Bumpers Succesfully", GetRPName(playerid));  
	}
    else if(GetVehicleModel(car) == 567)// Savanna
	{
		AddVehicleComponent(car,1189);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChromerFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Front Bumpers Succesfully", GetRPName(playerid));  
	}
	else if(GetVehicleModel(car) == 536) // Blade
	{
		 AddVehicleComponent(car,1182);
	     PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		 SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		 SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
         PlayerInfo[playerid][pChromerFBump] = 0;
         PlayerInfo[playerid][pCarryBumpers] = 0;
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
         ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
         ClearAnimations(playerid, 1);
         RemovePlayerAttachedObject(playerid, 8);
         SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
         GameTextForPlayer(playerid, "~g~Success", 4000, 3);
         SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Front Bumpers Succesfully", GetRPName(playerid));  
	}
	else if(GetVehicleModel(car) == 535) // Slamvan
	{
		AddVehicleComponent(car,1115);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChromerFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Front Bumpers Succesfully", GetRPName(playerid));  
	}
	else if(GetVehicleModel(car) == 576) // Tornado
	{
		AddVehicleComponent(car,1191);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");

        SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChromerFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Front Bumpers Succesfully", GetRPName(playerid));  
	}
	else
	{
	    GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the bumpers to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingRbump4(playerid);
public StopGettingRbump4(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1141, 1, 0.3439, 0.8950, 0.7500, -81.7000, 89.7999, 78.7999, 0.6999, 0.6999, 0.6999);
    SCM(playerid, COLOR_WHITE, "You successfully get the Slamin Rear Bumper. ");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Slamin Rear Bumper from the Bumpers Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pSlaminFBump] = 1;
    PlayerInfo[playerid][pCarryBumpers] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingRBumpers4(playerid);
public StopAddingRBumpers4(playerid)
{
	new car = GetNearbyVehicle(playerid);
	
    if(GetVehicleModel(car) == 575) // Brodway
	{
		AddVehicleComponent(car,1177);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		PlayerInfo[playerid][pSlaminRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Rear Bumpers Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 534)// Remington
	{
		AddVehicleComponent(car,1178);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		PlayerInfo[playerid][pSlaminRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Rear Bumpers Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 567)// Savanna
	{
		AddVehicleComponent(car,1186);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");   
		
		PlayerInfo[playerid][pSlaminRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Rear Bumpers Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 536) // Blade
	{
		AddVehicleComponent(car,1183);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		PlayerInfo[playerid][pSlaminRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Rear Bumpers Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 535) // Slamvan
	{
		AddVehicleComponent(car,1110);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		PlayerInfo[playerid][pSlaminRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Rear Bumpers Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 576) // Tornado
	{
		AddVehicleComponent(car,1193);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
	    PlayerInfo[playerid][pSlaminRBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Rear Bumpers Succesfully", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the bumpers to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingFbump4(playerid);
public StopGettingFbump4(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1157, 1, 0.0780, 0.7710, 0.7700, -81.7000, -86.5000, 93.0999, 0.6999, 0.6999, 0.6999);
    SCM(playerid, COLOR_WHITE, "You successfully get the Slamin Front Bumper. ");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Slamin Front Bumper from the Bumpers Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pSlaminFBump] = 1;
    PlayerInfo[playerid][pCarryBumpers] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingFBumpers4(playerid);
public StopAddingFBumpers4(playerid)
{
	new car = GetNearbyVehicle(playerid);   
 
    if(GetVehicleModel(car) == 575) // Brodway
	{
	    AddVehicleComponent(car,1175);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pSlaminFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Front Bumpers Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 534)// Remington
	{
		AddVehicleComponent(car,1185);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pSlaminFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Front Bumpers Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 567)// Savanna
	{
		AddVehicleComponent(car,1188);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pSlaminFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Front Bumpers Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 536) // Blade
	{
		AddVehicleComponent(car,1181);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pSlaminFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Front Bumpers Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 535) // Slamvan
    {
		AddVehicleComponent(car,1116);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pSlaminFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Front Bumpers Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 576) // Tornado
	{
		AddVehicleComponent(car,1190);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Bumpers successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pSlaminFBump] = 0;
        PlayerInfo[playerid][pCarryBumpers] = 0;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Front Bumpers Succesfully", GetRPName(playerid));
	}
	else
	{
	    GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the bumpers to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingSpoilers1(playerid);
public StopGettingSpoilers1(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1138, 1, 0.2730, 0.3860, -0.0230, -88.3999, -54.7999, 84.3999, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Alien Spoilers");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Alien Spoilers from the Spoiler Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pAlienSpoiler] = 1;
    PlayerInfo[playerid][pCarrySpoilers] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingSpoilers1(playerid);
public StopAddingSpoilers1(playerid)
{
    new car = GetNearbyVehicle(playerid);   

    if(GetVehicleModel(car) == 562) // Elegy
    {
		AddVehicleComponent(car,1147);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlienSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 565) // Flash
	{
		AddVehicleComponent(car,1049);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlienSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 559) // Jester
	{
		AddVehicleComponent(car,1162);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlienSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 561) // Stratum
	{
		AddVehicleComponent(car,1158);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlienSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 560) // Sultan
	{
		AddVehicleComponent(car,1138);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlienSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Spoiler Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 558) // Uranus
	{
		AddVehicleComponent(car,1164);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlienSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Spoiler Succesfully", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Spoilers to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingSpoilers2(playerid);
public StopGettingSpoilers2(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1138, 1, 0.2730, 0.3860, -0.0230, -88.3999, -54.7999, 84.3999, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the XFlow Spoilers");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the XFlow Spoilers from the Spoiler Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pXFlowSpoiler] = 1;
    PlayerInfo[playerid][pCarrySpoilers] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingSpoilers2(playerid);
public StopAddingSpoilers2(playerid)
{
    new car = GetNearbyVehicle(playerid);   

    if(GetVehicleModel(car) == 562) // Elegy
	{
	    AddVehicleComponent(car,1146);
        PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pXFlowSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 565) // Flash
	{
		AddVehicleComponent(car,1150);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pXFlowSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 559) // Jetser
	{
		AddVehicleComponent(car,1158);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pXFlowSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 561) // Stratum
	{
		AddVehicleComponent(car,1060);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pXFlowSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 560) // Sultan
	{
		AddVehicleComponent(car,1139);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pXFlowSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 558)  // Uranus
	{
		AddVehicleComponent(car,1163);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pXFlowSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Spoiler Succesfully", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Spoilers to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingSpoilers3(playerid);
public StopGettingSpoilers3(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1138, 1, 0.2730, 0.3860, -0.0230, -88.3999, -54.7999, 84.3999, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Win Spoilers");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Win Spoilers from the Spoiler Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pWinSpoiler] = 1;
    PlayerInfo[playerid][pCarrySpoilers] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingSpoilers3(playerid);
public StopAddingSpoilers3(playerid)
{
    new car = GetNearbyVehicle(playerid);   

    if(GetVehicleModel(car) == 401) // bravura
	{
	    AddVehicleComponent(car,1001);
        PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
	    
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pWinSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Win Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 565) // buccaneeru
	{
		AddVehicleComponent(car,1001);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
	    
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pWinSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Win Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 527) // cadrona
	{
		AddVehicleComponent(car,1001);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pWinSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Win Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 415) // cheetah
	{
		AddVehicleComponent(car,1001);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pWinSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Win Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 546) // intrude
	{
		AddVehicleComponent(car,1001);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pWinSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Win Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 603)  // phoenix
	{
		AddVehicleComponent(car,1001);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pWinSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Win Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 436)  // premier
	{
		AddVehicleComponent(car,1001);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pWinSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Win Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 405)  // previon
	{
		AddVehicleComponent(car,1001);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pWinSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Win Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 477)  // sentinel
	{
		AddVehicleComponent(car,1001);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pWinSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Win Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 580)  // stallion
	{
		AddVehicleComponent(car,1001);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pWinSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Win Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 550)  // stafford
	{
		AddVehicleComponent(car,1001);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pWinSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Win Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 549)  // sunrise
	{
		AddVehicleComponent(car,1001);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pWinSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Win Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 549)  // tampa
	{
		AddVehicleComponent(car,1001);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pWinSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Win Spoiler Succesfully", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Spoilers to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingSpoilers4(playerid);
public StopGettingSpoilers4(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1138, 1, 0.2730, 0.3860, -0.0230, -88.3999, -54.7999, 84.3999, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Fury Spoilers");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Fury Spoilers from the Spoiler Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pFurySpoiler] = 1;
    PlayerInfo[playerid][pCarrySpoilers] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingSpoilers4(playerid);
public StopAddingSpoilers4(playerid)
{
    new car = GetNearbyVehicle(playerid);   

    if(GetVehicleModel(car) == 518) // buccaneer
	{
		AddVehicleComponent(car,1023);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pFurySpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 415) // cheetah
	{
	    AddVehicleComponent(car,1023);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pFurySpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 546) // intruder
	{
		AddVehicleComponent(car,1023);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pFurySpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 517) // majestic
	{
		AddVehicleComponent(car,1023);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pFurySpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 603) // phoenix
	{
	    AddVehicleComponent(car,1023);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pFurySpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 405) // sentinel
	{
	    AddVehicleComponent(car,1023);
        PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pFurySpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 477) // stallion
	{
	    AddVehicleComponent(car,1023);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pFurySpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 580) // stafford
	{
	    AddVehicleComponent(car,1023);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pFurySpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 550) // sunrise
	{
	    AddVehicleComponent(car,1023);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pFurySpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 549) // tampa
	{
	    AddVehicleComponent(car,1023);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pFurySpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
    else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Spoilers to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingSpoilers5(playerid);
public StopGettingSpoilers5(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1138, 1, 0.2730, 0.3860, -0.0230, -88.3999, -54.7999, 84.3999, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Alpha Spoilers");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Alpha Spoilers from the Spoiler Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pAlphaSpoiler] = 1;
    PlayerInfo[playerid][pCarrySpoilers] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingSpoilers5(playerid);
public StopAddingSpoilers5(playerid)
{
    new car = GetNearbyVehicle(playerid);   

    if(GetVehicleModel(car) == 518) // buccaneer
    {
	    AddVehicleComponent(car,1003);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	    
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlphaSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 415) // cheetah
	{
	    AddVehicleComponent(car,1003);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlphaSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 401) // bravura
	{
		AddVehicleComponent(car,1003);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlphaSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 517) // majestic
	{
		AddVehicleComponent(car,1003);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlphaSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 426) // premier
    {
	    AddVehicleComponent(car,1003);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlphaSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 436) // previon
	{
		AddVehicleComponent(car,1003);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlphaSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 477) // stallion
	{
		AddVehicleComponent(car,1003);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlphaSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 547) // primo
	{
		AddVehicleComponent(car,1003);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlphaSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 550) // sunrise
	{
		AddVehicleComponent(car,1003);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlphaSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 549) // tampa
	{
		AddVehicleComponent(car,1003);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlphaSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
    }
    else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Spoilers to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingSpoilers6(playerid);
public StopGettingSpoilers6(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1138, 1, 0.2730, 0.3860, -0.0230, -88.3999, -54.7999, 84.3999, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Pro Spoilers");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Pro Spoilers from the Spoiler Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pProSpoiler] = 1;
    PlayerInfo[playerid][pCarrySpoilers] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingSpoilers6(playerid);
public StopAddingSpoilers6(playerid)
{
    new car = GetNearbyVehicle(playerid);   

    if(GetVehicleModel(car) == 518) // club
	{
        AddVehicleComponent(car,1000);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pProSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 492) // greenwood
	{
		AddVehicleComponent(car,1000);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pProSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alpha Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 547) // primo
	{
		AddVehicleComponent(car,1000);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pProSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alpha Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 405) // sentinel
	{
        AddVehicleComponent(car,1000);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pProSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alpha Spoiler Succesfully", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Spoilers to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingSpoilers7(playerid);
public StopGettingSpoilers7(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1138, 1, 0.2730, 0.3860, -0.0230, -88.3999, -54.7999, 84.3999, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Champ Spoilers");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Champ Spoilers from the Spoiler Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pChampSpoiler] = 1;
    PlayerInfo[playerid][pCarrySpoilers] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingSpoilers7(playerid);
public StopAddingSpoilers7(playerid)
{
    new car = GetNearbyVehicle(playerid);   

    if(GetVehicleModel(car) == 527) // cadrona
	{
	    AddVehicleComponent(car,1014);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChampSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Champ Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 542) // clover
	{
	    AddVehicleComponent(car,1014);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChampSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Champ Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 405) // sentinel
	{
        AddVehicleComponent(car,1014);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChampSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Champ Spoiler Succesfully", GetRPName(playerid));
	}
}

forward StopGettingSpoilers8(playerid);
public StopGettingSpoilers8(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1138, 1, 0.2730, 0.3860, -0.0230, -88.3999, -54.7999, 84.3999, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Race Spoilers");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Race Spoilers from the Spoiler Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pRaceSpoiler] = 1;
    PlayerInfo[playerid][pCarrySpoilers] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingSpoilers8(playerid);
public StopAddingSpoilers8(playerid)
{
    new car = GetNearbyVehicle(playerid);   

    if(GetVehicleModel(car) == 527) // cadrona
	{
		AddVehicleComponent(car,1014);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pRaceSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Race Spoiler Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 542) // clover
	{
	    AddVehicleComponent(car,1014);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pRaceSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Race Spoiler Succesfully", GetRPName(playerid));
	}
    else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Spoilers to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingSpoilers9(playerid);
public StopGettingSpoilers9(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1138, 1, 0.2730, 0.3860, -0.0230, -88.3999, -54.7999, 84.3999, 0.8000, 0.8000, 0.8000);
    SCM(playerid, COLOR_WHITE, "You successfully get the Drag Spoilers");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Drag Spoilers from the Spoiler Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pDragSpoiler] = 1;
    PlayerInfo[playerid][pCarrySpoilers] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingSpoilers9(playerid);
public StopAddingSpoilers9(playerid)
{
    new car = GetNearbyVehicle(playerid);   

    if(GetVehicleModel(car) == 546) // intruder
    {
		AddVehicleComponent(car,1002);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pDragSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alpha Spoiler Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 517) // majestic
	{
		AddVehicleComponent(car,1002);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pDragSpoiler] = 0;
        PlayerInfo[playerid][pCarrySpoilers] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alpha Spoiler Succesfully", GetRPName(playerid));
    }
    else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Spoilers to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingNitro2x(playerid);
public StopGettingNitro2x(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1008, 1, 0.0000, 0.5110, 0.0830, -81.7000, 89.7999, 79.7999, 1.0000, 1.0000, 1.0000);
    SCM(playerid, COLOR_WHITE, "You successfully get the 2x Nitros");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the 2x Nitros from the Nitros Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pNitro2x] = 1;
    PlayerInfo[playerid][pCarryNitros] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}
forward StopAddingNitro2x(playerid);
public StopAddingNitro2x(playerid)
{
    new car = GetNearbyVehicle(playerid);   

    AddVehicleComponent(car,1008);
	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	SendClientMessage(playerid,COLOR_WHITE,"Nitro successfully added");
	
	SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pNitro2x] = 0;
    PlayerInfo[playerid][pCarryNitros] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added 2x Nitro Succesfully", GetRPName(playerid));
}
forward StopGettingNitro5x(playerid);
public StopGettingNitro5x(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1010, 1, 0.0000, 0.5110, 0.0830, -81.7000, 89.7999, 79.7999, 1.0000, 1.0000, 1.0000);
    SCM(playerid, COLOR_WHITE, "You successfully get the 5x Nitros");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the 5x Nitros from the Nitros Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pNitro5x] = 1;
    PlayerInfo[playerid][pCarryNitros] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}
forward StopAddingNitro5x(playerid);
public StopAddingNitro5x(playerid)
{
    new car = GetNearbyVehicle(playerid);   
  
    AddVehicleComponent(car,1009);
	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	SendClientMessage(playerid,COLOR_WHITE,"Nitro successfully added");
	
	SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pNitro5x] = 0;
    PlayerInfo[playerid][pCarryNitros] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added 5x Nitros Succesfully", GetRPName(playerid));
}

forward StopGettingNitro10x(playerid);
public StopGettingNitro10x(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1010, 1, 0.0000, 0.5110, 0.0830, -81.7000, 89.7999, 79.7999, 1.0000, 1.0000, 1.0000);
    SCM(playerid, COLOR_WHITE, "You successfully get the 10x Nitros");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the 10x Nitros from the Nitros Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pNitro10x] = 1;
    PlayerInfo[playerid][pCarryNitros] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}
forward StopAddingNitro10x(playerid);
public StopAddingNitro10x(playerid)
{
    new car = GetNearbyVehicle(playerid);   
    
    AddVehicleComponent(car,1010);
	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	SendClientMessage(playerid,COLOR_WHITE,"Nitro successfully added");
	
	SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
    PlayerInfo[playerid][pNitro10x] = 0;
    PlayerInfo[playerid][pCarryNitros] = 0;
    ClearAnimations(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added 10x Nitro Succesfully", GetRPName(playerid));
}

forward StopGettingExhaust1(playerid);
public StopGettingExhaust1(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1066, 1, -0.3860, -0.1980, 0.1090, -178.6000, -88.7000, 15.9000, 0.5000, 0.5000, 0.8999);
    SCM(playerid, COLOR_WHITE, "You successfully get the Alien Exhaust");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Alien Exhaust from the Exhaust Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pAlienExhaust] = 1;
    PlayerInfo[playerid][pCarryExhaust] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingExhaust1(playerid);
public StopAddingExhaust1(playerid)
{
    new car = GetNearbyVehicle(playerid);   

    if(GetVehicleModel(car) == 562)
	{
	    AddVehicleComponent(car,1034);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlienExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 565)
	{
		AddVehicleComponent(car,1046);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlienExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 559)
	{
		AddVehicleComponent(car,1065);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlienExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 561)
	{
		AddVehicleComponent(car,1064);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlienExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 560)
	{
		AddVehicleComponent(car,1028);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlienExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 558)
	{
		AddVehicleComponent(car,1089);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pAlienExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Alien Exhaust Succesfully", GetRPName(playerid));
    }
    else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Spoilers to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingExhaust2(playerid);
public StopGettingExhaust2(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1066, 1, -0.3860, -0.1980, 0.1090, -178.6000, -88.7000, 15.9000, 0.5000, 0.5000, 0.8999);
    SCM(playerid, COLOR_WHITE, "You successfully get the XFlow Exhaust");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the XFlow Exhaust from the Exhaust Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pXFlowExhaust] = 1;
    PlayerInfo[playerid][pCarryExhaust] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingExhaust2(playerid);
public StopAddingExhaust2(playerid)
{
    new car = GetNearbyVehicle(playerid);   

    if(GetVehicleModel(car) == 562)
	{
	    AddVehicleComponent(car,1037);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pXFlowExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added XFlow Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 565)
	{
		AddVehicleComponent(car,1045);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pXFlowExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added XFlow Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 559)
	{
		AddVehicleComponent(car,1066);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pXFlowExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added XFlow Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 561)
	{
		AddVehicleComponent(car,1059);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pXFlowExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added XFlow Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 560)
	{
		AddVehicleComponent(car,1029);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pXFlowExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added XFlow Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 558)
	{
		AddVehicleComponent(car,1092);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pXFlowExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added XFlow Exhaust Succesfully", GetRPName(playerid));
    }
    else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Spoilers to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingExhaust3(playerid);
public StopGettingExhaust3(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1066, 1, -0.3860, -0.1980, 0.1090, -178.6000, -88.7000, 15.9000, 0.5000, 0.5000, 0.8999);
    SCM(playerid, COLOR_WHITE, "You successfully get the Chromer Exhaust");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Chromer Exhaust from the Exhaust Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pChromerExhaust] = 1;
    PlayerInfo[playerid][pCarryExhaust] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingExhaust3(playerid);
public StopAddingExhaust3(playerid)
{
    new car = GetNearbyVehicle(playerid);   

    if(GetVehicleModel(car) == 575) // Brodway
    {
		AddVehicleComponent(car,1044);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChromerExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 534)// Remington
	{
		AddVehicleComponent(car,1126);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChromerExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 567)// Savanna
	{
		AddVehicleComponent(car,1129);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChromerExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 536) // Blade
	{
		AddVehicleComponent(car,1104);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChromerExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 535) // Slamvan
	{
       AddVehicleComponent(car,1113);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pChromerExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 576) // Tornado
	{
		AddVehicleComponent(car,1136);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChromerExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Chromer Exhaust Succesfully", GetRPName(playerid));
	}
    else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Spoilers to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingExhaust4(playerid);
public StopGettingExhaust4(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1066, 1, -0.3860, -0.1980, 0.1090, -178.6000, -88.7000, 15.9000, 0.5000, 0.5000, 0.8999);
    SCM(playerid, COLOR_WHITE, "You successfully get the Slamin Exhaust");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Slamin Exhaust from the Exhaust Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pSlaminExhaust] = 1;
    PlayerInfo[playerid][pCarryExhaust] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingExhaust4(playerid);
public StopAddingExhaust4(playerid)
{
    new car = GetNearbyVehicle(playerid);   

    if(GetVehicleModel(car) == 575) // Brodway
    {
	   AddVehicleComponent(car,1043);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pSlaminExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 534)// Remington
	{
	   AddVehicleComponent(car,1127);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pSlaminExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 567)// Savanna
	{
	   AddVehicleComponent(car,1132);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
	
       SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pSlaminExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 536) // Blade
	{
       AddVehicleComponent(car,1105);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pSlaminExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 535) // Slamvan
	{
       AddVehicleComponent(car,1114);
       PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pSlaminExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 576) // Tornado
	{
	   AddVehicleComponent(car,1135);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pSlaminExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Slamin Exhaust Succesfully", GetRPName(playerid));
	}
    else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Exhaust to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingExhaust5(playerid);
public StopGettingExhaust5(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1066, 1, -0.3860, -0.1980, 0.1090, -178.6000, -88.7000, 15.9000, 0.5000, 0.5000, 0.8999);
    SCM(playerid, COLOR_WHITE, "You successfully get the Large Exhaust");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Large Exhaust from the Exhaust Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pLargeExhaust] = 1;
    PlayerInfo[playerid][pCarryExhaust] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingExhaust5(playerid);
public StopAddingExhaust5(playerid)
{
    new car = GetNearbyVehicle(playerid);   

    if(GetVehicleModel(car) == 401) // bravura
	{
		AddVehicleComponent(car,1020);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
        
        SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pLargeExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Large Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 518) // buccaneer
	{
		AddVehicleComponent(car,1020);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pLargeExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Large Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 527) // cadrona
	{
	    AddVehicleComponent(car,1020);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pLargeExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Large Exhaust Succesfully", GetRPName(playerid));
    }
	else if(GetVehicleModel(car) == 542) // clover
    {
	    AddVehicleComponent(car,1020);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pLargeExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Large Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 589) // club
	{
		AddVehicleComponent(car,1020);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pLargeExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Large Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 400) // landstalker
	{
		AddVehicleComponent(car,1020);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pLargeExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Large Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 603) // phoenix
	{
		AddVehicleComponent(car,1020);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pLargeExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Large Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 436) // previon
	{
	   AddVehicleComponent(car,1020);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pLargeExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Large Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 547) // primo
	{
	    AddVehicleComponent(car,1020);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pLargeExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Large Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 405) // sentinel
	{
		AddVehicleComponent(car,1020);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pLargeExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Large Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 580) // stafford
	{
		AddVehicleComponent(car,1020);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pLargeExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Large Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 550) // sunrise
	{
		AddVehicleComponent(car,1020);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pLargeExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Large Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 549) // tampa
	{
	   AddVehicleComponent(car,1020);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pLargeExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Large Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 477) // zr-350
	{
	   AddVehicleComponent(car,1020);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pLargeExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Large Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 517) // majestic
	{
	    AddVehicleComponent(car,1020);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pLargeExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Large Exhaust Succesfully", GetRPName(playerid));
	}
    else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Exhaust to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingExhaust6(playerid);
public StopGettingExhaust6(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1066, 1, -0.3860, -0.1980, 0.1090, -178.6000, -88.7000, 15.9000, 0.5000, 0.5000, 0.8999);
    SCM(playerid, COLOR_WHITE, "You successfully get the Medium Exhaust");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Medium Exhaust from the Exhaust Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pMediumExhaust] = 1;
    PlayerInfo[playerid][pCarryExhaust] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingExhaust6(playerid);
public StopAddingExhaust6(playerid)
{
    new car = GetNearbyVehicle(playerid);
    
    if(GetVehicleModel(car) == 527) // cadrona
	{
		AddVehicleComponent(car,1021);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
	    
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pMediumExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Medium Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 542) // clover
	{
		AddVehicleComponent(car,1021);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pMediumExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Medium Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 400) // landstalker
	{
		AddVehicleComponent(car,1021);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pMediumExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Medium Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 426) // premier
	{
		AddVehicleComponent(car,1021);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pMediumExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Medium Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 436) // previon
	{
		AddVehicleComponent(car,1021);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pMediumExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Medium Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 547) // primo
	{
		AddVehicleComponent(car,1021);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pMediumExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Medium Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 405) // sentinel
	{
		AddVehicleComponent(car,1021);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pMediumExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Medium Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 477) // zr350
	{
	    AddVehicleComponent(car,1021);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pMediumExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Medium Exhaust Succesfully", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Exhaust to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingExhaust7(playerid);
public StopGettingExhaust7(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1066, 1, -0.3860, -0.1980, 0.1090, -178.6000, -88.7000, 15.9000, 0.5000, 0.5000, 0.8999);
    SCM(playerid, COLOR_WHITE, "You successfully get the Small Exhaust");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Small Exhaust from the Exhaust Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pSmallExhaust] = 1;
    PlayerInfo[playerid][pCarryExhaust] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingExhaust7(playerid);
public StopAddingExhaust7(playerid)
{
   new car = GetNearbyVehicle(playerid);

   if(GetVehicleModel(car) == 436) // previon
   {
	  AddVehicleComponent(car,1022);
      PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
      SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	  SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
      PlayerInfo[playerid][pSmallExhaust] = 0;
      PlayerInfo[playerid][pCarryExhaust] = 0;
      ClearAnimations(playerid, 1);
      RemovePlayerAttachedObject(playerid, 8);
      SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
      GameTextForPlayer(playerid, "~g~Success", 4000, 3);
      SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Small Exhaust Succesfully", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Exhaust to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingExhaust8(playerid);
public StopGettingExhaust8(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1066, 1, -0.3860, -0.1980, 0.1090, -178.6000, -88.7000, 15.9000, 0.5000, 0.5000, 0.8999);
    SCM(playerid, COLOR_WHITE, "You successfully get the Twin Exhaust");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Twin Exhaust from the Exhaust Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pTwinExhaust] = 1;
    PlayerInfo[playerid][pCarryExhaust] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingExhaust8(playerid);
public StopAddingExhaust8(playerid)
{
   new car = GetNearbyVehicle(playerid);

   if(GetVehicleModel(car) == 518) // buccaneer
   {
	   AddVehicleComponent(car,1019);
       PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
	
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pTwinExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Twin Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 415) // cheetah
	{
	    AddVehicleComponent(car,1019);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");

        SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pTwinExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Twin Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 542) // clover
	{
		AddVehicleComponent(car,1019);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pTwinExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Twin Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 546) // intruder
    {
	    AddVehicleComponent(car,1019);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pTwinExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Twin Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 400) // landstalker
	{
	   AddVehicleComponent(car,1019);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pTwinExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Twin Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 517) // majestic
	{
		AddVehicleComponent(car,1019);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pTwinExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Twin Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 603) // phoenix
	{
		AddVehicleComponent(car,1019);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pTwinExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Twin Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 426) // premier
	{
		AddVehicleComponent(car,1019);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pTwinExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Twin Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 436) // previon
	{
		AddVehicleComponent(car,1019);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pTwinExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Twin Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 547) // primo
	{
		AddVehicleComponent(car,1019);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pTwinExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Twin Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 405 ) // sentinel
	{
		AddVehicleComponent(car,1019);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pTwinExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Twin Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 550) // sunrise
	{
		AddVehicleComponent(car,1019);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pTwinExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Twin Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 549) // tampa
	{
		AddVehicleComponent(car,1019);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pTwinExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Twin Exhaust Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 477) // zr-350
	{
		AddVehicleComponent(car,1019);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pTwinExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Twin Exhaust Succesfully", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Exhaust to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingExhaust9(playerid);
public StopGettingExhaust9(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1066, 1, -0.3860, -0.1980, 0.1090, -178.6000, -88.7000, 15.9000, 0.5000, 0.5000, 0.8999);
    SCM(playerid, COLOR_WHITE, "You successfully get the UpSwept Exhaust");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Up Swept Exhaust from the Exhaust Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pUpSweptExhaust] = 1;
    PlayerInfo[playerid][pCarryExhaust] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingExhaust9(playerid);
public StopAddingExhaust9(playerid)
{
    new car = GetNearbyVehicle(playerid);

    if(GetVehicleModel(car) == 415) // cheetah
	{
	    AddVehicleComponent(car,1018);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pUpSweptExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added UpSwept Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 518) // buccaneer
    {
	   AddVehicleComponent(car,1018);
       PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pUpSweptExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added UpSwept Exhaust Succesfully", GetRPName(playerid));
    }
	else if(GetVehicleModel(car) == 527) // cadrona
	{
		AddVehicleComponent(car,1018);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pUpSweptExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added UpSwept Exhaust Succesfully", GetRPName(playerid));
    }
    else if(GetVehicleModel(car) == 542) // clover
	{
	    AddVehicleComponent(car,1018);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pUpSweptExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added UpSwept Exhaust Succesfully", GetRPName(playerid));
    }
    else if(GetVehicleModel(car) == 589) // club
	{
		AddVehicleComponent(car,1018);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pUpSweptExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added UpSwept Exhaust Succesfully", GetRPName(playerid));
    }
	else if(GetVehicleModel(car) == 400) // landstalker
    {
	   AddVehicleComponent(car,1018);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pUpSweptExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added UpSwept Exhaust Succesfully", GetRPName(playerid));
    }
    else if(GetVehicleModel(car) == 603) // phoenix
    {
	   AddVehicleComponent(car,1018);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pUpSweptExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added UpSwept Exhaust Succesfully", GetRPName(playerid));
    }
    else if(GetVehicleModel(car) == 546) // intruder
    {
	   AddVehicleComponent(car,1018);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");

       SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pUpSweptExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added UpSwept Exhaust Succesfully", GetRPName(playerid));
    }
    else if(GetVehicleModel(car) == 547) // primo
    {
	   AddVehicleComponent(car,1018);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pUpSweptExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added UpSwept Exhaust Succesfully", GetRPName(playerid));
    }
    else if(GetVehicleModel(car) == 405) // sentinel
    {
	   AddVehicleComponent(car,1018);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pUpSweptExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added UpSwept Exhaust Succesfully", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 580) // stafford
    {
	    AddVehicleComponent(car,1018);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pUpSweptExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added UpSwept Exhaust Succesfully", GetRPName(playerid));
    }
    else if(GetVehicleModel(car) == 550) // sunrise
	{
	   AddVehicleComponent(car,1018);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pUpSweptExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added UpSwept Exhaust Succesfully", GetRPName(playerid));
    }
    else if(GetVehicleModel(car) == 549) // tampa
    {
	   AddVehicleComponent(car,1018);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pUpSweptExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added UpSwept Exhaust Succesfully", GetRPName(playerid));
    }
    else if(GetVehicleModel(car) == 477) // zr-350
    {
	   AddVehicleComponent(car,1018);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	   SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
       PlayerInfo[playerid][pUpSweptExhaust] = 0;
       PlayerInfo[playerid][pCarryExhaust] = 0;
       ClearAnimations(playerid, 1);
       RemovePlayerAttachedObject(playerid, 8);
       SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
       GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added UpSwept Exhaust Succesfully", GetRPName(playerid));
    }
    else if(GetVehicleModel(car) == 517) // majestic
    {
		AddVehicleComponent(car,1018);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pUpSweptExhaust] = 0;
        PlayerInfo[playerid][pCarryExhaust] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added UpSwept Exhaust Succesfully", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Exhaust to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopAddingSideSkirt1(playerid);
public StopAddingSideSkirt1(playerid)
{
    new car = GetNearbyVehicle(playerid);

    if(GetVehicleModel(car) == 562) // Elegy
	{
	    AddVehicleComponent(car,1036);
		AddVehicleComponent(car,1040);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
	    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Alien Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 565) // Flash
	{
		AddVehicleComponent(car,1047);
		AddVehicleComponent(car,1051);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
        SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Alien Side Skirt", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 559) // Jester
	{
		AddVehicleComponent(car,1069);
	    AddVehicleComponent(car,1071);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"YComponent successfully added.");
	    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Alien Side Skirt", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 561) // Stratum
    {
		AddVehicleComponent(car,1056);
	    AddVehicleComponent(car,1062);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Alien Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 560) // Sultan
	{
		AddVehicleComponent(car,1026);
		AddVehicleComponent(car,1027);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
        SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Alien Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 558) // Uranus
	{
		AddVehicleComponent(car,1090);
	    AddVehicleComponent(car,1094);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
        SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Alien Side Skirt", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the sideskirt to this car");
	}
}

forward StopAddingSideSkirt2(playerid);
public StopAddingSideSkirt2(playerid)
{
    new car = GetNearbyVehicle(playerid);

    if(GetVehicleModel(car) == 562) // Elegy
	{
	    AddVehicleComponent(car,1039);
		AddVehicleComponent(car,1041);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to XFlow Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 565) // Flash
	{
		AddVehicleComponent(car,1048);
		AddVehicleComponent(car,1052);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to XFlow Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 559) // Jetser
	{
	    AddVehicleComponent(car,1070);
		AddVehicleComponent(car,1072);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to XFlow Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 561) // Stratum
	{
	    AddVehicleComponent(car,1057);
		AddVehicleComponent(car,1063);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to XFlow Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 560) // Sultan
	{
		AddVehicleComponent(car,1031);
		AddVehicleComponent(car,1030);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to XFlow Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 558)  // Uranus
	{
		AddVehicleComponent(car,1093);
		AddVehicleComponent(car,1095);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to XFlow Side Skirt", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the sideskirt to this car");
	}
}

forward StopAddingSideSkirt3(playerid);
public StopAddingSideSkirt3(playerid)
{
    new car = GetNearbyVehicle(playerid);

    if(GetVehicleModel(car) == 575) // Brodway
	{
	    AddVehicleComponent(car,1042);
	    AddVehicleComponent(car,1099);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Chrome Strip Side Skirt", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 567) // Savanna
    {
		AddVehicleComponent(car,1102);
		AddVehicleComponent(car,1133);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Chrome Strip Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 576) // Tornado
	{
		AddVehicleComponent(car,1134);
		AddVehicleComponent(car,1137);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
	    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Chrome Strip Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 536) // Blade
	{
		AddVehicleComponent(car,1108);
		AddVehicleComponent(car,1107);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Chrome Strip Side Skirt", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the sideskirt to this car");
	}
}

forward StopAddingSideSkirt4(playerid);
public StopAddingSideSkirt4(playerid)
{
    new car = GetNearbyVehicle(playerid);

    if(GetVehicleModel(car) == 534) // Remington
	{
	    AddVehicleComponent(car,1122);
	    AddVehicleComponent(car,1101);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
	    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Chrome Strip Side Skirt", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the sideskirt to this car");
	}
}

forward StopAddingSideSkirt5(playerid);
public StopAddingSideSkirt5(playerid)
{
    new car = GetNearbyVehicle(playerid);

    if(GetVehicleModel(car) == 534) // Remington
    {
		AddVehicleComponent(car,1106);
		AddVehicleComponent(car,1124);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
	    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Chrome Flames Side Skirt", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the sideskirt to this car");
	}
}

forward StopAddingSideSkirt6(playerid);
public StopAddingSideSkirt6(playerid)
{
    new car = GetNearbyVehicle(playerid);

    if(GetVehicleModel(car) == 535) // Slamvan
	{
	    AddVehicleComponent(car,1118);
		AddVehicleComponent(car,1120);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
	    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Chrome Arches Side Skirt", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the sideskirt to this car");
	}
}

forward StopAddingSideSkirt7(playerid);
public StopAddingSideSkirt7(playerid)
{
    new car = GetNearbyVehicle(playerid);

    if(GetVehicleModel(car) == 535) // Slamvan
	{
		AddVehicleComponent(car,1119);
		AddVehicleComponent(car,1121);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added.");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Wheelscover Side Skirt", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the sideskirt to this car");
	}
}

forward StopAddingSideSkirt8(playerid);
public StopAddingSideSkirt8(playerid)
{
    new car = GetNearbyVehicle(playerid);

    if(GetVehicleModel(car) == 401)
	{
		AddVehicleComponent(car,1007);
	    AddVehicleComponent(car,1017);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Transfender Strip Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 518)
	{
		AddVehicleComponent(car,1007);
	    AddVehicleComponent(car,1017);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Transfender Strip Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 527)
	{
		AddVehicleComponent(car,1007);
		AddVehicleComponent(car,1017);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Transfender Strip Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 415)
	{
		AddVehicleComponent(car,1007);
		AddVehicleComponent(car,1017);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Transfender Strip Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 589)
	{
		AddVehicleComponent(car,1007);
	    AddVehicleComponent(car,1017);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Transfender Strip Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 546)
	{
		AddVehicleComponent(car,1007);
		AddVehicleComponent(car,1017);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Transfender Strip Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 517)
	{
		AddVehicleComponent(car,1007);
	    AddVehicleComponent(car,1017);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Transfender Strip Side Skirt", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 603)
    {
		AddVehicleComponent(car,1007);
		AddVehicleComponent(car,1017);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Transfender Strip Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 436)
	{
		AddVehicleComponent(car,1007);
		AddVehicleComponent(car,1017);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Transfender Strip Side Skirt", GetRPName(playerid));
	}
    else if(GetVehicleModel(car) == 439)
	{
		AddVehicleComponent(car,1007);
		AddVehicleComponent(car,1017);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Transfender Strip Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 580)
	{
	    AddVehicleComponent(car,1007);
		AddVehicleComponent(car,1017);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
        SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Transfender Strip Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 549)
    {
		AddVehicleComponent(car,1007);
		AddVehicleComponent(car,1017);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Transfender Strip Side Skirt", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 477)
	{
		AddVehicleComponent(car,1007);
	    AddVehicleComponent(car,1017);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the sideskirt of the vehicle to Transfender Strip Side Skirt", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the sideskirt to this car");
	}
}

forward StopGettingVents1(playerid);
public StopGettingVents1(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1142, 1, 0.08, 0.49, -0.05, 85, 90, -2.5, 0.9, 1, 1);
    SCM(playerid, COLOR_WHITE, "You successfully get the Oval Vents");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Oval Vents from the Vents Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pOvalVents] = 1;
    PlayerInfo[playerid][pCarryVents] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingVents1(playerid);
public StopAddingVents1(playerid)
{
    new car = GetNearbyVehicle(playerid);

    if(GetVehicleModel(car) == 401) // bravura
	{
		AddVehicleComponent(car,1142);
		AddVehicleComponent(car,1143);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
		
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pOvalVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Vents Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 518) // buccaneer
	{
		AddVehicleComponent(car,1142);
		AddVehicleComponent(car,1143);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pOvalVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Vents Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 546) // intruder
	{
	    AddVehicleComponent(car,1142);
		AddVehicleComponent(car,1143);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pOvalVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Vents Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 517) // majestic
	{
		AddVehicleComponent(car,1142);
	    AddVehicleComponent(car,1143);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pOvalVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Vents Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 603) // phoenix
	{
		AddVehicleComponent(car,1142);
	    AddVehicleComponent(car,1143);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pOvalVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Vents Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 547) // primo
	{
		AddVehicleComponent(car,1142);
		AddVehicleComponent(car,1143);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pOvalVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Vents Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 439) // stallion
	{
		AddVehicleComponent(car,1142);
		AddVehicleComponent(car,1143);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pOvalVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Vents Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 550) // sunrise
	{
		AddVehicleComponent(car,1142);
		AddVehicleComponent(car,1143);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pOvalVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Vents Succesfully", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 549) // tampa
	{
	    AddVehicleComponent(car,1142);
		AddVehicleComponent(car,1143);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pOvalVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Vents Succesfully", GetRPName(playerid));
	}
	else
	{
	    GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Vents to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingVents2(playerid);
public StopGettingVents2(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1144, 1, 0.08, 0.49, -0.05, 85, 90, -2.5, 0.9, 1, 1);
    SCM(playerid, COLOR_WHITE, "You successfully get the Square Vents");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Square Vents from the Vents Parts.", GetRPName(playerid));
    PlayerInfo[playerid][pSquareVents] = 1;
    PlayerInfo[playerid][pCarryVents] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingVents2(playerid);
public StopAddingVents2(playerid)
{
    new car = GetNearbyVehicle(playerid);

    if(GetVehicleModel(car) == 401) // bravura
	{
		AddVehicleComponent(car,1142);
		AddVehicleComponent(car,1143);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");           

        SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pSquareVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Square Vents Succesfully", GetRPName(playerid)); 
	}
	else if(GetVehicleModel(car) == 518) // buccaneer
	{
		AddVehicleComponent(car,1142);
		AddVehicleComponent(car,1143);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pSquareVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Square Vents Succesfully", GetRPName(playerid)); 
	}
	else if(GetVehicleModel(car) == 546) // intruder
	{
		AddVehicleComponent(car,1142);
		AddVehicleComponent(car,1143);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pSquareVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Square Vents Succesfully", GetRPName(playerid)); 
	}
	else if(GetVehicleModel(car) == 517) // majestic
	{
		AddVehicleComponent(car,1142);
		AddVehicleComponent(car,1143);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pSquareVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Square Vents Succesfully", GetRPName(playerid)); 
	}
	else if(GetVehicleModel(car) == 603) // phoenix
	{
		AddVehicleComponent(car,1142);
		AddVehicleComponent(car,1143);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pSquareVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Square Vents Succesfully", GetRPName(playerid)); 
	}
	else if(GetVehicleModel(car) == 547) // primo
	{
		AddVehicleComponent(car,1142);
		AddVehicleComponent(car,1143);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pSquareVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Square Vents Succesfully", GetRPName(playerid)); 
	}
	else if(GetVehicleModel(car) == 439) // stallion
	{
		AddVehicleComponent(car,1142);
	    AddVehicleComponent(car,1143);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pSquareVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Square Vents Succesfully", GetRPName(playerid)); 
	}
	else if(GetVehicleModel(car) == 550) // sunrise
	{
		AddVehicleComponent(car,1142);
	    AddVehicleComponent(car,1143);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pSquareVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Square Vents Succesfully", GetRPName(playerid)); 
	}
	else if(GetVehicleModel(car) == 549) // tampa
	{
		AddVehicleComponent(car,1142);
		AddVehicleComponent(car,1143);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pSquareVents] = 0;
        PlayerInfo[playerid][pCarryVents] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Square Vents Succesfully", GetRPName(playerid)); 
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Vents to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopChangingLights1(playerid);
public StopChangingLights1(playerid)
{
    new car = GetNearbyVehicle(playerid);

    if(GetVehicleModel(car) == 401) // bravura
	{
       AddVehicleComponent(car,1013);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
	   GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the lights of the vehicle to Round.", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 518) // buccaneer
    {
	   AddVehicleComponent(car,1013);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	   GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the lights of the vehicle to Round.", GetRPName(playerid));
	}
	else if(GetVehicleModel(car)== 589) // club
	{
	   AddVehicleComponent(car,1013);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	   GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the lights of the vehicle to Round.", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 400) // landstalker
	{
	   AddVehicleComponent(car,1013);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	   GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the lights of the vehicle to Round.", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 436) // previon
	{
	   AddVehicleComponent(car,1013);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	   GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the lights of the vehicle to Round.", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 439) // stallion
	{
	   AddVehicleComponent(car,1013);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	   GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the lights of the vehicle to Round.", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant change the lights to this car");
	}
}

forward StopChangingLights2(playerid);
public StopChangingLights2(playerid)
{
    new car = GetNearbyVehicle(playerid);

    if(GetVehicleModel(car) == 589) // club
	{
	   AddVehicleComponent(car,1024);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	   GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the lights of the vehicle to Square.", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 603) // phoenix
	{
	   AddVehicleComponent(car,1024);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	   GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the lights of the vehicle to Square.", GetRPName(playerid));
	}
	else if(GetVehicleModel(car) == 400) // landstalker
	{
	   AddVehicleComponent(car,1024);
	   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	   SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	   GameTextForPlayer(playerid, "~g~Success", 4000, 3);
       SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has change the lights of the vehicle to Square.", GetRPName(playerid));
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant change the lights to this car");
	}
}

forward StopGettingHoods1(playerid);
public StopGettingHoods1(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1005, 1, 0.08, 0.49, -0.05, 85, 90, -2.5, 0.9, 1, 1);
    SCM(playerid, COLOR_WHITE, "You successfully get the Fury Hoods");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Fury Hoods from the Hoods Area.", GetRPName(playerid));
    PlayerInfo[playerid][pFuryHoods] = 1;
    PlayerInfo[playerid][pCarryHoods] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingHoods1(playerid);
public StopAddingHoods1(playerid)
{
    new car = GetNearbyVehicle(playerid);

    if(GetVehicleModel(car) == 401) // bravura
	{
		AddVehicleComponent(car,1005);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	
	    SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pFuryHoods] = 0;
        PlayerInfo[playerid][pCarryHoods] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Hoods Succesfully", GetRPName(playerid)); 
	}
	else if(GetVehicleModel(car) == 518) // buccaneer
	{
		AddVehicleComponent(car,1005);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pFuryHoods] = 0;
        PlayerInfo[playerid][pCarryHoods] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Hoods Succesfully", GetRPName(playerid)); 
	}
	else if(GetVehicleModel(car) == 589) // club
	{
		AddVehicleComponent(car,1005);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pFuryHoods] = 0;
        PlayerInfo[playerid][pCarryHoods] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Hoods Succesfully", GetRPName(playerid)); 
	}
	else if(GetVehicleModel(car) == 492) // greenwood
	{
		AddVehicleComponent(car,1005);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pFuryHoods] = 0;
        PlayerInfo[playerid][pCarryHoods] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Hoods Succesfully", GetRPName(playerid)); 
	}
	else if(GetVehicleModel(car) == 426) // premier
	{
		AddVehicleComponent(car,1005);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
	}
	else if(GetVehicleModel(car) == 550) // sunrise
	{
		AddVehicleComponent(car,1005);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pFuryHoods] = 0;
        PlayerInfo[playerid][pCarryHoods] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Fury Hoods Succesfully", GetRPName(playerid)); 
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Hoods to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingHoods2(playerid);
public StopGettingHoods2(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1004, 1, 0.08, 0.49, -0.05, 85, 90, -2.5, 0.9, 1, 1);
    SCM(playerid, COLOR_WHITE, "You successfully get the Champ Hoods");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Champ Hoods from the Hoods Area.", GetRPName(playerid));
    PlayerInfo[playerid][pChampHoods] = 1;
    PlayerInfo[playerid][pCarryHoods] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingHoods2(playerid);
public StopAddingHoods2(playerid)
{
    new car = GetNearbyVehicle(playerid);

    if(GetVehicleModel(car) == 401) // bravura
	{
		AddVehicleComponent(car,1004);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChampHoods] = 0;
        PlayerInfo[playerid][pCarryHoods] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Champ Hoods Succesfully", GetRPName(playerid)); 
	}
	else if(GetVehicleModel(car) == 546) // intruder
	{
		AddVehicleComponent(car,1004);
	    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChampHoods] = 0;
        PlayerInfo[playerid][pCarryHoods] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Champ Hoods Succesfully", GetRPName(playerid)); 
	}
	else if(GetVehicleModel(car) == 492) // greenwood
	{
		AddVehicleComponent(car,1004);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChampHoods] = 0;
        PlayerInfo[playerid][pCarryHoods] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Champ Hoods Succesfully", GetRPName(playerid)); 
	}
    else if(GetVehicleModel(car) == 426) // premier
	{
		AddVehicleComponent(car,1004);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChampHoods] = 0;
        PlayerInfo[playerid][pCarryHoods] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Champ Hoods Succesfully", GetRPName(playerid)); 
	}
    else if(GetVehicleModel(car) == 550) // sunrise
	{
		AddVehicleComponent(car,1004);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pChampHoods] = 0;
        PlayerInfo[playerid][pCarryHoods] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Champ Hoods Succesfully", GetRPName(playerid)); 
	}
	else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Exhaust to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingHoods3(playerid);
public StopGettingHoods3(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1011, 1, 0.08, 0.49, -0.05, 85, 90, -2.5, 0.9, 1, 1);
    SCM(playerid, COLOR_WHITE, "You successfully get the Race Hoods");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Race Hoods from the Hoods Area.", GetRPName(playerid));
    PlayerInfo[playerid][pRaceHoods] = 1;
    PlayerInfo[playerid][pCarryHoods] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingHoods3(playerid);
public StopAddingHoods3(playerid)
{
    new car = GetNearbyVehicle(playerid);

    if(GetVehicleModel(car) == 549) // tampa
	{
		AddVehicleComponent(car,1011);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pRaceHoods] = 0;
        PlayerInfo[playerid][pCarryHoods] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Race Hoods Succesfully", GetRPName(playerid)); 
	}
    else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Hoods to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopGettingHoods4(playerid);
public StopGettingHoods4(playerid)
{
    SetPlayerAttachedObject(playerid, 8, 1012, 1, 0.08, 0.49, -0.05, 85, 90, -2.5, 0.9, 1, 1);
    SCM(playerid, COLOR_WHITE, "You successfully get the Worx Hoods");
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has get the Worx Hoods from the Hoods Area.", GetRPName(playerid));
    PlayerInfo[playerid][pWorxHoods] = 1;
    PlayerInfo[playerid][pCarryHoods] = 1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
}

forward StopAddingHoods4(playerid);
public StopAddingHoods4(playerid)
{
    new car = GetNearbyVehicle(playerid);

    if(GetVehicleModel(car) == 549) // tampa
	{
		AddVehicleComponent(car,1012);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
		
		SendClientMessage(playerid,COLOR_WHITE,"You have succesfully added");
        PlayerInfo[playerid][pWorxHoods] = 0;
        PlayerInfo[playerid][pCarryHoods] = 0;
        ClearAnimations(playerid, 1);
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        GameTextForPlayer(playerid, "~g~Success", 4000, 3);
        SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Worx Hoods Succesfully", GetRPName(playerid)); 
	}
    else
	{
		GameTextForPlayer(playerid, "~r~FAILED", 4000, 3);
        SCM(playerid, COLOR_SYNTAX, "You cant install the Hoods to this car");
        RemovePlayerAttachedObject(playerid, 8);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
}

forward StopAddingHydraulic(playerid);
public StopAddingHydraulic(playerid)
{
   new car = GetNearbyVehicle(playerid);

   AddVehicleComponent(car,1087);
   PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
   SendClientMessage(playerid,COLOR_WHITE,"Hyradraulic successfully added. ");
   SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has Installed the Hydraulic to the Vehicle", GetRPName(playerid));
}

CMD:upgradevstash(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), param[32];

	if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you upgrade this vehicle.");
	}
	if(!vehicleid)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
	}
    if(VehicleInfo[vehicleid][vTrunk] >= 3)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle's stash is already at its maximum level.");
    }
    
    VehicleInfo[vehicleid][vTrunk]++;
    GivePlayerCash(playerid, -1000);
	GameTextForPlayer(playerid, "~r~-$1000", 5000, 1);

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET trunk = %i WHERE id = %i", VehicleInfo[vehicleid][vTrunk], VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);

    SM(playerid, COLOR_YELLOW, "You have paid $1000 for stash level %i/3. '/vstash balance' to see your new capacities.", VehicleInfo[vehicleid][vTrunk]);

    //Log_Write("log_property", "%s (uid: %i) upgraded the stash of their %s (id: %i) to level %i/3.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID], VehicleInfo[vehicleid][vTrunk]);
	return 1;
}

CMD:neon(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(!vehicleid)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vNeon])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has no neon installed.");
	}

	if(!VehicleInfo[vehicleid][vNeonEnabled])
	{
	    VehicleInfo[vehicleid][vNeonEnabled] = 1;
	    GameTextForPlayer(playerid, "~g~Neon activated", 3000, 3);

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, ""SVRCLR"**{C2A2DA} %s presses a button to activate their neon tubes.", GetRPName(playerid));
	    //SendClientMessage(playerid, COLOR_WHITE, "** Neon enabled. The tubes appear under your vehicle.");
	}
	else
	{
	    VehicleInfo[vehicleid][vNeonEnabled] = 0;
	    GameTextForPlayer(playerid, "~r~Neon deactivated", 3000, 3);

	    SendProximityMessage(playerid, 20.0, SERVER_COLOR, ""SVRCLR"**{C2A2DA} %s presses a button to deactivate their neon tubes.", GetRPName(playerid));
	    //SendClientMessage(playerid, COLOR_WHITE, "** Neon disabled.");
	}

	mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET neonenabled = %i WHERE id = %i", VehicleInfo[vehicleid][vNeonEnabled], VehicleInfo[vehicleid][vID]);
	mysql_tquery(connectionID, queryBuffer);

	ReloadVehicleNeon(vehicleid);
	return 1;
}

CMD:refill(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command unless you're a Mechanic.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(gettime() - PlayerInfo[playerid][pLastRefuel] < 20)
	{
	    return SendMessage(playerid, COLOR_SYNTAX, "You can only refuel a vehicle every 20 seconds. Please wait %i more seconds.", 20 - (gettime() - PlayerInfo[playerid][pLastRefuel]));
	}
	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
	}
	if(!VehicleHasEngine(vehicleid))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has no engine which can be refueled.");
	}
	if(vehicleFuel[vehicleid] >= 100)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle doesn't need to be refueled.");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you repair this vehicle.");
	}

	if(vehicleFuel[vehicleid] + 10 >= 100)
	{
		vehicleFuel[vehicleid] = 100;
	}
	else
	{
	    vehicleFuel[vehicleid] += 10;
	}

	PlayerInfo[playerid][pLastRefuel] = gettime();

	SendProximityMessage(playerid, 20.0, SERVER_COLOR, ""SVRCLR"**{C2A2DA} %s pours some gasoline to the vehicle.", GetRPName(playerid));
	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	return 1;
}

CMD:nos(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command unless you're a Mechanic.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(!vehicleid)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you repair this vehicle.");
	}

	switch(GetVehicleModel(vehicleid))
    {
		case 581, 523, 462, 521, 463, 522, 461, 448, 468, 586, 509, 481, 510, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 590, 569, 537, 538, 570, 449:
		    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle can't be modified with nitrous.");
    }

	AddVehicleComponent(vehicleid, 1009);

	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, ""SVRCLR"**{C2A2DA} %s attaches a 2x NOS Canister on the engine feed.", GetRPName(playerid));
	return 1;
}

CMD:tow(playerid, params[])
{
    if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 525)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You must be in a tow truck to use this command.");
	}
 	if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC) && !IsLawEnforcement(playerid))
 	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a Mechanic or a Law Enforcement Officer to use this command.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}

	new Float:pX, Float:pY, Float:pZ;
    GetPlayerPos(playerid, pX, pY, pZ);
    new Float:vX, Float:vY, Float:vZ;
    new Found = 0;
    new vid = 0;
    while ((vid<MAX_VEHICLES) && (!Found)) {
        vid++;
        GetVehiclePos(vid, vX, vY, vZ);
        if ((floatabs(pX - vX)<7.0) && (floatabs(pY - vY)<7.0) && (floatabs(pZ - vZ)<7.0) && (vid != GetPlayerVehicleID(playerid))) {
            Found = 1;
            if (IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))) {
                DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
            }
            AttachTrailerToVehicle(vid, GetPlayerVehicleID(playerid));
            //SendProximityMessage(playerid, 20.0, SERVER_COLOR, ""SVRCLR"**{C2A2DA} %s lowers their tow hook, attaching it to the vehicle.", GetRPName(playerid));
            //SendProximityMessage(playerid, 20.0, SERVER_COLOR, ""SVRCLR"**{C2A2DA} %s raises the tow hook, locking the vehicle in place..", GetRPName(playerid));
        }
    }
    if (!Found) {
        SendClientMessage(playerid, COLOR_SYNTAX, "There is no vehicle in range that you can tow.");
    }
    return 1;
}

CMD:untow(playerid, params[])
{
	if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC) && !IsLawEnforcement(playerid))
 	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a Mechanic or a Law Enforcement Officer to use this command.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 525)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You must be in a tow truck to use this command.");
	}
	if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "You are not towing a vehicle.");
	}
	DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, ""SVRCLR"**{C2A2DA} %s lowers their tow hook, detaching it from the vehicle.", GetRPName(playerid));
    return 1;
}

CMD:getwheels(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 3.0, 1001.442016, -1986.144897, 13.293749))
	{
        if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
        }
	    if(PlayerInfo[playerid][pDuty] == 0)
	    {
		    return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	    }
	
        ShowPlayerDialog(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar", "Get", "Close");
    }
    return 1;
}

CMD:getspoilers(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 3.0, 1001.443054, -1974.376708, 13.293749))
	{
        if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
        }
	    if(PlayerInfo[playerid][pDuty] == 0)
	    {
		    return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	    }
	
        ShowPlayerDialog(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler", "Get", "Close");
    }
    return 1;
}

CMD:getnitros(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 3.0, 1001.438110, -1970.167602, 13.293749))
	{
        if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
        }
        if(PlayerInfo[playerid][pDuty] == 0)
        {
		    return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	    }
	
        ShowPlayerDialog(playerid, DIALOG_TYPE_NITRO, DIALOG_STYLE_LIST, "Nitrous Oxide", "2x Nitrous\n5x Nitrous\n10x Nitrous\n \nBack", "Apply", "Close");
    }
    return 1;
}

CMD:getexhaust(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 3.0, 1001.449340, -1964.061889, 13.293749))
	{
        if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
        }
        if(PlayerInfo[playerid][pDuty] == 0)
        {
		    return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	    }
	
        ShowPlayerDialog(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust", "Get", "Close");
    }
    return 1;
}

CMD:getbumpers(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 3.0, 1001.441345, -1980.592041, 13.293749))
	{
        if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
        }
        if(PlayerInfo[playerid][pDuty] == 0)
        {
		    return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	    }
	
        ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN1, DIALOG_STYLE_LIST, ""SVRCLR"Bumpers", "Front Bumpers\nRear Bumpers", "Get", "Close");
    }
    return 1;
}

CMD:getothers(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 3.0, 1008.403869, -1961.781494, 13.293750))
	{
        if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	    {
	        return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
        }
        if(PlayerInfo[playerid][pDuty] == 0)
        {
		    return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	    }
	
        ShowPlayerDialog(playerid, DIALOG_TYPE_OTHERS, DIALOG_STYLE_LIST, ""SVRCLR"Other Parts", "Hoods\nVents", "Get", "Close");
    }
    return 1;
}

CMD:addwheels(playerid, params[])
{
    new vehicleid = GetNearbyVehicle(playerid);
    if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
    {
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
    }
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be onfoot in order to use this command.");
	}
    if(PlayerInfo[playerid][pDuty] == 0)
    {
		 return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
    }
    if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle isn't owned by any particular person.");
	}
	if(!PlayerInfo[playerid][pCarryWheels])
	{ 
	    SCM(playerid, COLOR_SYNTAX, "You are not carrying wheels at the moment");
	}
	if(PlayerInfo[playerid][pOffroad])
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~y~ADDING WHEELS...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingWheels1", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pMega])
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~y~ADDING WHEELS...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingWheels2", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pWires])
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~y~ADDING WHEELS...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingWheels3", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pTwist])
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~y~ADDING WHEELS...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingWheels4", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pGrove])
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~y~ADDING WHEELS...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingWheels5", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pImport])
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~y~ADDING WHEELS...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingWheels6", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pAtomic])
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~y~ADDING WHEELS...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingWheels7", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pAhab])
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~y~ADDING WHEELS...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingWheels8", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pVirtual])
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~y~ADDING WHEELS...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingWheels9", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pAccess])
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~y~ADDING WHEELS...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingWheels10", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pTrance])
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~y~ADDING WHEELS...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingWheels11", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pShadow])
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~y~ADDING WHEELS...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingWheels12", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pRimshine])
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~y~ADDING WHEELS...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingWheels13", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pClassic])
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~y~ADDING WHEELS...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingWheels14", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pCutter])
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~y~ADDING WHEELS...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingWheels15", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pSwitch])
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~y~ADDING WHEELS...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingWheels16", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pDollWheel])
    {
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        GameTextForPlayer(playerid, "~y~ADDING WHEELS...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingWheels17", 4000, false, "i", playerid);
    }
	return 1;
}

CMD:addbumpers(playerid, params[])
{
    new vehicleid = GetNearbyVehicle(playerid);
    if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
    {
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
    }
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be onfoot in order to use this command.");
	}
    if(PlayerInfo[playerid][pDuty] == 0)
    {
		 return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
    }
    if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle isn't owned by any particular person.");
	}
	if(!PlayerInfo[playerid][pCarryBumpers])
	{
	    SCM(playerid, COLOR_SYNTAX, "You are not carrying bumpers at the moment");
	}
	if(PlayerInfo[playerid][pAlienRBump])
    {
        if (!IsNearTrunk(vehicleid, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near the trunk! ");
        
        GameTextForPlayer(playerid, "~y~ADDING BUMPERS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingRBumpers1", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pAlienFBump])
    {
        GameTextForPlayer(playerid, "~y~ADDING BUMPERS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingFBumpers1", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pXFlowRBump])
    {
        if (!IsNearTrunk(vehicleid, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near the trunk! ");
        
        GameTextForPlayer(playerid, "~y~ADDING BUMPERS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingRBumpers2", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pXFlowFBump])
    {
        GameTextForPlayer(playerid, "~y~ADDING BUMPERS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingFBumpers2", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pChromerRBump])
    {
        if (!IsNearTrunk(vehicleid, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near the trunk! ");
        
        GameTextForPlayer(playerid, "~y~ADDING BUMPERS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingRBumpers3", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pChromerFBump])
    {
        GameTextForPlayer(playerid, "~y~ADDING BUMPERS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingFBumpers3", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pSlaminFBump])
    {       
        GameTextForPlayer(playerid, "~y~ADDING BUMPERS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingFBumpers4", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pSlaminRBump])
    {
        if (!IsNearTrunk(vehicleid, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near the trunk! ");
        
        GameTextForPlayer(playerid, "~y~ADDING BUMPERS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingRBumpers4", 4000, false, "i", playerid);
    }
	return 1;
}

CMD:addspoilers(playerid, params[])
{
    new vehicleid = GetNearbyVehicle(playerid);
    if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
    {
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
    }
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be onfoot in order to use this command.");
	}
    if(PlayerInfo[playerid][pDuty] == 0)
    {
		 return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
    }
    if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle isn't owned by any particular person.");
	}
	if(!PlayerInfo[playerid][pCarrySpoilers])
	{
	    SCM(playerid, COLOR_SYNTAX, "You are not carrying spoilers at the moment");
	}
	
	if(PlayerInfo[playerid][pAlienSpoiler])
    {
        if (!IsNearTrunk(vehicleid, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near the trunk! ");
        
        GameTextForPlayer(playerid, "~y~ADDING SPOILERS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingSpoilers1", 4000, false, "i", playerid);
    }
	if(PlayerInfo[playerid][pXFlowSpoiler])
    {
        if (!IsNearTrunk(vehicleid, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near the trunk! ");
        
        GameTextForPlayer(playerid, "~y~ADDING SPOILERS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingSpoilers2", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pWinSpoiler])
    {
        GameTextForPlayer(playerid, "~y~ADDING SPOILERS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingSpoilers3", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pFurySpoiler])
    {
        if (!IsNearTrunk(vehicleid, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near the trunk! ");
        
        GameTextForPlayer(playerid, "~y~ADDING SPOILERS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingSpoilers4", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pAlphaSpoiler])
    {
        GameTextForPlayer(playerid, "~y~ADDING SPOILERS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingSpoilers5", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pProSpoiler])
    {
        if (!IsNearTrunk(vehicleid, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near the trunk! ");
        
        GameTextForPlayer(playerid, "~y~ADDING SPOILERS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingSpoilers6", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pChampSpoiler])
    {
        GameTextForPlayer(playerid, "~y~ADDING SPOILERS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingSpoilers7", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pRaceSpoiler])
    {       
        GameTextForPlayer(playerid, "~y~ADDING SPOILERS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingSpoilers8", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pDragSpoiler])
    {
        if (!IsNearTrunk(vehicleid, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near the trunk! ");
        
        GameTextForPlayer(playerid, "~y~ADDING SPOILERS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingSpoilers9", 4000, false, "i", playerid);
    }
	return 1;
}

CMD:addnitro(playerid, params[])
{
    new vehicleid = GetNearbyVehicle(playerid);
    if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
    {
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
    }
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be onfoot in order to use this command.");
	}
    if(PlayerInfo[playerid][pDuty] == 0)
    {
		 return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
    }
    if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle isn't owned by any particular person.");
	}
	if(!PlayerInfo[playerid][pCarryNitros])
	{
	    SCM(playerid, COLOR_SYNTAX, "You are not carrying spoilers at the moment");
	}
	
	if(PlayerInfo[playerid][pNitro2x])
    {
        if (!IsNearTrunk(vehicleid, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near the trunk! ");
        
        GameTextForPlayer(playerid, "~y~ADDING NITRO 2x...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingNitro2x", 4000, false, "i", playerid);
    }
	if(PlayerInfo[playerid][pNitro5x])
    {
        if (!IsNearTrunk(vehicleid, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near the trunk! ");
        
        GameTextForPlayer(playerid, "~y~ADDING NITRO 5x...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingNitro5x", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pNitro10x])
    {
        GameTextForPlayer(playerid, "~y~ADDING NITRO 10x...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingNitro10x", 4000, false, "i", playerid);
    }
	return 1;
}

CMD:addexhaust(playerid, params[])
{
    new vehicleid = GetNearbyVehicle(playerid);
    if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
    {
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
    }
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be onfoot in order to use this command.");
	}
    if(PlayerInfo[playerid][pDuty] == 0)
    {
		 return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
    }
    if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle isn't owned by any particular person.");
	}
	if(!PlayerInfo[playerid][pCarryExhaust])
	{
	    SCM(playerid, COLOR_SYNTAX, "You are not carrying exhaust at the moment");
	}
	
	if(PlayerInfo[playerid][pAlienExhaust])
    {
        if (!IsNearTrunk(vehicleid, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near the trunk! ");
        
        GameTextForPlayer(playerid, "~y~ADDING ALIEN EXHAUST...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingExhaust1", 4000, false, "i", playerid);
    }
	if(PlayerInfo[playerid][pXFlowExhaust])
    {
        if (!IsNearTrunk(vehicleid, playerid, 2.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near the trunk! ");
        
        GameTextForPlayer(playerid, "~y~ADDING XFLOW EXHAUST...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingExhaust2", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pChromerExhaust])
    {
        GameTextForPlayer(playerid, "~y~ADDING NITRO 10x...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingExhaust3", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pSlaminExhaust])
    {
        GameTextForPlayer(playerid, "~y~ADDING NITRO 10x...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingExhaust4", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pLargeExhaust])
    {
        GameTextForPlayer(playerid, "~y~ADDING NITRO 10x...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingExhaust5", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pMediumExhaust])
    {
        GameTextForPlayer(playerid, "~y~ADDING NITRO 10x...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingExhaust6", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pSmallExhaust])
    {
        GameTextForPlayer(playerid, "~y~ADDING NITRO 10x...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingExhaust7", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pTwinExhaust])
    {
        GameTextForPlayer(playerid, "~y~ADDING NITRO 10x...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingExhaust8", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pUpSweptExhaust])
    {
        GameTextForPlayer(playerid, "~y~ADDING NITRO 10x...", 4000, 3);
        ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingExhaust9", 4000, false, "i", playerid);
    }
	return 1;
}

CMD:changesideskirt(playerid, params[])
{
    new vehicleid = GetNearbyVehicle(playerid);
    if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
    {
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
    }
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be onfoot in order to use this command.");
	}
    if(PlayerInfo[playerid][pDuty] == 0)
    {
		 return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
    }
    if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle isn't owned by any particular person.");
	}
	
	ShowPlayerDialog(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s is changing the sideskirt of the vehicle", GetRPName(playerid));
	return 1;
}

CMD:addvents(playerid, params[])
{
    new vehicleid = GetNearbyVehicle(playerid);
    if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
    {
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
    }
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be onfoot in order to use this command.");
	}
    if(PlayerInfo[playerid][pDuty] == 0)
    {
		 return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
    }
    if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle isn't owned by any particular person.");
	}
	if(!PlayerInfo[playerid][pCarryVents])
	{
	    SCM(playerid, COLOR_SYNTAX, "You are not carrying vents at the moment");
	}
	if(PlayerInfo[playerid][pOvalVents])
    {
        GameTextForPlayer(playerid, "~y~ADDING OVAL VENTS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingVents1", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pSquareVents])
    {
        GameTextForPlayer(playerid, "~y~ADDING SQUARE VENTS....", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingVents2", 4000, false, "i", playerid);
    }
    return 1;
}

CMD:addhoods(playerid, params[])
{
    new vehicleid = GetNearbyVehicle(playerid);
    if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
    {
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
    }
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be onfoot in order to use this command.");
	}
    if(PlayerInfo[playerid][pDuty] == 0)
    {
		 return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
    }
    if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle isn't owned by any particular person.");
	}
	if(!PlayerInfo[playerid][pCarryHoods])
	{
	    SCM(playerid, COLOR_SYNTAX, "You are not carrying hoods at the moment");
	}
	if(PlayerInfo[playerid][pFuryHoods])
    {
        if (IsNearTrunk(vehicleid, playerid, 4.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near at the hood! ");
        
        GameTextForPlayer(playerid, "~y~ADDING FURY HOODS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingHoods1", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pChampHoods])
    {
        if (IsNearTrunk(vehicleid, playerid, 4.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near at the hood! ");
        
        GameTextForPlayer(playerid, "~y~ADDING CHAMP HOODS....", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingHoods2", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pRaceHoods])
    {
        if (IsNearTrunk(vehicleid, playerid, 4.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near at the hood! ");
        
        GameTextForPlayer(playerid, "~y~ADDING RACE HOODS...", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingHoods3", 4000, false, "i", playerid);
    }
    if(PlayerInfo[playerid][pWorxHoods])
    {
        if (IsNearTrunk(vehicleid, playerid, 4.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near at the hood! ");
        
        GameTextForPlayer(playerid, "~y~ADDING WORX HOODS....", 4000, 3);
        ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);
        SetTimerEx("StopAddingHoods4", 4000, false, "i", playerid);
    }
    return 1;
}

CMD:addhydraulic(playerid, params[])
{
    new vehicleid = GetNearbyVehicle(playerid);
    if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
    {
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
    }
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be onfoot in order to use this command.");
	}
    if(PlayerInfo[playerid][pDuty] == 0)
    {
		 return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
    }
    if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle isn't owned by any particular person.");
	}
	if(!PlayerInfo[playerid][pCarryHoods])
	{
	    SCM(playerid, COLOR_SYNTAX, "You are not carrying hoods at the moment");
	}
	
	GameTextForPlayer(playerid, "~y~INSTALLING HYDARULIC.....", 4000, 3);
    ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);

	SetTimerEx("StopAddingHydraulic", 4000, false, "i", playerid);
	return 1;
}

CMD:changelight(playerid, params[])
{
    new vehicleid = GetNearbyVehicle(playerid), option[12];
   
    if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
    {
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
    }
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be onfoot in order to use this command.");
	}
	if(sscanf(params, "s[12]", option))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /changelight [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "Available options: Square, Round");
	    return 1;
    }
    if(PlayerInfo[playerid][pDuty] == 0)
    {
		 return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
    }
    if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle isn't owned by any particular person.");
	}
    
    if(!strcmp(option, "Square", true))
	{
	   GameTextForPlayer(playerid, "~y~CHANGING LIGHTS.....", 4000, 3);
       ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);

	   SetTimerEx("StopChangingLights1", 4000, false, "i", playerid);
	   return 1;
	}
	else if(!strcmp(option, "Round", true))
	{
	   GameTextForPlayer(playerid, "~y~CHANGING LIGHTS.....", 4000, 3);
       ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);

	   SetTimerEx("StopChangingLights2", 4000, false, "i", playerid);
	   return 1;
	}
	return 1;
}

forward StopAddingNeonRed(playerid);
public StopAddingNeonRed(playerid)
{
    new vehicleid = GetNearbyVehicle(playerid);
    
    SetVehicleNeon(vehicleid, 18647);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Red Neon Succesfully", GetRPName(playerid));
}

forward StopAddingNeonBlue(playerid);
public StopAddingNeonBlue(playerid)
{
    new vehicleid = GetNearbyVehicle(playerid);
    
    SetVehicleNeon(vehicleid, 18648);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Red Neon Succesfully", GetRPName(playerid));
}

forward StopAddingNeonGreen(playerid);
public StopAddingNeonGreen(playerid)
{
    new vehicleid = GetNearbyVehicle(playerid);
    
    SetVehicleNeon(vehicleid, 18649);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Red Neon Succesfully", GetRPName(playerid));
}

forward StopAddingNeonYellow(playerid);
public StopAddingNeonYellow(playerid)
{
    new vehicleid = GetNearbyVehicle(playerid);
    
    SetVehicleNeon(vehicleid, 18650);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Red Neon Succesfully", GetRPName(playerid));
}

forward StopAddingNeonPink(playerid);
public StopAddingNeonPink(playerid)
{
    new vehicleid = GetNearbyVehicle(playerid);
    
    SetVehicleNeon(vehicleid, 18651);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Red Neon Succesfully", GetRPName(playerid));
}

forward StopAddingNeonWhite(playerid);
public StopAddingNeonWhite(playerid)
{
    new vehicleid = GetNearbyVehicle(playerid);
    
    SetVehicleNeon(vehicleid, 18652);
    GameTextForPlayer(playerid, "~g~Success", 4000, 3);
    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s has added Red Neon Succesfully", GetRPName(playerid));
}

CMD:addneon(playerid, params[])
{
    new vehicleid = GetNearbyVehicle(playerid), option[12];
    if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
    {
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
    }
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be onfoot in order to use this command.");
	}
	if(sscanf(params, "s[12]", option))
	{
	   SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /addneon [neon]");
	   SendClientMessage(playerid, COLOR_GREY2, "List of colors: Red, Blue, Green, Yellow, Pink, White");
	   return 1;
	}
    if(PlayerInfo[playerid][pDuty] == 0)
    {
		 return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
    }
    if((vehicleid = GetNearbyVehicle(playerid)) == INVALID_VEHICLE_ID)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in range of any vehicle.");
	}
	if(!VehicleInfo[vehicleid][vOwnerID])
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle isn't owned by any particular person.");
	}
    if(!VehicleHasWindows(vehicleid))
    {
		return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle doesn't support neon.");
    }

    if(!strcmp(params, "red", true))
    {
	   GameTextForPlayer(playerid, "~y~ADDING RED NEON...", 4000, 3);
       ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
       SetTimerEx("StopAddingNeonRed", 4000, false, "i", playerid);
	}
    else if(!strcmp(params, "blue", true))
	{
       GameTextForPlayer(playerid, "~y~ADDING BLUE NEON...", 4000, 3);
       ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
       SetTimerEx("StopAddingNeonBlue", 4000, false, "i", playerid);
	}
	else if(!strcmp(params, "green", true))
    {
	   GameTextForPlayer(playerid, "~y~ADDING GREEN NEON...", 4000, 3);
       ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
       SetTimerEx("StopAddingNeonGreen", 4000, false, "i", playerid);
	}
	else if(!strcmp(params, "yellow", true))
	{
	   GameTextForPlayer(playerid, "~y~ADDING YELLOW NEON...", 4000, 3);
       ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
       SetTimerEx("StopAddingNeonYellow", 4000, false, "i", playerid);
    }
    else if(!strcmp(params, "pink", true))
	{
	   GameTextForPlayer(playerid, "~y~ADDING YELLOW NEON...", 4000, 3);
       ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
       SetTimerEx("StopAddingNeonPink", 4000, false, "i", playerid);
    }
	else if(!strcmp(params, "white", true))
	{
	   GameTextForPlayer(playerid, "~y~ADDING WHITE NEON...", 4000, 3);
       ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
       SetTimerEx("StopAddingNeonWhite", 4000, false, "i", playerid);
	}
	return 1;
}

forward StopRepairingVeh(playerid);
public StopRepairingVeh(playerid)
{
    new vehicleid = GetNearbyVehicle(playerid);
    
    PlayerInfo[playerid][pLastRepair] = gettime();

	RepairVehicle(vehicleid);
	SendClientMessage(playerid, COLOR_WHITE, "You have repaired the health and bodywork on this vehicle..");

	SetVehicleHealth(vehicleid, 1000.0);
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, ""SVRCLR"**{C2A2DA} %s repairs the vehicle.", GetRPName(playerid));
	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
}

CMD:repair(playerid, params[])
{
	new vehicleid = GetNearbyVehicle(playerid), Float:health;

	if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
	}
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You must be onfoot in order to use this command.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SendClientMessage(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(gettime() - PlayerInfo[playerid][pLastRepair] < 20)
	{
		return SendMessage(playerid, COLOR_SYNTAX, "You can only repair a vehicle every 20 seconds. Please wait %i more seconds.", 20 - (gettime() - PlayerInfo[playerid][pLastRepair]));
	}
	if(!vehicleid)
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
	}
	if(!VehicleHasEngine(vehicleid))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle has no engine which can be repaired.");
	}

	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SendClientMessage(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you repair this vehicle.");
	}

	GetVehicleHealth(vehicleid, health);

	if(health >= 1000.0)
	{
		SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle doesn't need to be repaired.");
	}
	if (IsNearTrunk(vehicleid, playerid, 4.0))  return SendClientMessage(playerid, COLOR_GREY, "You are not near at the hood! ");
	
	GameTextForPlayer(playerid, "~w~REPAIRING VEHICLE.....", 4000, 3);
    ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0);

	SetTimerEx("StopRepairingVeh", 4000, false, "i", playerid);
	return 1;
}

CMD:paintcar(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), paintjobid;

	if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	{
	    return SCM(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SCM(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SCM(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you repair this vehicle.");
	}
	if(sscanf(params, "i", paintjobid))
	{
	    return SCM(playerid, COLOR_SYNTAX, "Usage: /paintcar [paintjobid (-1 = none)]");
	}
	if(!vehicleid)
	{
	    return SCM(playerid, COLOR_SYNTAX, "You are not sitting inside any vehicle.");
	}
	if(!(-1 <= paintjobid <= 5))
	{
	    return SCM(playerid, COLOR_SYNTAX, "The paintjob specified must range between -1 and 5.");
	}
	if(paintjobid == -1) paintjobid = 3;

	if(VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
	{
		VehicleInfo[vehicleid][vPaintjob] = paintjobid;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET paintjob = %i WHERE id = %i", paintjobid, VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);
	}
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s uses their spraycan to spray their vehicle a different color.", GetRPName(playerid));
	ChangeVehiclePaintjob(vehicleid, paintjobid);
	PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);

	return 1;
}

CMD:unmod(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

	if((FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC))
	{
	    return SCM(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SCM(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SCM(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you repair this vehicle.");
	}
	if(!vehicleid)
	{
	    return SCM(playerid, COLOR_SYNTAX, "You are not sitting inside any vehicle.");
	}
	if(!IsVehicleOwner(playerid, vehicleid) && PlayerInfo[playerid][pVehicleKeys] != vehicleid)
	{
	    return SCM(playerid, COLOR_SYNTAX, "You can't use this command as this vehicle doesn't belong to you.");
	}
	if(isnull(params))
	{
	    return SCM(playerid, COLOR_SYNTAX, "Usage: /unmod [color | paintjob | mods | neon]");
	}

	if(!strcmp(params, "color", true))
	{
	    VehicleInfo[vehicleid][vColor1] = 0;
	    VehicleInfo[vehicleid][vColor2] = 0;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET color1 = 0, color2 = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ChangeVehicleColor(vehicleid, 0, 0);
	    SCM(playerid, COLOR_WHITE, "** Vehicle color has been set back to default.");
	}
	else if(!strcmp(params, "paintjob", true))
	{
	    VehicleInfo[vehicleid][vPaintjob] = -1;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET paintjob = -1 WHERE id = %i", VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

	    ChangeVehiclePaintjob(vehicleid, -1);
	    SCM(playerid, COLOR_WHITE, "** Vehicle paintjob has been set back to default.");
	}
	else if(!strcmp(params, "mods", true))
	{
	    for(new i = 0; i < 14; i ++)
	    {
	        if(VehicleInfo[vehicleid][vMods][i] >= 1000)
	        {
	            RemoveVehicleComponent(vehicleid, VehicleInfo[vehicleid][vMods][i]);
	        }
	    }

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET mod_1 = 0, mod_2 = 0, mod_3 = 0, mod_4 = 0, mod_5 = 0, mod_6 = 0, mod_7 = 0, mod_8 = 0, mod_9 = 0, mod_10 = 0, mod_11 = 0, mod_12 = 0, mod_13 = 0, mod_14 = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

	    SCM(playerid, COLOR_WHITE, "** All vehicle modifications have been removed.");
	}
	else if(!strcmp(params, "neon", true))
	{
	    if(!VehicleInfo[vehicleid][vNeon])
	    {
	        return SCM(playerid, COLOR_SYNTAX, "This vehicle has no neon which you can remove.");
		}

		if(VehicleInfo[vehicleid][vNeonEnabled])
		{
		    DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][0]);
		    DestroyDynamicObject(VehicleInfo[vehicleid][vObjects][1]);
		}

		VehicleInfo[vehicleid][vNeon] = 0;
		VehicleInfo[vehicleid][vNeonEnabled] = 0;
		VehicleInfo[vehicleid][vObjects][0] = INVALID_OBJECT_ID;
		VehicleInfo[vehicleid][vObjects][1] = INVALID_OBJECT_ID;

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET neon = 0, neonenabled = 0 WHERE id = %i", VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);

	    SCM(playerid, COLOR_WHITE, "** Neon has been removed from vehicle.");
	}

	return 1;
}

CMD:colorcar(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), color1, color2;
	if(PlayerInfo[playerid][pDuty] == 0)
	{
		return SCM(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SCM(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you repair this vehicle.");
	}
	if(sscanf(params, "ii", color1, color2))
	{
	    return SCM(playerid, COLOR_SYNTAX, "Usage: /colorcar [color1] [color2]");
	}
	if(!vehicleid)
	{
	    return SCM(playerid, COLOR_SYNTAX, "You are not sitting inside any vehicle.");
	}
	if(!(0 <= color1 <= 255) || !(0 <= color2 <= 255))
	{
	    return SCM(playerid, COLOR_SYNTAX, "The color specified must range between 0 and 255.");
	}

    if(VehicleInfo[vehicleid][vOwnerID] > 0 || VehicleInfo[vehicleid][vGang] >= 0)
	{
	    VehicleInfo[vehicleid][vColor1] = color1;
	    VehicleInfo[vehicleid][vColor2] = color2;

	    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET color1 = %i, color2 = %i WHERE id = %i", color1, color2, VehicleInfo[vehicleid][vID]);
	    mysql_tquery(connectionID, queryBuffer);
	}

	ChangeVehicleColor(vehicleid, color1, color2);
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s uses their spraycan to spray their vehicle a different color.", GetRPName(playerid));

	PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
	return 1;
}