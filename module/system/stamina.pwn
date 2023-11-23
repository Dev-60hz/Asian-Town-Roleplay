#define STAMINA_DEFAULT_MAX				(200)

public OnPlayerStaminaOver(playerid) // stamina callback !
{
	SetPlayerExhausted(playerid, true); // tired anim
	return 1;
}