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

ShowLockScreen(playerid)
{
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][0]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][1]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][2]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][3]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][4]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][5]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][6]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][7]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][8]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][9]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][10]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][11]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][12]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][13]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][14]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][15]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][16]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][17]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][18]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][19]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][20]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][21]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][22]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][23]);
    PlayerTextDrawShow(playerid, CellphoneLock[playerid][24]);
}

ShowPhoneMenu(playerid)
{
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][0]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][1]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][2]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][3]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][4]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][5]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][6]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][7]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][8]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][9]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][10]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][11]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][12]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][13]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][14]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][15]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][16]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][17]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][18]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][19]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][20]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][21]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][22]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][23]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][24]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][25]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][26]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][27]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][28]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][29]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][30]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][31]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][32]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][33]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][34]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][35]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][36]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][37]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][38]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][39]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][40]);
    PlayerTextDrawShow(playerid, CellphoneMenu[playerid][41]);
}

ShowPhoneDial(playerid)
{
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][0]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][1]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][2]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][3]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][4]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][5]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][6]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][7]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][8]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][9]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][10]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][11]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][12]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][13]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][14]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][15]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][16]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][17]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][18]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][19]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][20]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][21]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][22]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][23]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][24]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][25]);
    PlayerTextDrawShow(playerid, CellphoneOnDial[playerid][26]);
}

ShowPhoneRinging(playerid)
{
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][0]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][1]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][2]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][3]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][4]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][5]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][6]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][7]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][8]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][9]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][10]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][11]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][12]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][13]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][14]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][15]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][16]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][17]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][18]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][19]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][20]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][21]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][22]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][23]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][24]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][25]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][26]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][27]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][28]);
    PlayerTextDrawShow(playerid, CellphoneOnRinging[playerid][29]);
}

ShowPhoneCalling(playerid)
{
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][0]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][1]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][2]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][3]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][4]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][5]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][6]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][7]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][8]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][9]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][10]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][11]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][12]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][13]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][14]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][15]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][16]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][17]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][18]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][19]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][20]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][21]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][22]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][23]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][24]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][25]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][26]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][27]);
    PlayerTextDrawShow(playerid, CellphoneOnCall[playerid][28]);
}

ShowPhoneBank(playerid)
{
    PlayerTextDrawShow(playerid, CellphoneBankTD[playerid][0]);
    PlayerTextDrawShow(playerid, CellphoneBankTD[playerid][1]);
    PlayerTextDrawShow(playerid, CellphoneBankTD[playerid][2]);
    PlayerTextDrawShow(playerid, CellphoneBankTD[playerid][3]);
    PlayerTextDrawShow(playerid, CellphoneBankTD[playerid][4]);
    PlayerTextDrawShow(playerid, CellphoneBankTD[playerid][5]);
    PlayerTextDrawShow(playerid, CellphoneBankTD[playerid][6]);
    PlayerTextDrawShow(playerid, CellphoneBankTD[playerid][7]);
    PlayerTextDrawShow(playerid, CellphoneBankTD[playerid][8]);
    PlayerTextDrawShow(playerid, CellphoneBankTD[playerid][9]);
    PlayerTextDrawShow(playerid, CellphoneBankTD[playerid][10]);
    PlayerTextDrawShow(playerid, CellphoneBankTD[playerid][11]);
    PlayerTextDrawShow(playerid, CellphoneBankTD[playerid][12]);
    PlayerTextDrawShow(playerid, CellphoneBankTD[playerid][13]);
    PlayerTextDrawShow(playerid, CellphoneBankTD[playerid][14]);
}

HideLockScreen(playerid)
{
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][0]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][1]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][2]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][3]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][4]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][5]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][6]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][7]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][8]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][9]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][10]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][11]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][12]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][13]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][14]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][15]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][16]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][17]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][18]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][19]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][20]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][21]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][22]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][23]);
    PlayerTextDrawHide(playerid, CellphoneLock[playerid][24]);
}

HidePhoneMenu(playerid)
{
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][0]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][1]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][2]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][3]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][4]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][5]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][6]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][7]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][8]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][9]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][10]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][11]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][12]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][13]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][14]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][15]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][16]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][17]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][18]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][19]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][20]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][21]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][22]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][23]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][24]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][25]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][26]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][27]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][28]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][29]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][30]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][31]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][32]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][33]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][34]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][35]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][36]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][37]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][38]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][39]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][40]);
    PlayerTextDrawHide(playerid, CellphoneMenu[playerid][41]);
}

HidePhoneDial(playerid)
{
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][0]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][1]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][2]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][3]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][4]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][5]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][6]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][7]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][8]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][9]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][10]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][11]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][12]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][13]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][14]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][15]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][16]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][17]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][18]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][19]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][20]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][21]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][22]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][23]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][24]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][25]);
    PlayerTextDrawHide(playerid, CellphoneOnDial[playerid][26]);
}

HidePhoneRinging(playerid)
{
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][0]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][1]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][2]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][3]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][4]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][5]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][6]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][7]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][8]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][9]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][10]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][11]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][12]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][13]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][14]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][15]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][16]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][17]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][18]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][19]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][20]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][21]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][22]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][23]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][24]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][25]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][26]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][27]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][28]);
    PlayerTextDrawHide(playerid, CellphoneOnRinging[playerid][29]);
}

HidePhoneCalling(playerid)
{
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][0]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][1]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][2]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][3]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][4]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][5]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][6]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][7]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][8]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][9]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][10]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][11]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][12]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][13]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][14]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][15]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][16]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][17]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][18]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][19]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][20]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][21]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][22]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][23]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][24]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][25]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][26]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][27]);
    PlayerTextDrawHide(playerid, CellphoneOnCall[playerid][28]);
}

HidePhoneBank(playerid)
{
    PlayerTextDrawHide(playerid, CellphoneBankTD[playerid][0]);
    PlayerTextDrawHide(playerid, CellphoneBankTD[playerid][1]);
    PlayerTextDrawHide(playerid, CellphoneBankTD[playerid][2]);
    PlayerTextDrawHide(playerid, CellphoneBankTD[playerid][3]);
    PlayerTextDrawHide(playerid, CellphoneBankTD[playerid][4]);
    PlayerTextDrawHide(playerid, CellphoneBankTD[playerid][5]);
    PlayerTextDrawHide(playerid, CellphoneBankTD[playerid][6]);
    PlayerTextDrawHide(playerid, CellphoneBankTD[playerid][7]);
    PlayerTextDrawHide(playerid, CellphoneBankTD[playerid][8]);
    PlayerTextDrawHide(playerid, CellphoneBankTD[playerid][9]);
    PlayerTextDrawHide(playerid, CellphoneBankTD[playerid][10]);
    PlayerTextDrawHide(playerid, CellphoneBankTD[playerid][11]);
    PlayerTextDrawHide(playerid, CellphoneBankTD[playerid][12]);
    PlayerTextDrawHide(playerid, CellphoneBankTD[playerid][13]);
    PlayerTextDrawHide(playerid, CellphoneBankTD[playerid][14]);
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

CMD:phone(playerid, params[])
{
    if(!PlayerInfo[playerid][pLogged])
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "You cannot use cellphone while Logging In");
	}
    if(!PlayerInfo[playerid][pPhoneBrand])
        return SendClientMessage(playerid, COLOR_SYNTAX, "You don't have any brand of cellphone");
        
    if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pJailTime] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0)
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "You can't use this command at the moment.");
	}
    if (PlayerInfo[playerid][pJailTime] > 0)
	{
		SendClientMessageEx(playerid,COLOR_GREY,"   You can not use your phone while in jail or prison!");
		return 1;
	}
	ShowLockScreen(playerid);
	SelectTextDraw(playerid, 0xFF0000FF);
	SendClientMessageEx(playerid, COLOR_AQUA, "To hide you phone siplify type '/phonehide");
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