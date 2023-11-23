// Define constants for computer colors
#define COLOR_DEFAULT 0xC5C5C5FF
#define MAX_COMPUTERS 50

new gComputerData[MAX_COMPUTERS][3]; // Array to store computer data

// Computer data structure
enum ComputerData
{
    cell computerId,
    cell ownerId,
    computerName[24]
};

// Enum for computer menu options
enum ComputerMenuOptions
{
    COMPUTER_MENU_MAIN,
    COMPUTER_MENU_VIEW_MESSAGES,
    COMPUTER_MENU_SEND_MESSAGE,
    COMPUTER_MENU_VIEW_FILES,
    COMPUTER_MENU_DOWNLOAD_FILE,
    COMPUTER_MENU_UPLOAD_FILE,
    COMPUTER_MENU_LOGOUT
};

// Function to create a new computer
ComputerData CreateComputer(cell computerId, cell ownerId, char[] computerName)
{
    ComputerData computer;

    computer.computerId = computerId;
    computer.ownerId = ownerId;
    strcpy(computer.computerName, computerName);

    return computer;
}

// Function to get the index of a computer by its ID
cell GetComputerIndex(cell computerId)
{
    for(cell i = 0; i < MAX_COMPUTERS; i++)
    {
        if(gComputerData[i][0] == computerId)
        {
            return i;
        }
    }
    return -1;
}

// Function to display the main computer menu
void ShowComputerMainMenu(playerid)
{
    new computerIndex = GetComputerIndex(gPlayerData[playerid][PLAYER_COMPUTER_ID]);

    ShowPlayerDialog(playerid, COMPUTER_MENU_MAIN, DIALOG_STYLE_LIST, "Computer Menu", "Select an option:", "View Messages|Send Message|View Files|Download File|Upload File|Logout");

    // Set the computer name as the dialog caption
    SetDialogCaption(playerid, gComputerData[computerIndex][2]);
}

// Callback function for the computer menu
public OnPlayerDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == COMPUTER_MENU_MAIN)
    {
        new computerIndex = GetComputerIndex(gPlayerData[playerid][PLAYER_COMPUTER_ID]);

        switch(response)
        {
            case COMPUTER_MENU_VIEW_MESSAGES:
                // TODO: Display messages
                break;
            case COMPUTER_MENU_SEND_MESSAGE:
                // TODO: Send message
                break;
            case COMPUTER_MENU_VIEW_FILES:
                // TODO: Display files
                break;
            case COMPUTER_MENU_DOWNLOAD_FILE:
                // TODO: Download file
                break;
            case COMPUTER_MENU_UPLOAD_FILE:
                // TODO: Upload file
                break;
            case COMPUTER_MENU_LOGOUT:
                // Set the player's computer ID to invalid
                gPlayerData[playerid][PLAYER_COMPUTER_ID] = INVALID_COMPUTER_ID;
                SendClientMessage(playerid, COLOR_DEFAULT, "You have logged out of the computer.");
                break;
        }

        // Show the main menu again
        ShowComputerMainMenu(playerid);
    }

    return 1;
}

// Function to handle player input for the computer system
public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/computer", true))
    {
        new computerIndex = GetComputerIndex(gPlayerData[playerid][PLAYER_COMPUTER_ID]);

        if(computerIndex != -1)
        {
            // Show the main computer menu
            ShowComputerMainMenu(playerid);
        }
        else
        {
            SendClientMessage(playerid, COLOR_ERROR, "You are not logged into a computer!");
        }

        return 1;
    }

    return 0;
}
