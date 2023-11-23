#define BOOKING_TIME 300 // Time required for a booking (in seconds)
#define PROSTITUTE_PRICE 100 // Price per minute for prostitution services
#define MAX_PROSTITUTE_DIST 10.0 // Maximum distance between prostitute and client for a booking to be accepted

new
    ProstitutePlayers[MAX_PLAYERS], // Array of active prostitutes
    ProstituteCount = 0, // Number of active prostitutes
    ClientPlayers[MAX_PLAYERS], // Array of clients with a booking
    ClientCount = 0; // Number of clients with a booking

// Handle player command
public OnPlayerCommandText(playerid, cmdtext[]) {
    if (strcmp(cmdtext, "/prostituteme", true) == 0) {
        // Check if player is already a prostitute
        for (new i = 0; i < ProstituteCount; i++) {
            if (ProstitutePlayers[i] == playerid) {
                SendClientMessage(playerid, COLOR_RED, "You are already a prostitute.");
                return 1;
            }
        }

        // Add player to prostitute array
        ProstitutePlayers[ProstituteCount] = playerid;
        ProstituteCount++;

        SendClientMessage(playerid, COLOR_GREEN, "You are now a prostitute.");
        return 1;
    }

    if (strcmp(cmdtext, "/bookprostitute", true) == 0) {
        // Check if player is already a client with a booking
        for (new i = 0; i < ClientCount; i++) {
            if (ClientPlayers[i] == playerid) {
                SendClientMessage(playerid, COLOR_RED, "You already have a booking with a prostitute.");
                return 1;
            }
        }

        // Find nearest available prostitute
        new nearestProstitute = INVALID_PLAYER_ID;
        new nearestDist = MAX_PROSTITUTE_DIST;
        for (new i = 0; i < ProstituteCount; i++) {
            if (ProstitutePlayers[i] == INVALID_PLAYER_ID) continue;
            new dist = GetDistanceBetweenPlayers(playerid, ProstitutePlayers[i]);
            if (dist < nearestDist) {
                nearestDist = dist;
                nearestProstitute = ProstitutePlayers[i];
            }
        }

        if (nearestProstitute == INVALID_PLAYER_ID) {
            SendClientMessage(playerid, COLOR_RED, "No prostitutes are currently available.");
            return 1;
        }

        // Check if client has enough money
        if (GetPlayerMoney(playerid) < PROSTITUTE_PRICE * BOOKING_TIME / 60) {
            SendClientMessage(playerid, COLOR_RED, "You don't have enough money for a booking.");
            return 1;
        }

        // Start booking timer
        ClientPlayers[ClientCount] = playerid;
        SetTimerEx("EndBookingTimer", BOOKING_TIME * 1000, false, "d", playerid);
        ClientCount++;

        // Notify player and prostitute
        SendClientMessage(playerid, COLOR_GREEN, "You have booked a prostitute for " + format("%d", BOOKING_TIME) + " seconds for " + format("%d", PROSTITUTE_PRICE) + " crypto per minute.");
        SendClientMessage(nearestProstitute, COLOR_GREEN, "You have a booking with " + GetPlayerName(playerid) + " for " + format("%d", BOOKING_TIME) + " seconds for " + format("%d", PROSTITUTE_PRICE) + " crypto per minute.");
        return 1;
    }

    return 0;
}

// End booking timer
public EndBookingTimer(playerid) {
    //
    