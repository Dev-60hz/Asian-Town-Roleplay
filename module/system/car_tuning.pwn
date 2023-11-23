//============================================================================//
// CAR TUNING SYSTEM
//============================================================================//

stock IsABike(carid) {
    switch(GetVehicleModel(carid)) {
        case 509, 481, 510, 462, 448, 581, 522, 461, 521, 523, 463, 586, 468, 471: return 1;
    }
    return 0;
}

new const Float:TuneVehiclePosition[][] =
{
    {1802.603271, -1923.3022734, 13.949953},
    {1802.435791, -1927.863403, 13.949953},
    {1802.152099, -1932.732177, 13.949953},
    {1777.930297, -1932.176391, 13.949953},
    {1777.843629, -1927.638329, 13.949953},
    {1777.942138, -1922.979003, 13.949953}
}; 

IsPlayerinTuneVehicleArea(playerid)
{
    for(new i = 0; i < sizeof(TuneVehiclePosition); i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 4.0, TuneVehiclePosition[i][0], TuneVehiclePosition[i][1], TuneVehiclePosition[i][2]))
	    {
	    	return 1;
	    }
	}

	return 0;
}


new Text:gTuningBuy[4];
new PlayerText:TuningBuy[MAX_PLAYERS][3];

enum PaintjobInfi{
	vehID,
	pNumber,
	pPrice,
	pjName[ 12 ]
};
#define NUMBER_TYPE_PAINTJOB 	36
new const
	pjInfo[ NUMBER_TYPE_PAINTJOB ][ PaintjobInfi ] = {
	{ 483, 0, 15000, "Paintjob 1" },
	{ 534, 0, 15000, "Paintjob 1" },
	{ 534, 1, 15000, "Paintjob 2" },
	{ 534, 2, 15000, "Paintjob 3" },
	{ 535, 0, 15000, "Paintjob 1" },
	{ 535, 1, 15000, "Paintjob 2" },
	{ 535, 2, 15000, "Paintjob 3" },
	{ 536, 0, 15000, "Paintjob 1" },
	{ 536, 1, 15000, "Paintjob 2" },
	{ 536, 2, 15000, "Paintjob 3" },
	{ 558, 0, 15000, "Paintjob 1" },
	{ 558, 1, 15000, "Paintjob 2" },
	{ 558, 2, 15000, "Paintjob 3" },
	{ 559, 0, 15000, "Paintjob 1" },
	{ 559, 1, 15000, "Paintjob 2" },
	{ 559, 2, 15000, "Paintjob 3" },
	{ 560, 0, 15000, "Paintjob 1" },
	{ 560, 1, 15000, "Paintjob 2" },
	{ 560, 2, 15000, "Paintjob 3" },
	{ 561, 0, 15000, "Paintjob 1" },
	{ 561, 1, 15000, "Paintjob 2" },
	{ 561, 2, 15000, "Paintjob 3" },
	{ 562, 0, 15000, "Paintjob 1" },
	{ 562, 1, 15000, "Paintjob 2" },
	{ 562, 2, 15000, "Paintjob 3" },
	{ 565, 0, 15000, "Paintjob 1" },
	{ 565, 1, 15000, "Paintjob 2" },
	{ 565, 2, 15000, "Paintjob 3" },
	{ 567, 0, 15000, "Paintjob 1" },
	{ 567, 1, 15000, "Paintjob 2" },
	{ 567, 2, 15000, "Paintjob 3" },
	{ 575, 0, 15000, "Paintjob 1" },
	{ 575, 1, 15000, "Paintjob 2" },
	{ 576, 0, 15000, "Paintjob 1" },
	{ 576, 1, 15000, "Paintjob 2" },
	{ 576, 2, 15000, "Paintjob 3" }
};

enum ComponentsInfo {
	cID,
	cName[ 40 ],
	cPrice,
	cType
};

#define MAX_COMPONENTS			194

new const
	cInfo[ MAX_COMPONENTS ][ ComponentsInfo ] = {
	{ 1000, "Pro Spoiler", 10000, CARMODTYPE_SPOILER },
	{ 1001, "Win Spoiler", 12000, CARMODTYPE_SPOILER },
	{ 1002, "Drag Spoiler", 15000, CARMODTYPE_SPOILER },
	{ 1003, "Alpha Spoiler", 20000, CARMODTYPE_SPOILER },
	{ 1004, "Champ Scoop Hood", 5000, CARMODTYPE_HOOD },
	{ 1005, "Fury Scoop Hood", 10000, CARMODTYPE_HOOD },
	{ 1006, "Roof Scoop Roof", 15000, CARMODTYPE_ROOF },
	{ 1007, "Right Sideskirt", 15000, CARMODTYPE_SIDESKIRT },
	{ 1008, "5x Nitrous", 15000, CARMODTYPE_NITRO },
	{ 1009, "2x Nitrous", 10000, CARMODTYPE_NITRO },
	{ 1010, "10x Nitrous", 25000, CARMODTYPE_NITRO },
	{ 1011, "Race Scoop Hood", 15000, CARMODTYPE_HOOD },
	{ 1012, "Worx Scoop Hood", 15000, CARMODTYPE_HOOD },
	{ 1013, "Round Fog Lamp", 20000, CARMODTYPE_LAMPS },
	{ 1014, "Champ Spoiler", 5000, CARMODTYPE_SPOILER },
	{ 1015, "Race Spoiler", 10000, CARMODTYPE_SPOILER },
	{ 1016, "Worx Spoiler", 15000, CARMODTYPE_SPOILER },
	{ 1017, "Left Sideskirt", 20000, CARMODTYPE_SIDESKIRT },
	{ 1018, "Upswept Exhaust", 30000, CARMODTYPE_EXHAUST },
	{ 1019, "Twin Exhaust", 5500, CARMODTYPE_EXHAUST },
	{ 1020, "Large Exhaust", 5000, CARMODTYPE_EXHAUST },
	{ 1021, "Medium Exhaust", 5000, CARMODTYPE_EXHAUST },
	{ 1022, "Small Exhaust", 5000, CARMODTYPE_EXHAUST },
	{ 1023, "Fury Spoiler", 5000, CARMODTYPE_SPOILER },
	{ 1024, "Square Fog Lamp", 5000, CARMODTYPE_LAMPS },
	{ 1025, "Offroad Wheels", 5000, CARMODTYPE_WHEELS },
	{ 1026, "Right Alien Sideskirt", 12000, CARMODTYPE_SIDESKIRT },
	{ 1027, "Left Alien Sideskirt", 12000, CARMODTYPE_SIDESKIRT },
	{ 1028, "Alien Exhaust", 15000, CARMODTYPE_EXHAUST },
	{ 1029, "X-Flow Exhaust", 15000, CARMODTYPE_EXHAUST },
	{ 1030, "Left X-Flow Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1031, "Right X-Flow Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1032, "Alien Roof Vent", 15000, CARMODTYPE_ROOF },
	{ 1033, "X-Flow Roof Vent", 15000, CARMODTYPE_ROOF },
	{ 1034, "Alien Exhaust", 25000, CARMODTYPE_EXHAUST },
	{ 1035, "X-Flow Roof Vent", 17500, CARMODTYPE_ROOF },
	{ 1036, "Right Alien Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1037, "X-Flow Exhaust", 15000, CARMODTYPE_EXHAUST },
	{ 1038, "Alien Roof Vent", 15000, CARMODTYPE_ROOF },
	{ 1039, "Left X-Flow Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1040, "Left Alien Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1041, "Right X-Flow Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1042, "Right Chrome Sideskirt", 15000, CARMODTYPE_SIDESKIRT },
	{ 1043, "Slamin Exhaust", 20000, CARMODTYPE_EXHAUST },
	{ 1044, "Chrome Exhaust", 20000, CARMODTYPE_EXHAUST },
	{ 1045, "X-Flow Exhaust", 20000, CARMODTYPE_EXHAUST },
	{ 1046, "Alien Exhaust", 20000, CARMODTYPE_EXHAUST },
	{ 1047, "Right Alien Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1048, "Right X-Flow Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1049, "Alien Spoiler", 15000, CARMODTYPE_SPOILER },
	{ 1050, "X-Flow Spoiler", 15000, CARMODTYPE_SPOILER },
	{ 1051, "Left Alien Sideskirt", 5000, CARMODTYPE_SPOILER },
	{ 1052, "Left X-Flow Sideskirt", 5000, CARMODTYPE_SPOILER },
	{ 1053, "X-Flow Roof", 7500, CARMODTYPE_ROOF },
	{ 1054, "Alien Roof", 7500, CARMODTYPE_ROOF },
	{ 1055, "Alien Roof", 7500, CARMODTYPE_ROOF },
	{ 1056, "Right Alien Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1057, "Right X-Flow Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1058, "Alien Spoiler", 16000, CARMODTYPE_SPOILER },
	{ 1059, "X-Flow Exhaust", 5000, CARMODTYPE_EXHAUST },
	{ 1060, "X-Flow Spoiler", 15000, CARMODTYPE_SPOILER },
	{ 1061, "X-Flow Roof", 5000, CARMODTYPE_ROOF },
	{ 1062, "Left Alien Sideskirt", 5000, CARMODTYPE_SIDESKIRT },
	{ 1063, "Left X-Flow Sideskirt", 5000, CARMODTYPE_SIDESKIRT },
	{ 1064, "Alien Exhaust", 15000, CARMODTYPE_EXHAUST },
	{ 1065, "Alien Exhaust", 15000, CARMODTYPE_EXHAUST },
	{ 1066, "X-Flow Exhaust", 15000, CARMODTYPE_EXHAUST },
	{ 1067, "Alien Roof", 15000, CARMODTYPE_ROOF },
	{ 1068, "X-Flow Roof", 15000, CARMODTYPE_ROOF },
	{ 1069, "Right Alien Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1070, "Right X-Flow Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1071, "Left Alien Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1072, "Left X-Flow Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1073, "Shadow Wheels", 10000, CARMODTYPE_WHEELS },
	{ 1074, "Mega Wheels", 10000, CARMODTYPE_WHEELS },
	{ 1075, "Rimshine Wheels", 12000, CARMODTYPE_WHEELS },
	{ 1076, "Wires Wheels", 15000, CARMODTYPE_WHEELS },
	{ 1077, "Classic Wheels", 13500, CARMODTYPE_WHEELS },
	{ 1078, "Twist Wheels", 14500, CARMODTYPE_WHEELS },
	{ 1079, "Cutter Wheels", 13500, CARMODTYPE_WHEELS },
	{ 1080, "Switch Wheels", 30000, CARMODTYPE_WHEELS },
	{ 1081, "Grove Wheels", 10000, CARMODTYPE_WHEELS },
	{ 1082, "Import Wheels", 25000, CARMODTYPE_WHEELS },
	{ 1083, "Dollar Wheels", 25500, CARMODTYPE_WHEELS },
	{ 1084, "Trance Wheels", 25000, CARMODTYPE_WHEELS },
	{ 1085, "Atomic Wheels", 15000, CARMODTYPE_WHEELS },
	{ 1086, "Stereo Wheels", 20000, CARMODTYPE_STEREO },
	{ 1087, "Hydraulics", 50000, CARMODTYPE_HYDRAULICS },
	{ 1088, "Alien Roof", 15000, CARMODTYPE_ROOF },
	{ 1089, "X-Flow Exhaust", 10000, CARMODTYPE_EXHAUST },
	{ 1090, "Right Alien Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1091, "X-Flow Roof", 10000, CARMODTYPE_ROOF },
	{ 1092, "Alien Exhaust", 10000, CARMODTYPE_EXHAUST },
	{ 1093, "Right X-Flow Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1094, "Left Alien Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1095, "Right X-Flow Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1096, "Ahab Wheels", 10000, CARMODTYPE_WHEELS },
	{ 1097, "Virtual Wheels", 10000, CARMODTYPE_WHEELS },
	{ 1098, "Access Wheels", 12500, CARMODTYPE_WHEELS },
	{ 1099, "Left Chrome Sideskirt", 15000, CARMODTYPE_SIDESKIRT },
	{ 1100, "Chrome Grill", 20000, -1 }, // Bullbar
	{ 1101, "Left `Chrome Flames` Sideskirt", 20000, CARMODTYPE_SIDESKIRT },
	{ 1102, "Left `Chrome Strip` Sideskirt", 20000, CARMODTYPE_SIDESKIRT },
	{ 1103, "Covertible Roof", 20000, CARMODTYPE_ROOF },
	{ 1104, "Chrome Exhaust", 115000, CARMODTYPE_EXHAUST },
	{ 1105, "Slamin Exhaust", 115000, CARMODTYPE_EXHAUST },
	{ 1106, "Right `Chrome Arches`", 20000, CARMODTYPE_SIDESKIRT },
	{ 1107, "Left `Chrome Strip` Sideskirt", 20000, CARMODTYPE_SIDESKIRT },
	{ 1108, "Right `Chrome Strip` Sideskirt", 20000, CARMODTYPE_SIDESKIRT },
	{ 1109, "Chrome", 12000, -1 }, // Bullbar
	{ 1110, "Slamin", 12000, -1 }, // Bullbar
	{ 1111, "Little Sign?", 20000, -1 }, // sig
	{ 1112, "Little Sign?", 20000, -1 }, // sig
	{ 1113, "Chrome Exhaust", 15000, CARMODTYPE_EXHAUST },
	{ 1114, "Slamin Exhaust", 15000, CARMODTYPE_EXHAUST },
	{ 1115, "Chrome", 14000, -1 }, // Bullbar
	{ 1116, "Slamin", 14000, -1 }, // Bullbar
	{ 1117, "Chrome Front Bumper", 10000, CARMODTYPE_FRONT_BUMPER },
	{ 1118, "Right `Chrome Trim` Sideskirt", 10000, CARMODTYPE_SIDESKIRT },
	{ 1119, "Right `Wheelcovers` Sideskirt", 15000, CARMODTYPE_SIDESKIRT },
	{ 1120, "Left `Chrome Trim` Sideskirt", 20000, CARMODTYPE_SIDESKIRT },
	{ 1121, "Left `Wheelcovers` Sideskirt", 20000, CARMODTYPE_SIDESKIRT },
	{ 1122, "Right `Chrome Flames` Sideskirt", 22000, CARMODTYPE_SIDESKIRT },
	{ 1123, "Bullbar Chrome Bars", 22000, -1 }, // Bullbar
	{ 1124, "Left `Chrome Arches` Sideskirt", 22000, CARMODTYPE_SIDESKIRT },
	{ 1125, "Bullbar Chrome Lights", 22000, -1 }, // Bullbar
	{ 1126, "Chrome Exhaust", 15000, CARMODTYPE_EXHAUST },
	{ 1127, "Slamin Exhaust", 15000, CARMODTYPE_EXHAUST },
	{ 1128, "Vinyl Hardtop", 22000, CARMODTYPE_ROOF },
	{ 1129, "Chrome Exhaust", 22000, CARMODTYPE_EXHAUST },
	{ 1130, "Hardtop Roof", 12500, CARMODTYPE_ROOF },
	{ 1131, "Softtop Roof", 12500, CARMODTYPE_ROOF },
	{ 1132, "Slamin Exhaust", 55000, CARMODTYPE_EXHAUST },
	{ 1133, "Right `Chrome Strip` Sideskirt", 12500, CARMODTYPE_SIDESKIRT },
	{ 1134, "Right `Chrome Strip` Sideskirt", 12500, CARMODTYPE_SIDESKIRT },
	{ 1135, "Slamin Exhaust", 21000, CARMODTYPE_EXHAUST },
	{ 1136, "Chrome Exhaust", 21000, CARMODTYPE_EXHAUST },
	{ 1137, "Left `Chrome Strip` Sideskirt", 20000, CARMODTYPE_SIDESKIRT },
	{ 1138, "Alien Spoiler", 11500, CARMODTYPE_SPOILER },
	{ 1139, "X-Flow Spoiler", 11500, CARMODTYPE_SPOILER },
	{ 1140, "X-Flow Rear Bumper", 15000, CARMODTYPE_REAR_BUMPER },
	{ 1141, "Alien Rear Bumper", 15000, CARMODTYPE_REAR_BUMPER },
	{ 1142, "Left Oval Vents", 12000, CARMODTYPE_VENT_LEFT },
	{ 1143, "Right Oval Vents", 12000, CARMODTYPE_VENT_RIGHT },
	{ 1144, "Left Square Vents", 12000, CARMODTYPE_VENT_LEFT },
	{ 1145, "Right Square Vents", 12000, CARMODTYPE_VENT_RIGHT },
	{ 1146, "X-Flow Spoiler", 12000, CARMODTYPE_SPOILER },
	{ 1147, "Alien Spoiler", 12000, CARMODTYPE_SPOILER },
	{ 1148, "X-Flow Rear Bumper", 13000, CARMODTYPE_REAR_BUMPER },
	{ 1149, "Alien Rear Bumper", 13000, CARMODTYPE_REAR_BUMPER },
	{ 1150, "Alien Rear Bumper", 13000, CARMODTYPE_REAR_BUMPER },
	{ 1151, "X-Flow Rear Bumper", 13000, CARMODTYPE_REAR_BUMPER },
	{ 1152, "X-Flow Front Bumper", 13000, CARMODTYPE_FRONT_BUMPER },
	{ 1153, "Alien Front Bumper", 13000, CARMODTYPE_FRONT_BUMPER },
	{ 1154, "Alien Rear Bumper", 13000, CARMODTYPE_REAR_BUMPER },
	{ 1155, "Alien Front Bumper", 13000, CARMODTYPE_FRONT_BUMPER },
	{ 1156, "X-Flow Rear Bumper", 13000, CARMODTYPE_REAR_BUMPER },
	{ 1157, "X-Flow Front Bumper", 13000, CARMODTYPE_FRONT_BUMPER },
	{ 1158, "X-Flow Spoiler", 13000, CARMODTYPE_SPOILER },
	{ 1159, "Alien Rear Bumper", 13000, CARMODTYPE_REAR_BUMPER },
	{ 1160, "Alien Front Bumper", 13000, CARMODTYPE_FRONT_BUMPER },
	{ 1161, "X-Flow Rear Bumper", 13000, CARMODTYPE_REAR_BUMPER },
	{ 1162, "Alien Spoiler", 13000, CARMODTYPE_SPOILER },
	{ 1163, "X-Flow Spoiler", 13000, CARMODTYPE_SPOILER },
	{ 1164, "Alien Spoiler", 13000, CARMODTYPE_SPOILER },
	{ 1165, "X-Flow Front Bumper", 13000, CARMODTYPE_FRONT_BUMPER },
	{ 1166, "Alien Front Bumper", 13000, CARMODTYPE_FRONT_BUMPER },
	{ 1167, "X-Flow Rear Bumper", 13000, CARMODTYPE_REAR_BUMPER },
	{ 1168, "Alien Rear Bumper", 13000, CARMODTYPE_REAR_BUMPER },
	{ 1169, "Alien Front Bumper", 13000, CARMODTYPE_FRONT_BUMPER },
	{ 1170, "X-Flow Front Bumper", 13000, CARMODTYPE_FRONT_BUMPER },
	{ 1171, "Alien Front Bumper", 13008, CARMODTYPE_FRONT_BUMPER },
	{ 1172, "X-Flow Front Bumper", 13000, CARMODTYPE_FRONT_BUMPER },
	{ 1173, "X-Flow Front Bumper", 13000, CARMODTYPE_FRONT_BUMPER },
	{ 1174, "Chrome Front Bumper", 13000, CARMODTYPE_FRONT_BUMPER },
	{ 1175, "Slamin Front Bumper", 14000, CARMODTYPE_FRONT_BUMPER },
	{ 1176, "Chrome Rear Bumper", 14000, CARMODTYPE_REAR_BUMPER },
	{ 1177, "Slamin Rear Bumper", 14000, CARMODTYPE_REAR_BUMPER },
	{ 1178, "Slamin Rear Bumper", 14000, CARMODTYPE_REAR_BUMPER },
	{ 1179, "Chrome Front Bumper", 14000, CARMODTYPE_FRONT_BUMPER },
	{ 1180, "Chrome Rear Bumper", 14000, CARMODTYPE_REAR_BUMPER },
	{ 1181, "Slamin Front Bumper", 14000, CARMODTYPE_FRONT_BUMPER },
	{ 1182, "Chrome Front Bumper", 14000, CARMODTYPE_FRONT_BUMPER },
	{ 1183, "Slamin Rear Bumper", 14000, CARMODTYPE_REAR_BUMPER },
	{ 1184, "Chrome Rear Bumper", 14000, CARMODTYPE_REAR_BUMPER },
	{ 1185, "Slamin Front Bumper", 14000, CARMODTYPE_FRONT_BUMPER },
	{ 1186, "Slamin Rear Bumper", 14000, CARMODTYPE_REAR_BUMPER },
	{ 1187, "Chrome Rear Bumper", 14000, CARMODTYPE_REAR_BUMPER },
	{ 1188, "Slamin Front Bumper", 14000, CARMODTYPE_FRONT_BUMPER },
	{ 1189, "Chrome Front Bumper", 14000, CARMODTYPE_FRONT_BUMPER },
	{ 1190, "Slamin Front Bumper", 14000, CARMODTYPE_FRONT_BUMPER },
	{ 1191, "Chrome Front Bumper", 14000, CARMODTYPE_FRONT_BUMPER },
	{ 1192, "Chrome Rear Bumper", 14000, CARMODTYPE_REAR_BUMPER },
	{ 1193, "Slamin Rear Bumper", 14000, CARMODTYPE_REAR_BUMPER }
};

enum tpi {
	tuneID,
	tType,
	bool:tPaintjob,
	PJColor[ 2 ],
	PJPaintjob
};
new TPInfo[ MAX_PLAYERS ][ tpi ];

stock TuningTDControl( playerid, bool:show ) {
	if( show == true ) {
        for( new idx = 0; idx <= 2; idx ++ ) {
			PlayerTextDrawShow( playerid, TuningBuy[ playerid ][ idx ] );
		}	
        for( new i = 0; i <= 3; i ++ ) {
			TextDrawShowForPlayer( playerid, gTuningBuy [ i ] );
		}

	}
	else if( show == false ) {
        for( new idx = 0; idx <= 2; idx ++ ) {
			PlayerTextDrawHide( playerid, TuningBuy[ playerid ][ idx ] );
		}		
		for( new i = 0; i <= 3; i ++ ) {
			TextDrawHideForPlayer( playerid, gTuningBuy [ i ] );
		}
	}
}
//==============================================================================
ResetTuningInfo( playerid ) {
	TPInfo[ playerid ][ tuneID ] = -1;
	TPInfo[ playerid ][ tType ] = -1;
	TPInfo[ playerid ][ tPaintjob ] = false;
	TPInfo[ playerid ][ PJColor ] = -1;
	TPInfo[ playerid ][ PJColor ] = -1;
	TPInfo[ playerid ][ PJPaintjob ] = 3;
}

public OnGameModeInit()
{

	// Tuning
	gTuningBuy[0] = TextDrawCreate(231.000000, 384.000000, "<<<");
	TextDrawFont(gTuningBuy[0], 1);
	TextDrawLetterSize(gTuningBuy[0], 0.600000, 2.000000);
	TextDrawTextSize(gTuningBuy[0], 400.000000, 47.000000);
	TextDrawSetOutline(gTuningBuy[0], 1);
	TextDrawSetShadow(gTuningBuy[0], 0);
	TextDrawAlignment(gTuningBuy[0], 2);
	TextDrawColor(gTuningBuy[0], -1);
	TextDrawBackgroundColor(gTuningBuy[0], 255);
	TextDrawBoxColor(gTuningBuy[0], 50);
	TextDrawUseBox(gTuningBuy[0], 0);
	TextDrawSetProportional(gTuningBuy[0], 1);
	TextDrawSetSelectable(gTuningBuy[0], 1);

	gTuningBuy[1] = TextDrawCreate(418.000000, 384.000000, ">>>");
	TextDrawFont(gTuningBuy[1], 1);
	TextDrawLetterSize(gTuningBuy[1], 0.600000, 2.000000);
	TextDrawTextSize(gTuningBuy[1], 400.000000, 47.000000);
	TextDrawSetOutline(gTuningBuy[1], 1);
	TextDrawSetShadow(gTuningBuy[1], 0);
	TextDrawAlignment(gTuningBuy[1], 2);
	TextDrawColor(gTuningBuy[1], -1);
	TextDrawBackgroundColor(gTuningBuy[1], 255);
	TextDrawBoxColor(gTuningBuy[1], 50);
	TextDrawUseBox(gTuningBuy[1], 0);
	TextDrawSetProportional(gTuningBuy[1], 1);
	TextDrawSetSelectable(gTuningBuy[1], 1);

	gTuningBuy[2] = TextDrawCreate(324.000000, 384.000000, "PURCHASE");
	TextDrawFont(gTuningBuy[2], 1);
	TextDrawLetterSize(gTuningBuy[2], 0.600000, 2.000000);
	TextDrawTextSize(gTuningBuy[2], 400.000000, 107.000000);
	TextDrawSetOutline(gTuningBuy[2], 1);
	TextDrawSetShadow(gTuningBuy[2], 0);
	TextDrawAlignment(gTuningBuy[2], 2);
	TextDrawColor(gTuningBuy[2], -1);
	TextDrawBackgroundColor(gTuningBuy[2], 255);
	TextDrawBoxColor(gTuningBuy[2], 50);
	TextDrawUseBox(gTuningBuy[2], 0);
	TextDrawSetProportional(gTuningBuy[2], 1);
	TextDrawSetSelectable(gTuningBuy[2], 1);

	gTuningBuy[3] = TextDrawCreate(431.000000, 287.000000, "X");
	TextDrawFont(gTuningBuy[3], 1);
	TextDrawLetterSize(gTuningBuy[3], 0.600000, 2.000000);
	TextDrawTextSize(gTuningBuy[3], 400.000000, 22.000000);
	TextDrawSetOutline(gTuningBuy[3], 1);
	TextDrawSetShadow(gTuningBuy[3], 0);
	TextDrawAlignment(gTuningBuy[3], 2);
	TextDrawColor(gTuningBuy[3], -16776961);
	TextDrawBackgroundColor(gTuningBuy[3], 255);
	TextDrawBoxColor(gTuningBuy[3], 50);
	TextDrawUseBox(gTuningBuy[3], 0);
	TextDrawSetProportional(gTuningBuy[3], 1);
	TextDrawSetSelectable(gTuningBuy[3], 1);

	#if defined TUNE_OnGameModeInit
		return TUNE_OnGameModeInit();
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit TUNE_OnGameModeInit
#if defined TUNE_OnGameModeInit
	forward TUNE_OnGameModeInit();
#endif

public OnPlayerConnect(playerid)
{
	// Tuning
	TuningBuy[playerid][0] = CreatePlayerTextDraw(playerid, 323.000000, 335.000000, "_");
	PlayerTextDrawFont(playerid, TuningBuy[playerid][0], 2);
	PlayerTextDrawLetterSize(playerid, TuningBuy[playerid][0], 0.395832, 1.799999);
	PlayerTextDrawTextSize(playerid, TuningBuy[playerid][0], 397.500000, 198.000000);
	PlayerTextDrawSetOutline(playerid, TuningBuy[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, TuningBuy[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, TuningBuy[playerid][0], 2);
	PlayerTextDrawColor(playerid, TuningBuy[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningBuy[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, TuningBuy[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, TuningBuy[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, TuningBuy[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, TuningBuy[playerid][0], 0);

	TuningBuy[playerid][1] = CreatePlayerTextDraw(playerid, 323.000000, 356.000000, "X-FLOW EXHAUST");
	PlayerTextDrawFont(playerid, TuningBuy[playerid][1], 2);
	PlayerTextDrawLetterSize(playerid, TuningBuy[playerid][1], 0.395832, 1.799999);
	PlayerTextDrawTextSize(playerid, TuningBuy[playerid][1], 397.500000, 230.000000);
	PlayerTextDrawSetOutline(playerid, TuningBuy[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, TuningBuy[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, TuningBuy[playerid][1], 2);
	PlayerTextDrawColor(playerid, TuningBuy[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningBuy[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, TuningBuy[playerid][1], COLOR_RED);
	PlayerTextDrawUseBox(playerid, TuningBuy[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, TuningBuy[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, TuningBuy[playerid][1], 0);

	TuningBuy[playerid][2] = CreatePlayerTextDraw(playerid, 323.000000, 315.000000, "Price: $0");
	PlayerTextDrawFont(playerid, TuningBuy[playerid][2], 2);
	PlayerTextDrawLetterSize(playerid, TuningBuy[playerid][2], 0.395832, 1.799998);
	PlayerTextDrawTextSize(playerid, TuningBuy[playerid][2], 397.500000, 230.000000);
	PlayerTextDrawSetOutline(playerid, TuningBuy[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, TuningBuy[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, TuningBuy[playerid][2], 2);
	PlayerTextDrawColor(playerid, TuningBuy[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningBuy[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, TuningBuy[playerid][2], -294256460);
	PlayerTextDrawUseBox(playerid, TuningBuy[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, TuningBuy[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, TuningBuy[playerid][2], 0);
	#if defined TUNE_OnPlayerConnect
		return TUNE_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect TUNE_OnPlayerConnect
#if defined TUNE_OnPlayerConnect
	forward TUNE_OnPlayerConnect(playerid);
#endif

CMD:tune(playerid, params[])
{
	new targetid;
    if(!IsPlayerinTuneVehicleArea(playerid))
	{
	    return SCM(playerid, COLOR_SYNTAX, "You are not in range of the tune area.");
	}
    if(FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC)
    {
        return SCM(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
	}
	if(PlayerInfo[playerid][pDuty] == 0)
    {
        return SCM(playerid, COLOR_GREY2, "You can't use this command while off-duty.");
    }
    if(sscanf(params, "ui", targetid))
    {
        return SCM(playerid, COLOR_LIGHTBLUE, "Usage: "WHITE"/tune [playerid]");
    }

	new vehicleid = GetPlayerVehicleID(targetid);

	if(IsABike(vehicleid) || IsABoat(vehicleid))
		return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle is not supported to be tuned.");

	if(VehicleInfo[vehicleid][vOwnerID] <= 0) return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot tune a non-player vehicle.");

	ShowPlayerDialog( targetid, DIALOG_TUNING, DIALOG_STYLE_LIST, "Car Tuning", "Paintjobs\nColors\nExhausts\nFront Bumper\nRear Bumper\nRoof\nSpoilers\nSide Skirts\nWheels\nCar Stereo\nHydraulics\nNitro", "Okay", "Cancel" );
	
	SetPVarInt(targetid, "isTuning", 1);
	return 1;
}

CMD:upgradevehicle(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), option[8], param[32];

	if(!IsPlayerinTuneVehicleArea(playerid))
	{
	    return SCM(playerid, COLOR_SYNTAX, "You are not in range of the tune area.");
	}
    if(FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC)
    {
        return SCM(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SCM(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you upgrade this vehicle.");
	}
	if(!vehicleid)
	{
		return SCM(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
	}
	if(sscanf(params, "s[8]S()[32]", option, param))
	{
	    //return SCM(playerid, COLOR_LIGHTBLUE, "Usage: "WHITE"/upgradevehicle [stash | plate | neon | elock]");
	    return SCM(playerid, COLOR_LIGHTBLUE, "Usage: "WHITE"/upgradevehicle [stash | elock]");
	}
	if(!strcmp(option, "stash", true))
	{
	    if(isnull(param) || strcmp(param, "confirm", true) != 0)
	    {
	        SCM(playerid, COLOR_LIGHTBLUE, "Usage: "WHITE"/selfupgradevehicle [stash] [confirm]");
	        SM(playerid, COLOR_WHITE, "Your vehicle's stash level is at %i/3. Upgrading your stash will cost you $15,000.", VehicleInfo[vehicleid][vTrunk]);
	        return 1;
		}
		if(VehicleInfo[vehicleid][vTrunk] >= 3)
		{
		    return SCM(playerid, COLOR_SYNTAX, "This vehicle's stash is already at its maximum level.");
		}
		if(PlayerInfo[playerid][pCash] < 15000)
		{
		    return SCM(playerid, COLOR_SYNTAX, "You don't have enough money to upgrade your trunk.");
		}
		VehicleInfo[vehicleid][vTrunk]++;

		GivePlayerCash(playerid, -15000);
		AddToTaxVault(15000);
		GameTextForPlayer(playerid, "~r~-$15,000", 5000, 1);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET trunk = %i WHERE id = %i", VehicleInfo[vehicleid][vTrunk], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_YELLOW, "You have paid $15,000 for stash level %i/3. '/vstash balance' to see your new capacities.", VehicleInfo[vehicleid][vTrunk]);
	}
	/*else if(!strcmp(option, "neon", true))
	{
	    if(isnull(param))
	    {
	        SCM(playerid, COLOR_LIGHTBLUE, "Usage: "WHITE"/selfupgradevehicle [neon] [color] ($10,000)");
			SCM(playerid, COLOR_ORANGE, "Options: "WHITE"Red, Blue, Green, Yellow, Pink, White");
			return 1;
	    }
	    if(PlayerInfo[playerid][pCash] < 10000)
	    {
	        return SCM(playerid, COLOR_SYNTAX, "You need at least $10,000 to upgrade your neon.");
		}
		if(!VehicleHasWindows(vehicleid))
		{
		    return SCM(playerid, COLOR_SYNTAX, "This vehicle doesn't support neon.");
		}
		if(!strcmp(param, "red", true))
		{
		    SetVehicleNeon(vehicleid, 18647);
		    GivePlayerCash(playerid, -10000);
		    AddToTaxVault(10000);
			GameTextForPlayer(playerid, "~r~-$10,000", 5000, 1);

			SCM(playerid, COLOR_YELLOW, "You have paid $10,000 for red neon. You can use /neon to toggle your neon.");
		}
		else if(!strcmp(param, "blue", true))
		{
		    SetVehicleNeon(vehicleid, 18648);
		    GivePlayerCash(playerid, -10000);
		    AddToTaxVault(10000);
			GameTextForPlayer(playerid, "~r~-$10,000", 5000, 1);

			SCM(playerid, COLOR_YELLOW, "You have paid $10,000 for blue neon. You can use /neon to toggle your neon.");
		}
		else if(!strcmp(param, "green", true))
		{
		    SetVehicleNeon(vehicleid, 18649);
		    GivePlayerCash(playerid, -10000);
		    AddToTaxVault(10000);
			GameTextForPlayer(playerid, "~r~-$10,000", 5000, 1);

			SCM(playerid, COLOR_YELLOW, "You have paid $10,000 for green neon. You can use /neon to toggle your neon.");
		}
		else if(!strcmp(param, "yellow", true))
		{
		    SetVehicleNeon(vehicleid, 18650);
		    GivePlayerCash(playerid, -10000);
			GameTextForPlayer(playerid, "~r~-$10,000", 5000, 1);

			SCM(playerid, COLOR_YELLOW, "You have paid $10,000 for yellow neon. You can use /neon to toggle your neon.");
		}
		else if(!strcmp(param, "pink", true))
		{
		    SetVehicleNeon(vehicleid, 18651);
		    GivePlayerCash(playerid, -10000);
		    AddToTaxVault(10000);
			GameTextForPlayer(playerid, "~r~-$10,000", 5000, 1);

			SCM(playerid, COLOR_YELLOW, "You have paid $3000 for pink neon. You can use /neon to toggle your neon.");
		}
		else if(!strcmp(param, "white", true))
		{
		    SetVehicleNeon(vehicleid, 18652);
		    GivePlayerCash(playerid, -10000);
		    AddToTaxVault(10000);
			GameTextForPlayer(playerid, "~r~-$10,000", 5000, 1);

			SCM(playerid, COLOR_YELLOW, "You have paid $10,000 for white neon. You can use /neon to toggle your neon.");
		}
	}
	else if(!strcmp(option, "plate", true))
	{
	    if(isnull(param))
	    {
	        return SCM(playerid, COLOR_LIGHTBLUE, "Usage: "WHITE"/selfupgradevehicle [plate] [text] (costs $30,000)");
	    }
	    if(!VehicleHasEngine(vehicleid))
	    {
	        return SCM(playerid, COLOR_SYNTAX, "This vehicle has no license plate. Therefore you can't buy this upgrade.");
	    }
	    strcpy(VehicleInfo[vehicleid][vPlate], param, 32);

		SetVehicleNumberPlate(vehicleid, param);
	    ResyncVehicle(vehicleid);
	    ReloadVehicle(vehicleid);

	    GivePlayerCash(playerid, -30000);
	    AddToTaxVault(30000);
		GameTextForPlayer(playerid, "~r~-$30,000", 5000, 1);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET plate = '%e' WHERE id = %i", param, VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_YELLOW, "You have paid $30,000 for license plate '%s'. Changes will take effect once vehicle is parked.", param);
	}*/
	else if(!strcmp(option, "elock", true))
	{
		if(isnull(param) || strcmp(param, "confirm", true) != 0)
	    {
	        return SCM(playerid, COLOR_LIGHTBLUE, "Usage: "WHITE"/upgradevehicle [elock] [confirm] (costs $50,000)");
		}
	    if(!VehicleHasEngine(vehicleid))
	    {
	        return SCM(playerid, COLOR_GREY, "This vehicle doesn't have lock system. Therefore you can't buy this upgrade.");
	    }
		VehicleInfo[vehicleid][vDLock] = 1;
	    GivePlayerCash(playerid, -50000);
	    AddToTaxVault(50000);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET electriclock = 1 WHERE id = %i", VehicleInfo[vehicleid][vDLock]);
		mysql_tquery(connectionID, queryBuffer);

		SCM(playerid, COLOR_YELLOW, "You have paid $50,000 for electric lock.");
	}
	return 1;
}

/*CMD:selftune(playerid, params[])
{
	new targetid;
    if(!IsPlayerInTuneArea(playerid))
    {
        return SCM(playerid, COLOR_SYNTAX, "You're not near at the tunning place.");
    }
    if(sscanf(params, "ui", targetid))
    {
        return SCM(playerid, COLOR_LIGHTBLUE, "Usage: "WHITE"/selftune [playerid]");
    }

	new vehicleid = GetPlayerVehicleID(targetid);

	if(IsABike(vehicleid) || IsABoat(vehicleid))
		return SendClientMessage(playerid, COLOR_SYNTAX, "This vehicle is not supported to be tuned.");

	if(VehicleInfo[vehicleid][vOwnerID] <= 0) return SendClientMessage(playerid, COLOR_SYNTAX, "You cannot tune a non-player vehicle.");

	ShowPlayerDialog( targetid, DIALOG_TUNING, DIALOG_STYLE_LIST, "Car Tuning", "Paintjobs\nColors\nExhausts\nFront Bumper\nRear Bumper\nRoof\nSpoilers\nSide Skirts\nWheels\nCar Stereo\nHydraulics\nNitro", "Okay", "Cancel" );
	
	SetPVarInt(targetid, "isTuning", 1);
	return 1;
}

CMD:selfupgradevehicle(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), option[8], param[32];

	if(!IsPlayerInTuneArea(playerid))
	{
	    return SCM(playerid, COLOR_SYNTAX, "You are not in range of the tunning place.");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SCM(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you upgrade this vehicle.");
	}
	if(!vehicleid)
	{
		return SCM(playerid, COLOR_SYNTAX, "You are not inside of any vehicle.");
	}
	if(sscanf(params, "s[8]S()[32]", option, param))
	{
	    return SCM(playerid, COLOR_LIGHTBLUE, "Usage: "WHITE"/selfupgradevehicle [stash | plate | neon]");
	}

	if(!strcmp(option, "stash", true))
	{
	    if(isnull(param) || strcmp(param, "confirm", true) != 0)
	    {
	        SCM(playerid, COLOR_LIGHTBLUE, "Usage: "WHITE"/selfupgradevehicle [stash] [confirm]");
	        SM(playerid, COLOR_WHITE, "Your vehicle's stash level is at %i/3. Upgrading your stash will cost you $15,000.", VehicleInfo[vehicleid][vTrunk]);
	        return 1;
		}
		if(VehicleInfo[vehicleid][vTrunk] >= 3)
		{
		    return SCM(playerid, COLOR_SYNTAX, "This vehicle's stash is already at its maximum level.");
		}
		if(PlayerInfo[playerid][pCash] < 15000)
		{
		    return SCM(playerid, COLOR_SYNTAX, "You don't have enough money to upgrade your trunk.");
		}

		VehicleInfo[vehicleid][vTrunk]++;

		GivePlayerCash(playerid, -15000);
		GameTextForPlayer(playerid, "~r~-$15,000", 5000, 1);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET trunk = %i WHERE id = %i", VehicleInfo[vehicleid][vTrunk], VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_YELLOW, "You have paid $15,000 for stash level %i/3. '/vstash balance' to see your new capacities.", VehicleInfo[vehicleid][vTrunk]);
		//Log_Write("log_property", "%s (uid: %i) upgraded the stash of their %s (id: %i) to level %i/3.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID], VehicleInfo[vehicleid][vTrunk]);
	}
	else if(!strcmp(option, "neon", true))
	{
	    if(isnull(param))
	    {
	        SCM(playerid, COLOR_LIGHTBLUE, "Usage: "WHITE"/selfupgradevehicle [neon] [color] ($10,000)");
			SCM(playerid, COLOR_ORANGE, "Options: "WHITE"Red, Blue, Green, Yellow, Pink, White");
			return 1;
	    }
	    if(PlayerInfo[playerid][pCash] < 10000)
	    {
	        return SCM(playerid, COLOR_SYNTAX, "You need at least $10,000 to upgrade your neon.");
		}
		if(!VehicleHasWindows(vehicleid))
		{
		    return SCM(playerid, COLOR_SYNTAX, "This vehicle doesn't support neon.");
		}

		if(!strcmp(param, "red", true))
		{
		    SetVehicleNeon(vehicleid, 18647);
		    GivePlayerCash(playerid, -10000);
			GameTextForPlayer(playerid, "~r~-$10,000", 5000, 1);

			SCM(playerid, COLOR_YELLOW, "You have paid $10,000 for red neon. You can use /neon to toggle your neon.");
			//Log_Write("log_property", "%s (uid: %i) purchased red neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
		else if(!strcmp(param, "blue", true))
		{
		    SetVehicleNeon(vehicleid, 18648);
		    GivePlayerCash(playerid, -10000);
			GameTextForPlayer(playerid, "~r~-$10,000", 5000, 1);

			SCM(playerid, COLOR_YELLOW, "You have paid $10,000 for blue neon. You can use /neon to toggle your neon.");
			//Log_Write("log_property", "%s (uid: %i) purchased blue neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
		else if(!strcmp(param, "green", true))
		{
		    SetVehicleNeon(vehicleid, 18649);
		    GivePlayerCash(playerid, -10000);
			GameTextForPlayer(playerid, "~r~-$10,000", 5000, 1);

			SCM(playerid, COLOR_YELLOW, "You have paid $10,000 for green neon. You can use /neon to toggle your neon.");
			//Log_Write("log_property", "%s (uid: %i) purchased green neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
		else if(!strcmp(param, "yellow", true))
		{
		    SetVehicleNeon(vehicleid, 18650);
		    GivePlayerCash(playerid, -10000);
			GameTextForPlayer(playerid, "~r~-$10,000", 5000, 1);

			SCM(playerid, COLOR_YELLOW, "You have paid $10,000 for yellow neon. You can use /neon to toggle your neon.");
			//Log_Write("log_property", "%s (uid: %i) purchased yellow neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
		else if(!strcmp(param, "pink", true))
		{
		    SetVehicleNeon(vehicleid, 18651);
		    GivePlayerCash(playerid, -10000);
			GameTextForPlayer(playerid, "~r~-$10,000", 5000, 1);

			SCM(playerid, COLOR_YELLOW, "You have paid $3000 for pink neon. You can use /neon to toggle your neon.");
			//Log_Write("log_property", "%s (uid: %i) purchased pink neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
		else if(!strcmp(param, "white", true))
		{
		    SetVehicleNeon(vehicleid, 18652);
		    GivePlayerCash(playerid, -10000);
			GameTextForPlayer(playerid, "~r~-$10,000", 5000, 1);

			SCM(playerid, COLOR_YELLOW, "You have paid $10,000 for white neon. You can use /neon to toggle your neon.");
			//Log_Write("log_property", "%s (uid: %i) purchased white neon for their %s (id: %i)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID]);
		}
	}
	else if(!strcmp(option, "plate", true))
	{
	    if(isnull(param))
	    {
	        return SCM(playerid, COLOR_LIGHTBLUE, "Usage: "WHITE"/selfupgradevehicle [plate] [text] (costs $30,000)");
	    }
	    if(!VehicleHasEngine(vehicleid))
	    {
	        return SCM(playerid, COLOR_SYNTAX, "This vehicle has no license plate. Therefore you can't buy this upgrade.");
	    }

	    strcpy(VehicleInfo[vehicleid][vPlate], param, 32);

		SetVehicleNumberPlate(vehicleid, param);
	    ResyncVehicle(vehicleid);

	    GivePlayerCash(playerid, -30000);
		GameTextForPlayer(playerid, "~r~-$30,000", 5000, 1);

		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET plate = '%e' WHERE id = %i", param, VehicleInfo[vehicleid][vID]);
		mysql_tquery(connectionID, queryBuffer);

		SM(playerid, COLOR_YELLOW, "You have paid $30,000 for license plate '%s'. Changes will take effect once vehicle is parked.", param);
		//Log_Write("log_property", "%s (uid: %i) paid $30,000 to set the license plate of their %s (id: %i) to %s.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetVehicleName(vehicleid), VehicleInfo[vehicleid][vID], param);
	}
	return 1;
}*/

CMD:unmod(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if(!IsPlayerinTuneVehicleArea(playerid))
	{
	    return SCM(playerid, COLOR_SYNTAX, "You are not in range of the tune area.");
	}
    if(FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC)
    {
        return SCM(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
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
	    return SCM(playerid, COLOR_LIGHTBLUE, "Usage: "WHITE"/unmod [color | paintjob | mods | neon]");
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
	if(!IsPlayerinTuneVehicleArea(playerid))
	{
	    return SCM(playerid, COLOR_SYNTAX, "You are not in range of the tune area.");
	}
    if(FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC)
    {
        return SCM(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SCM(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you repair this vehicle.");
	}
	if(sscanf(params, "ii", color1, color2))
	{
	    return SCM(playerid, COLOR_LIGHTBLUE, "Usage: "WHITE"/colorcar [color1] [color2]");
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
	SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s uses their spraycan to spray their vehicle a different color.", GetRPName(playerid));

	PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
	return 1;
}

CMD:paintcar(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), paintjobid;

	if(!IsPlayerinTuneVehicleArea(playerid))
	{
	    return SCM(playerid, COLOR_SYNTAX, "You are not in range of the tune area.");
	}
    if(FactionInfo[PlayerInfo[playerid][pFaction]][fType] != FACTION_MECHANIC)
    {
        return SCM(playerid, COLOR_SYNTAX, "You must be a mechanic to use this command.");
	}
	if(GetVehicleParams(vehicleid, VEHICLE_ENGINE))
	{
		return SCM(playerid, COLOR_SYNTAX, "The engine needs to be shut down before you repair this vehicle.");
	}
	if(sscanf(params, "i", paintjobid))
	{
	    return SCM(playerid, COLOR_LIGHTBLUE, "Usage: "WHITE"/paintcar [paintjobid (-1 = none)]");
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
	SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s uses their spraycan to spray their vehicle a different color.", GetRPName(playerid));
	ChangeVehiclePaintjob(vehicleid, paintjobid);
	PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);

	return 1;
}

public OnPlayerPrepareDeath(playerid, animlib[32], animname[32], &anim_lock, &respawn_time)
{
	if(GetPVarInt(playerid, "isTuning") > 0)
	{
		new vehicleid = GetPlayerVehicleID( playerid );
	
		TuningTDControl(playerid, false);
		DeletePVar(playerid, "isTuning");
		TogglePlayerControllable(playerid, true);
		CancelSelectTextDraw(playerid);
		SetCameraBehindPlayer(playerid);
		ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "Hide", "Hide", "Hide", "");
		SetCameraBehindPlayer(playerid);
		
		if(vehicleid > 0)
		{
			if( TPInfo[ playerid ][ tPaintjob ] == false ) {

				RemoveVehicleComponent( vehicleid, cInfo[ TPInfo[ playerid ][ tuneID ] ][ cID ] );

				if(VehicleInfo[vehicleid][vOwnerID] >= 1)
				{
					if(VehicleInfo[vehicleid][vPaintjob] != -1)
					{
						ChangeVehiclePaintjob(vehicleid, VehicleInfo[vehicleid][vPaintjob]);
					}
					ChangeVehicleColor(vehicleid, VehicleInfo[vehicleid][vColor1], VehicleInfo[vehicleid][vColor2]);						
				
					for(new i = 0; i < 14; i ++)
					{
						if(VehicleInfo[vehicleid][vMods][i] >= 1000)
						{
							AddVehicleComponent(vehicleid, VehicleInfo[vehicleid][vMods][i]);
						}
					}
				}
			}
			else if( TPInfo[ playerid ][ tPaintjob ] == true ) {

				ChangeVehiclePaintjob( vehicleid, TPInfo[ playerid ][ PJPaintjob ] );
				ChangeVehicleColor( vehicleid, TPInfo[ playerid ][ PJColor ][ 0 ], TPInfo[ playerid ][ PJColor ][ 1 ] );
			}
		}
		
		ResetTuningInfo(playerid);
	}

	#if defined TUNE_OnPlayerPrepareDeath
		return TUNE_OnPlayerPrepareDeath(playerid, animlib, animname, anim_lock, respawn_time);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerPrepareDeath
	#undef OnPlayerPrepareDeath
#else
	#define _ALS_OnPlayerPrepareDeath
#endif
#define OnPlayerPrepareDeath TUNE_OnPlayerPrepareDeath
#if defined TUNE_OnPlayerPrepareDeath
	forward TUNE_OnPlayerPrepareDeath(playerid, animlib[32], animname[32], &anim_lock, &respawn_time);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{	
	if(dialogid == DIALOG_TUNING)
	{
		if( response ) {
			if( !IsPlayerInAnyVehicle( playerid ) ) return SendClientMessage(playerid, COLOR_SYNTAX, "You must be in the vehicle." );
			if( GetPlayerState( playerid ) != PLAYER_STATE_DRIVER ) return SendClientMessage(playerid, COLOR_SYNTAX, "You must be in the driver's seat." );
			new vehicleid = GetPlayerVehicleID( playerid ), Float:Pos[ 6 ];

			TPInfo[ playerid ][ tuneID ] = -1;

			new string[92];
			switch( listitem ) {
				case 0: {
					
					for( new i = 0; i < NUMBER_TYPE_PAINTJOB; i++ ) {
						if( pjInfo[ i ][ vehID ] == GetVehicleModel( vehicleid ) ) {
							TPInfo[ playerid ][ tuneID ] = i;
							break;
						}
					}

					if( TPInfo[ playerid ][ tuneID ] == -1 ) return SendClientMessage(playerid, COLOR_SYNTAX, "No compatible paintjobs for your vehicle model." );
					
					new pid = TPInfo[ playerid ][ tuneID ];
					TPInfo[ playerid ][ tPaintjob ] = true;
					
					GetVehicleColor( vehicleid, TPInfo[ playerid ][ PJColor ][ 0 ], TPInfo[ playerid ][ PJColor ][ 1 ] );
					TPInfo[ playerid ][ PJPaintjob ] = GetVehiclePaintjob( vehicleid );
					
					TogglePlayerControllable( playerid, false );
					TuningTDControl( playerid, true );

					ChangeVehicleColor( vehicleid, 1, 1 );
					ChangeVehiclePaintjob( vehicleid, pjInfo[ pid ][ pNumber ] );

					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 0 ], "Paintjob" );
					format( string, sizeof( string ), "%s", pjInfo[ pid ][ pjName ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 1 ], string );
					format( string, sizeof( string ), "Price: $%d", pjInfo[ pid ][ pPrice ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 2 ], string );
					
					GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 2, 2, 2 );
					SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

					GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
					SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
					
					SelectTextDraw( playerid, COLOR_ORANGE );
				}
				case 1: {
					ShowPlayerDialog( playerid, DIALOG_TUNING_2, DIALOG_STYLE_INPUT, "Select your Color", "Input Color1 ID and Color2 ID.\nExample: 0 1", "Okay", "Cancel" );
				}
				case 2: {

					for( new i = 0; i < MAX_COMPONENTS; i++ ) {
						if( cInfo[ i ][ cType ] == CARMODTYPE_EXHAUST ) {
							if( cInfo[ i ][ cID ] == InvalidModChecks( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
								TPInfo[ playerid ][ tuneID ] = i;
								break;
							}
						}
					}
					if( TPInfo[ playerid ][ tuneID ] == -1 ) return SendClientMessage(playerid, COLOR_SYNTAX, "No compatible components selected species for your vehicle model." );

					new cid = TPInfo[ playerid ][ tuneID ];
					TPInfo[ playerid ][ tType ] = CARMODTYPE_EXHAUST;
					TPInfo[ playerid ][ tPaintjob ] = false;

					TogglePlayerControllable( playerid, false );
					TuningTDControl( playerid, true );

					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 0 ], "Exhaust" );
					format( string, sizeof( string ), "%s", cInfo[ cid ][ cName ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 1 ], string );
					format( string, sizeof( string ), "Price: $%d", cInfo[ cid ][ cPrice ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 2 ], string );

					AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

					GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], -2, -5, 0 );
					SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

					GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
					SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

					SelectTextDraw( playerid, COLOR_ORANGE );
				}
				case 3: {

					for( new i = 0; i < MAX_COMPONENTS; i++ ) {
						if( cInfo[ i ][ cType ] == CARMODTYPE_FRONT_BUMPER ) {
							if( cInfo[ i ][ cID ] == InvalidModChecks( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
								TPInfo[ playerid ][ tuneID ] = i;
								break;
							}
						}
					}
					if( TPInfo[ playerid ][ tuneID ] == -1 ) return SendClientMessage(playerid, COLOR_SYNTAX, "No compatible components selected species for your vehicle model." );

					new cid = TPInfo[ playerid ][ tuneID ];
					TPInfo[ playerid ][ tType ] = CARMODTYPE_FRONT_BUMPER;
					TPInfo[ playerid ][ tPaintjob ] = false;

					TogglePlayerControllable( playerid, false );
					TuningTDControl( playerid, true );

					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 0 ], "Front Bumper" );
					format( string, sizeof( string ), "%s", cInfo[ cid ][ cName ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 1 ], string );
					format( string, sizeof( string ), "Price: $%d", cInfo[ cid ][ cPrice ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 2 ], string );

					AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

					GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 0, 6, 0.5 ); // done
					SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

					GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
					SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

					SelectTextDraw( playerid, COLOR_ORANGE );
				}
				case 4: { 

					for( new i = 0; i < MAX_COMPONENTS; i++ ) {
						if( cInfo[ i ][ cType ] == CARMODTYPE_REAR_BUMPER ) {
							if( cInfo[ i ][ cID ] == InvalidModChecks( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
								TPInfo[ playerid ][ tuneID ] = i;
								break;
							}
						}
					}
					if( TPInfo[ playerid ][ tuneID ] == -1 ) return SendClientMessage(playerid, COLOR_SYNTAX, "No compatible components selected species for your vehicle model." );

					new cid = TPInfo[ playerid ][ tuneID ];
					TPInfo[ playerid ][ tType ] = CARMODTYPE_REAR_BUMPER;
					TPInfo[ playerid ][ tPaintjob ] = false;

					TogglePlayerControllable( playerid, false );
					TuningTDControl( playerid, true );

					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 0 ], "Rear Bumper" );
					format( string, sizeof( string ), "%s", cInfo[ cid ][ cName ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 1 ], string );
					format( string, sizeof( string ), "Price: $%d", cInfo[ cid ][ cPrice ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 2 ], string );

					AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

					GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 0, -6, 0.5 ); // done
					SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

					GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
					SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

					SelectTextDraw( playerid, COLOR_ORANGE );
				}
				case 5: {

					for( new i = 0; i < MAX_COMPONENTS; i++ ) {
						if( cInfo[ i ][ cType ] == CARMODTYPE_ROOF ) {
							if( cInfo[ i ][ cID ] == InvalidModChecks( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
								TPInfo[ playerid ][ tuneID ] = i;
								break;
							}
						}
					}
					if( TPInfo[ playerid ][ tuneID ] == -1 ) return SendClientMessage(playerid, COLOR_SYNTAX, "No compatible components selected species for your vehicle model." );

					new cid = TPInfo[ playerid ][ tuneID ];
					TPInfo[ playerid ][ tType ] = CARMODTYPE_ROOF;
					TPInfo[ playerid ][ tPaintjob ] = false;

					TogglePlayerControllable( playerid, false );
					TuningTDControl( playerid, true );

					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 0 ], "Roof" );
					format( string, sizeof( string ), "%s", cInfo[ cid ][ cName ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 1 ], string );
					format( string, sizeof( string ), "Price: $%d", cInfo[ cid ][ cPrice ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 2 ], string );

					AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

					GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 0, 6, 2 ); // done
					SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

					GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
					SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

					SelectTextDraw( playerid, COLOR_ORANGE );
				}
				case 6: {
					
					for( new i = 0; i < MAX_COMPONENTS; i++ ) {
						if( cInfo[ i ][ cType ] == CARMODTYPE_SPOILER ) {
							if( cInfo[ i ][ cID ] == InvalidModChecks( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
								TPInfo[ playerid ][ tuneID ] = i;
								break;
							}
						}
					}
					if( TPInfo[ playerid ][ tuneID ] == -1 ) return SendClientMessage(playerid, COLOR_SYNTAX, "No compatible components selected species for your vehicle model." );

					new cid = TPInfo[ playerid ][ tuneID ];
					TPInfo[ playerid ][ tType ] = CARMODTYPE_SPOILER;
					TPInfo[ playerid ][ tPaintjob ] = false;
				
					TogglePlayerControllable( playerid, false );
					TuningTDControl( playerid, true );
				
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 0 ], "Spoiler" );
					format( string, sizeof( string ), "%s", cInfo[ cid ][ cName ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 1 ], string );
					format( string, sizeof( string ), "Price: $%d", cInfo[ cid ][ cPrice ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 2 ], string );

					AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );
					
					GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 0, -6, 2 ); // done
					SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );
					
					GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
					SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
					
					SelectTextDraw( playerid, COLOR_ORANGE );
				}
				case 7: {

					for( new i = 0; i < MAX_COMPONENTS; i++ ) {
						if( cInfo[ i ][ cType ] == CARMODTYPE_SIDESKIRT ) {
							if( cInfo[ i ][ cID ] == InvalidModChecks( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
								TPInfo[ playerid ][ tuneID ] = i;
								break;
							}
						}
					}
					if( TPInfo[ playerid ][ tuneID ] == -1 ) return SendClientMessage(playerid, COLOR_SYNTAX, "No compatible components selected species for your vehicle model." );

					new cid = TPInfo[ playerid ][ tuneID ];
					TPInfo[ playerid ][ tType ] = CARMODTYPE_SIDESKIRT;
					TPInfo[ playerid ][ tPaintjob ] = false;

					TogglePlayerControllable( playerid, false );
					TuningTDControl( playerid, true );

					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 0 ], "Sideskirt" );
					format( string, sizeof( string ), "%s", cInfo[ cid ][ cName ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 1 ], string );
					format( string, sizeof( string ), "Price: $%d", cInfo[ cid ][ cPrice ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 2 ], string );

					AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

					GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 4, 0, 0.5 );
					SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

					GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
					SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

					SelectTextDraw( playerid, COLOR_ORANGE );
				}
				case 8: {

					for( new i = 0; i < MAX_COMPONENTS; i++ ) {
						if( cInfo[ i ][ cType ] == CARMODTYPE_WHEELS ) {
							if( cInfo[ i ][ cID ] == InvalidModChecks( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
								TPInfo[ playerid ][ tuneID ] = i;
								break;
							}
						}
					}
					if( TPInfo[ playerid ][ tuneID ] == -1 ) return SendClientMessage(playerid, COLOR_SYNTAX, "No compatible components selected species for your vehicle model." );

					new cid = TPInfo[ playerid ][ tuneID ];
					TPInfo[ playerid ][ tType ] = CARMODTYPE_WHEELS;
					TPInfo[ playerid ][ tPaintjob ] = false;

					TogglePlayerControllable( playerid, false );
					TuningTDControl( playerid, true );

					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 0 ], "Wheels" );
					format( string, sizeof( string ), "%s", cInfo[ cid ][ cName ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 1 ], string );
					format( string, sizeof( string ), "Price: $%d", cInfo[ cid ][ cPrice ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 2 ], string );

					AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

					GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 4, 0, 0.5 ); // done
					SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

					GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
					SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

					SelectTextDraw( playerid, COLOR_ORANGE );
				}
				case 9: {

					for( new i = 0; i < MAX_COMPONENTS; i++ ) {
						if( cInfo[ i ][ cType ] == CARMODTYPE_STEREO ) {
							if( cInfo[ i ][ cID ] == InvalidModChecks( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
								TPInfo[ playerid ][ tuneID ] = i;
								break;
							}
						}
					}
					if( TPInfo[ playerid ][ tuneID ] == -1 ) return SendClientMessage(playerid, COLOR_SYNTAX, "No compatible components selected species for your vehicle model." );

					new cid = TPInfo[ playerid ][ tuneID ];
					TPInfo[ playerid ][ tType ] = CARMODTYPE_STEREO;
					TPInfo[ playerid ][ tPaintjob ] = false;

					TogglePlayerControllable( playerid, false );
					TuningTDControl( playerid, true );

					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 0 ], "Stereo" );
					format( string, sizeof( string ), "%s", cInfo[ cid ][ cName ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 1 ], string );
					format( string, sizeof( string ), "Price: $%d", cInfo[ cid ][ cPrice ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 2 ], string );

					AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

					GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 0, -6, 2 );
					SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

					GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
					SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

					SelectTextDraw( playerid, COLOR_ORANGE );
				}
				case 10: {

					for( new i = 0; i < MAX_COMPONENTS; i++ ) {
						if( cInfo[ i ][ cType ] == CARMODTYPE_HYDRAULICS ) {
							if( cInfo[ i ][ cID ] == InvalidModChecks( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
								TPInfo[ playerid ][ tuneID ] = i;
								break;
							}
						}
					}
					if( TPInfo[ playerid ][ tuneID ] == -1 ) return SendClientMessage(playerid, COLOR_SYNTAX, "No compatible components selected species for your vehicle model." );

					new cid = TPInfo[ playerid ][ tuneID ];
					TPInfo[ playerid ][ tType ] = CARMODTYPE_HYDRAULICS;
					TPInfo[ playerid ][ tPaintjob ] = false;

					TogglePlayerControllable( playerid, false );
					TuningTDControl( playerid, true );

					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 0 ], "Hydraulics" );
					format( string, sizeof( string ), "%s", cInfo[ cid ][ cName ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 1 ], string );
					format( string, sizeof( string ), "Price: $%d", cInfo[ cid ][ cPrice ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 2 ], string );

					AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

					GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 2, 2, 2 );
					SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

					GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
					SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

					SelectTextDraw( playerid, COLOR_ORANGE );
				}
				case 11: {

					for( new i = 0; i < MAX_COMPONENTS; i++ ) {
						if( cInfo[ i ][ cType ] == CARMODTYPE_NITRO ) {
							if( cInfo[ i ][ cID ] == InvalidModChecks( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
								TPInfo[ playerid ][ tuneID ] = i;
								break;
							}
						}
					}
					if( TPInfo[ playerid ][ tuneID ] == -1 ) return SendClientMessage(playerid, COLOR_SYNTAX, "No compatible components selected species for your vehicle model." );

					new cid = TPInfo[ playerid ][ tuneID ];
					TPInfo[ playerid ][ tType ] = CARMODTYPE_NITRO;
					TPInfo[ playerid ][ tPaintjob ] = false;

					TogglePlayerControllable( playerid, false );
					TuningTDControl( playerid, true );

					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 0 ], "Nitro" );
					format( string, sizeof( string ), "%s", cInfo[ cid ][ cName ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 1 ], string );
					format( string, sizeof( string ), "Price: $%d", cInfo[ cid ][ cPrice ] );
					PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 2 ], string );

					AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

					GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 0, -6, 2 ); // done
					SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

					GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
					SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

					SelectTextDraw( playerid, COLOR_ORANGE );
				}	
			}
		}
		else if( !response ) {
			DeletePVar(playerid, "isTuning");
			SetCameraBehindPlayer( playerid );
			ResetTuningInfo(playerid);
			TuningTDControl( playerid, false );
			TogglePlayerControllable( playerid, true );		
			CancelSelectTextDraw(playerid);			
		}	
		return 1;
	}
	if(dialogid == DIALOG_TUNING_2)
	{
		if( response ) {
			if( !IsPlayerInAnyVehicle( playerid ) ) return SendClientMessage(playerid, COLOR_SYNTAX, "You must be in the vehicle." );
			if( GetPlayerState( playerid ) != PLAYER_STATE_DRIVER ) return SendClientMessage(playerid, COLOR_SYNTAX, "You must be in the driver's seat." );
			new vehicleid = GetPlayerVehicleID( playerid );
			if( GetPlayerCash( playerid ) < 100 ) return SendClientMessage(playerid, COLOR_SYNTAX, "You do not have enough money." );
			new b1, b2;
			if( sscanf( inputtext, "ii", b1, b2 ) ) return ShowPlayerDialog( playerid, DIALOG_TUNING_2, DIALOG_STYLE_INPUT, "Select your Color", "Input Color1 ID and Color2 ID.\nExample: 0 1", "Okay", "Cancel" );
			if( b1 < 0 || b2 < 0 || b1 > 255 || b2 > 255 ) return SendClientMessage(playerid, COLOR_SYNTAX, "Color ID can't be higher from 255 or lower than 0!");
			
			ChangeVehicleColor( vehicleid, b1, b2 );
			
			if(VehicleInfo[vehicleid][vID] > 0 && (VehicleInfo[vehicleid][vOwnerID] >= 1))
			{
				VehicleInfo[vehicleid][vColor1] = b1;
				VehicleInfo[vehicleid][vColor2] = b2;
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET color1 = %i, color2 = %i WHERE id = %i", VehicleInfo[vehicleid][vColor1], VehicleInfo[vehicleid][vColor2], VehicleInfo[vehicleid][vID]);
				mysql_tquery(connectionID, queryBuffer);
			}
			
			GivePlayerCash( playerid, -100 );
			
			ShowPlayerDialog( playerid, DIALOG_TUNING, DIALOG_STYLE_LIST, "Car Tuning", "Paintjobs\nColors\nExhausts\nFront Bumper\nRear Bumper\nRoof\nSpoilers\nSide Skirts\nWheels\nCar Stereo\nHydraulics\nNitro", "Okay", "Cancel" );
		}
		else 
		{
			ShowPlayerDialog( playerid, DIALOG_TUNING, DIALOG_STYLE_LIST, "Car Tuning", "Paintjobs\nColors\nExhausts\nFront Bumper\nRear Bumper\nRoof\nSpoilers\nSide Skirts\nWheels\nCar Stereo\nHydraulics\nNitro", "Okay", "Cancel" );		
		}
		return 1;
	}	
	
	#if defined TUNE_OnDialogResponse
		return TUNE_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnDialogResponse
	#undef OnDialogResponse
#else
	#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse TUNE_OnDialogResponse
#if defined TUNE_OnDialogResponse
	forward TUNE_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	new string[128];

	if(_:clickedid != INVALID_TEXT_DRAW){
		if( clickedid == gTuningBuy[ 1 ] ) { // Right
			if( !IsPlayerInAnyVehicle( playerid ) ) 
			{
				TuningTDControl( playerid, false );
				TogglePlayerControllable( playerid, true );			
				CancelSelectTextDraw(playerid);		
				return SendClientMessageEx( playerid, COLOR_GRAD2, "You must be in the vehicle." );
			}
			if( GetPlayerState( playerid ) != PLAYER_STATE_DRIVER )
			{
				TuningTDControl( playerid, false );
				TogglePlayerControllable( playerid, true );			
				CancelSelectTextDraw(playerid);
				return SendClientMessageEx( playerid, COLOR_GRAD2, "You must be in the driver's seat." );
			}
				
			if( TPInfo[ playerid ][ tPaintjob ] == false ) {
			
				new compid = -1, vehicleid = GetPlayerVehicleID( playerid );
		
				for( new i = ( TPInfo[ playerid ][ tuneID ]+1 ); i < MAX_COMPONENTS; i++ ) {
					if( cInfo[ i ][ cType ] == TPInfo[ playerid ][ tType ] ) {
						if( cInfo[ i ][ cID ] == InvalidModChecks( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
							compid = i;
							break;
						}
					}
				}
				if( compid == -1 ) 
				{
					//ShowPlayerDialog( playerid, DIALOG_TUNING, DIALOG_STYLE_LIST, "Car Tuning", "Paintjobs\nColors\nExhausts\nFront Bumper\nRear Bumper\nRoof\nSpoilers\nSide Skirts\nWheels\nCar Stereo\nHydraulics\nNitro", "Okay", "Cancel" );
					return SendClientMessageEx( playerid, COLOR_GRAD2, "No compatible components selected species for your vehicle model" );
				}

				RemoveVehicleComponent( vehicleid, cInfo[ TPInfo[ playerid ][ tuneID ] ][ cID ] );

				TPInfo[ playerid ][ tuneID ] = compid;

				format( string, sizeof( string ), "%s", cInfo[ compid ][ cName ] );
				PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 1 ], string );
				format( string, sizeof( string ), "Price: $%d", cInfo[ compid ][ cPrice ] );
				PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 2 ], string );

				AddVehicleComponent( vehicleid, cInfo[ compid ][ cID ] );

				SelectTextDraw( playerid, COLOR_ORANGE );
			}
			else if( TPInfo[ playerid ][ tPaintjob ] == true ) {
			
				new paintid = -1, vehicleid = GetPlayerVehicleID( playerid );
				
				for( new i = ( TPInfo[ playerid ][ tuneID ]+1 ); i < NUMBER_TYPE_PAINTJOB; i++ ) {
					if( pjInfo[ i ][ vehID ] == GetVehicleModel( vehicleid ) ) {
						paintid = i;
						break;
					}
				}
				
				if( paintid == -1 ) 
				{
					//ShowPlayerDialog( playerid, DIALOG_TUNING, DIALOG_STYLE_LIST, "Car Tuning", "Paintjobs\nColors\nExhausts\nFront Bumper\nRear Bumper\nRoof\nSpoilers\nSide Skirts\nWheels\nCar Stereo\nHydraulics\nNitro", "Okay", "Cancel" );
					return SendClientMessageEx( playerid, COLOR_GRAD2, "No compatible paintjobs for your vehicle model." );
				}	
				
				TPInfo[ playerid ][ tuneID ] = paintid;
				
				format( string, sizeof( string ), "%s", pjInfo[ paintid ][ pjName ] );
				PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 1 ], string );
				format( string, sizeof( string ), "Price: $%d", pjInfo[ paintid ][ pPrice ] );
				PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 2 ], string );
				
				ChangeVehiclePaintjob( vehicleid, pjInfo[ paintid ][ pNumber ] );
				
				SelectTextDraw( playerid, COLOR_ORANGE );
			}
		}
		if( clickedid == gTuningBuy [ 0 ] ) { // left
			if( TPInfo[ playerid ][ tPaintjob ] == false ) {
			
				if( !IsPlayerInAnyVehicle( playerid ) ) 
				{
					TuningTDControl( playerid, false );
					TogglePlayerControllable( playerid, true );			
					CancelSelectTextDraw(playerid);		
					return SendClientMessageEx( playerid, COLOR_GRAD2, "You must be in the vehicle." );
				}
				if( GetPlayerState( playerid ) != PLAYER_STATE_DRIVER )
				{
					TuningTDControl( playerid, false );
					TogglePlayerControllable( playerid, true );			
					CancelSelectTextDraw(playerid);
					return SendClientMessageEx( playerid, COLOR_GRAD2, "You must be in the driver's seat." );
				}
			
				new compid = -1, vehicleid = GetPlayerVehicleID( playerid );

				for( new i = (TPInfo[ playerid ][ tuneID ]-1); i > 0; i-- ) {
					if( cInfo[ i ][ cType ] == TPInfo[ playerid ][ tType ] ) {
						if( cInfo[ i ][ cID ] == InvalidModChecks( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
							compid = i;
							break;
						}
					}
				}

				if( compid == -1 ) 
				{
					//ShowPlayerDialog( playerid, DIALOG_TUNING, DIALOG_STYLE_LIST, "Car Tuning", "Paintjobs\nColors\nExhausts\nFront Bumper\nRear Bumper\nRoof\nSpoilers\nSide Skirts\nWheels\nCar Stereo\nHydraulics\nNitro", "Okay", "Cancel" );
					return SendClientMessageEx( playerid, COLOR_GRAD2, "No compatible components selected species for your vehicle model" );
				}
				
				RemoveVehicleComponent( vehicleid, cInfo[ TPInfo[ playerid ][ tuneID ] ][ cID ] );

				TPInfo[ playerid ][ tuneID ] = compid;

				format( string, sizeof( string ), "%s", cInfo[ compid ][ cName ] );
				PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 1 ], string );
				format( string, sizeof( string ), "Price: $%d", cInfo[ compid ][ cPrice ] );
				PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 2 ], string );

				AddVehicleComponent( vehicleid, cInfo[ compid ][ cID ] );

				SelectTextDraw( playerid, COLOR_ORANGE );
			}
			else if( TPInfo[ playerid ][ tPaintjob ] == true ) {

				new paintid = -1, vehicleid = GetPlayerVehicleID( playerid );

				for( new i = (TPInfo[ playerid ][ tuneID ]-1); i > 0; i-- ) {
					if( pjInfo[ i ][ vehID ] == GetVehicleModel( vehicleid ) ) {
						paintid = i;
						break;
					}
				}

				if( paintid == -1 ) 
				{
					//ShowPlayerDialog( playerid, DIALOG_TUNING, DIALOG_STYLE_LIST, "Car Tuning", "Paintjobs\nColors\nExhausts\nFront Bumper\nRear Bumper\nRoof\nSpoilers\nSide Skirts\nWheels\nCar Stereo\nHydraulics\nNitro", "Okay", "Cancel" );
					return SendClientMessageEx( playerid, COLOR_GRAD2, "No compatible paintjobs for your vehicle model." );
				}	

				TPInfo[ playerid ][ tuneID ] = paintid;

				format( string, sizeof( string ), "%s", pjInfo[ paintid ][ pjName ] );
				PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 1 ], string );
				format( string, sizeof( string ), "Price: $%d", pjInfo[ paintid ][ pPrice ] );
				PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 2 ], string );

				ChangeVehiclePaintjob( vehicleid, pjInfo[ paintid ][ pNumber ] );

				SelectTextDraw( playerid, COLOR_ORANGE );
			}
		}
		if( clickedid == gTuningBuy [ 2 ] ) { // purchase
			if( !IsPlayerInAnyVehicle( playerid ) ) 
			{
				TuningTDControl( playerid, false );
				TogglePlayerControllable( playerid, true );			
				CancelSelectTextDraw(playerid);		
				return SendClientMessageEx( playerid, COLOR_GRAD2, "You must be in the vehicle." );
			}
			if( GetPlayerState( playerid ) != PLAYER_STATE_DRIVER )
			{
				TuningTDControl( playerid, false );
				TogglePlayerControllable( playerid, true );			
				CancelSelectTextDraw(playerid);
				return SendClientMessageEx( playerid, COLOR_GRAD2, "You must be in the driver's seat." );
			}
			
			new Float:Pos [ 6 ], vehicleid = GetPlayerVehicleID( playerid );

			if( TPInfo[ playerid ][ tPaintjob ] == false ) {
			
				if( GetPlayerCash( playerid ) < cInfo[ TPInfo[ playerid ][ tuneID ] ][ cPrice ] ) 
				{
					//ShowPlayerDialog( playerid, DIALOG_TUNING, DIALOG_STYLE_LIST, "Car Tuning", "Paintjobs\nColors\nExhausts\nFront Bumper\nRear Bumper\nRoof\nSpoilers\nSide Skirts\nWheels\nCar Stereo\nHydraulics\nNitro", "Okay", "Cancel" );			
					return SendClientMessageEx( playerid, COLOR_GRAD2, "You do not have enough money." );
				}

				new cid = TPInfo[ playerid ][ tuneID ];

				RemoveVehicleComponent( vehicleid, cInfo[ TPInfo[ playerid ][ tuneID ] ][ cID ] );
				AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );
				
				GivePlayerCash( playerid, -cInfo[ TPInfo[ playerid ][ tuneID ] ][ cPrice ] );
				if(VehicleInfo[vehicleid][vOwnerID] >= 1) 
				{
					SaveVehicleModifications(vehicleid);
				}
			}
			else if( TPInfo[ playerid ][ tPaintjob ] == true ) {
			
				if( GetPlayerCash( playerid ) < pjInfo[ TPInfo[ playerid ][ tuneID ] ][ pPrice ] ) 
				{
					//ShowPlayerDialog( playerid, DIALOG_TUNING, DIALOG_STYLE_LIST, "Car Tuning", "Paintjobs\nColors\nExhausts\nFront Bumper\nRear Bumper\nRoof\nSpoilers\nSide Skirts\nWheels\nCar Stereo\nHydraulics\nNitro", "Okay", "Cancel" );			
					return SendClientMessageEx( playerid, COLOR_GRAD2, "You do not have enough money." );
				}
			
				new paintid = TPInfo[ playerid ][ tuneID ];

				GivePlayerCash( playerid, -pjInfo[ TPInfo[ playerid ][ tuneID ] ][ pPrice ] );
				
				ChangeVehicleColor( vehicleid, TPInfo[ playerid ][ PJColor ][ 0 ], TPInfo[ playerid ][ PJColor ][ 1 ] );
			
				if(VehicleInfo[vehicleid][vOwnerID] >= 1) 
				{
					VehicleInfo[vehicleid][vPaintjob] = pjInfo[ paintid ][ pNumber ];
					mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE vehicles SET paintjob = %d WHERE id = %d", pjInfo[ paintid ][ pNumber ], VehicleInfo[vehicleid][vID]);
					mysql_tquery(connectionID, queryBuffer);		
					SetTimerEx("LoadPaintjob", 1500, false, "d", vehicleid);
				}		
			}
			GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 0, 6, 2 );
			SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

			GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
			SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
			
			CancelSelectTextDraw( playerid );

			TuningTDControl( playerid, false );
			TogglePlayerControllable( playerid, true );

			ShowPlayerDialog( playerid, DIALOG_TUNING, DIALOG_STYLE_LIST, "Car Tuning", "Paintjobs\nColors\nExhausts\nFront Bumper\nRear Bumper\nRoof\nSpoilers\nSide Skirts\nWheels\nCar Stereo\nHydraulics\nNitro", "Okay", "Cancel" );
		}	
		if(clickedid == gTuningBuy[3]) // Close
		{
			if( !IsPlayerInAnyVehicle( playerid ) ) return SendClientMessageEx( playerid, COLOR_GRAD2, "You must be in the vehicle." );
			if( GetPlayerState( playerid ) != PLAYER_STATE_DRIVER ) return SendClientMessageEx( playerid, COLOR_GRAD2, "You must be in the driver's seat." );

			new Float:Pos[ 6 ], vehicleid = GetPlayerVehicleID( playerid );

			if( TPInfo[ playerid ][ tPaintjob ] == false ) {

				RemoveVehicleComponent( vehicleid, cInfo[ TPInfo[ playerid ][ tuneID ] ][ cID ] );

				//SetTune( vehicleid );
				if(VehicleInfo[vehicleid][vOwnerID] >= 1)
				{
					if(VehicleInfo[vehicleid][vPaintjob] != -1)
					{
						ChangeVehiclePaintjob(vehicleid, VehicleInfo[vehicleid][vPaintjob]);
					}
					ChangeVehicleColor(vehicleid, VehicleInfo[vehicleid][vColor1], VehicleInfo[vehicleid][vColor2]);						
				
					for(new i = 0; i < 14; i ++)
					{
						if(VehicleInfo[vehicleid][vMods][i] >= 1000)
						{
							AddVehicleComponent(vehicleid, VehicleInfo[vehicleid][vMods][i]);
						}
					}
				}
			}
			else if( TPInfo[ playerid ][ tPaintjob ] == true ) {

				ChangeVehiclePaintjob( vehicleid, TPInfo[ playerid ][ PJPaintjob ] );
				ChangeVehicleColor( vehicleid, TPInfo[ playerid ][ PJColor ][ 0 ], TPInfo[ playerid ][ PJColor ][ 1 ] );
			}

			GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 0, 6, 2 );
			SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

			GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
			SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

			TuningTDControl( playerid, false );
			TogglePlayerControllable( playerid, true );

			ShowPlayerDialog( playerid, DIALOG_TUNING, DIALOG_STYLE_LIST, "Car Tuning", "Paintjobs\nColors\nExhausts\nFront Bumper\nRear Bumper\nRoof\nSpoilers\nSide Skirts\nWheels\nCar Stereo\nHydraulics\nNitro", "Okay", "Cancel" );
		}
	}
	else if(_:clickedid == INVALID_TEXT_DRAW) {

		if(GetPVarInt(playerid, "isTuning"))
		{
			if( !IsPlayerInAnyVehicle( playerid ) ) return SendClientMessageEx( playerid, COLOR_GRAD2, "You must be in the vehicle." );
			if( GetPlayerState( playerid ) != PLAYER_STATE_DRIVER ) return SendClientMessageEx( playerid, COLOR_GRAD2, "You must be in the driver's seat." );

			new Float:Pos[ 6 ], vehicleid = GetPlayerVehicleID( playerid );

			if( TPInfo[ playerid ][ tPaintjob ] == false ) {

				RemoveVehicleComponent( vehicleid, cInfo[ TPInfo[ playerid ][ tuneID ] ][ cID ] );

				//SetTune( vehicleid );
				if(VehicleInfo[vehicleid][vOwnerID] >= 1)
				{
					if(VehicleInfo[vehicleid][vPaintjob] != -1)
					{
						ChangeVehiclePaintjob(vehicleid, VehicleInfo[vehicleid][vPaintjob]);
					}
					ChangeVehicleColor(vehicleid, VehicleInfo[vehicleid][vColor1], VehicleInfo[vehicleid][vColor2]);						
				
					for(new i = 0; i < 14; i ++)
					{
						if(VehicleInfo[vehicleid][vMods][i] >= 1000)
						{
							AddVehicleComponent(vehicleid, VehicleInfo[vehicleid][vMods][i]);
						}
					}
				}
			}
			else if( TPInfo[ playerid ][ tPaintjob ] == true ) {

				ChangeVehiclePaintjob( vehicleid, TPInfo[ playerid ][ PJPaintjob ] );
				ChangeVehicleColor( vehicleid, TPInfo[ playerid ][ PJColor ][ 0 ], TPInfo[ playerid ][ PJColor ][ 1 ] );
			}

			GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 0, 6, 2 );
			SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

			GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
			SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

			TuningTDControl( playerid, false );
			TogglePlayerControllable( playerid, true );

			ShowPlayerDialog( playerid, DIALOG_TUNING, DIALOG_STYLE_LIST, "Car Tuning", "Paintjobs\nColors\nExhausts\nFront Bumper\nRear Bumper\nRoof\nSpoilers\nSide Skirts\nWheels\nCar Stereo\nHydraulics\nNitro", "Okay", "Cancel" );
		}
	}		
	#if defined TUNE_OnPlayerClickTextDraw
		return TUNE_OnPlayerClickTextDraw(playerid, clickedid);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerClickTextDraw
	#undef OnPlayerClickTextDraw
#else
	#define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw TUNE_OnPlayerClickTextDraw
#if defined TUNE_OnPlayerClickTextDraw
	forward TUNE_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

forward LoadPaintjob(vehicleid);
public LoadPaintjob(vehicleid)
{
	if(IsValidVehicle(vehicleid))
	{
		if(VehicleInfo[vehicleid][vID] > 0 && VehicleInfo[vehicleid][vOwnerID] >= 1)
		{
			if(VehicleInfo[vehicleid][vPaintjob] != -1)
			{
				ChangeVehiclePaintjob(vehicleid, VehicleInfo[vehicleid][vPaintjob]);
			}
			ChangeVehicleColor(vehicleid, VehicleInfo[vehicleid][vColor1], VehicleInfo[vehicleid][vColor2]);		
		
			for(new i = 0; i < 14; i ++)
			{
				if(VehicleInfo[vehicleid][vMods][i] >= 1000)
				{
					AddVehicleComponent(vehicleid, VehicleInfo[vehicleid][vMods][i]);
				}
			}		
		}
	}
	return 1;
}