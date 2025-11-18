const TF_TEAM_RED = 2;
const TF_TEAM_BLU = 3;

// indices of the control points
const BLU_LAST = 0;
const BLU_SECOND = 1;
const MID = 2;
const RED_SECOND = 3;
const RED_LAST = 4;

const RED_OWNS_MID = 0;
const RED_OWNS_SECOND = 1;
const BLU_OWNS_MID = 2;
const BLU_OWNS_SECOND = 3;

const EVEN_UBERS = 1;
const RED_AD = 2;
const BLU_AD = 3;

const UBER_AD_AMOUNT = 50.0;

::redObjPoint <- -1;
::bluObjPoint <- -1;

::gameStateEnt <- null;
::gameState <- 0;
::pointState <- -1;
::uberState <- 0;

::playerSpawns <- {};
::charChangeable <- false;
::playerManager <- Entities.FindByClassname(null, "tf_player_manager");

// full ad last conversions from mid/second
::RedMidToLastAd <- function()
{
    pointState = RED_OWNS_MID;
    TeleportPlayers(TF_TEAM_RED, MID);
    uberState = RED_AD;
    redObjPoint = BLU_LAST;
    bluObjPoint = BLU_SECOND; 
    ShowMessage("Mid to Last AD Push\n" +
                "RED must cap last to win\n" +
                "BLU must cap second or further to win"
               );
}

::BluMidToLastAd <- function()
{
    pointState = BLU_OWNS_MID;
    TeleportPlayers(TF_TEAM_BLU, MID);
    uberState = BLU_AD;
    redObjPoint = RED_SECOND;
    bluObjPoint = RED_LAST;
    ShowMessage("Mid to Last AD Push\n" +
                "RED must cap second or further to win\n" +
                "BLU must cap last to win"
               );    
}

::RedSecondToLastAd <- function()
{
    pointState = RED_OWNS_SECOND;
    TeleportPlayers(TF_TEAM_RED, BLU_SECOND);
    uberState = RED_AD;
    redObjPoint = BLU_LAST;
    bluObjPoint = BLU_SECOND;
    ShowMessage("Second to Last AD Push\n" +
                "RED must cap last to win\n" +
                "BLU must cap second to win"
               );
}

::BluSecondToLastAd <- function()
{
    pointState = BLU_OWNS_SECOND;
    TeleportPlayers(TF_TEAM_BLU, RED_SECOND);
    uberState = BLU_AD;
    redObjPoint = RED_SECOND;
    bluObjPoint = RED_LAST;
    ShowMessage("Second to Last AD Push\n" +
                "RED must cap second to win\n" +
                "BLU must cap last to win"
               );
}

// dry game states require pushing two points with one ad
::RedMidToLastDryAd <- function()
{
    pointState = RED_OWNS_MID;
    TeleportPlayers(TF_TEAM_RED, MID);
    TeleportPlayers(TF_TEAM_BLU, BLU_SECOND);
    uberState = RED_AD;
    redObjPoint = BLU_LAST;
    bluObjPoint = BLU_SECOND;
    ShowMessage("Mid to Last DRY Push\n" +
                "RED must cap last to win\n" +
                "BLU must cap second or further to win"
               );
}

::BluMidToLastDryAd <- function()
{
    pointState = BLU_OWNS_MID;
    TeleportPlayers(TF_TEAM_RED, RED_SECOND);
    TeleportPlayers(TF_TEAM_BLU, MID);
    uberState = BLU_AD;
    redObjPoint = RED_SECOND;
    bluObjPoint = RED_LAST;
    ShowMessage("Mid to Last DRY Push\n" +
                "RED must cap second or further to win\n" +
                "BLU must cap last to win"
               );
}

::RedSecondToSecondDryAd <- function()
{
    pointState = BLU_OWNS_MID;
    TeleportPlayers(TF_TEAM_RED, RED_SECOND);
    TeleportPlayers(TF_TEAM_BLU, MID);
    uberState = RED_AD;
    redObjPoint = BLU_SECOND;
    bluObjPoint = MID;
    ShowMessage("Second to Second DRY Push\n" +
                "RED must cap second to win\n" +
                "BLU must cap mid or further to win"
               );
}

::BluSecondToSecondDryAd <- function()
{
    pointState = RED_OWNS_MID;
    TeleportPlayers(TF_TEAM_RED, MID);
    TeleportPlayers(TF_TEAM_BLU, BLU_SECOND);
    uberState = BLU_AD;
    redObjPoint = MID;
    bluObjPoint = RED_SECOND;
    ShowMessage("Second to Second DRY Push\n" +
                "RED must cap mid or further to win\n" +
                "BLU must cap second to win"
               );
}

// even states
::RedMidToSecondEven <- function()
{
    pointState = RED_OWNS_MID;
    TeleportPlayers(TF_TEAM_RED, MID);
    TeleportPlayers(TF_TEAM_BLU, BLU_SECOND);
    uberState = EVEN_UBERS;
    redObjPoint = BLU_SECOND;
    bluObjPoint = MID;
    ShowMessage("Mid to Second EVEN\n" +
                "RED must cap second to win\n" +
                "BLU must cap mid to win"
               );
}

::BluMidToSecondEven <- function()
{
    pointState = BLU_OWNS_MID;
    TeleportPlayers(TF_TEAM_RED, RED_SECOND);
    TeleportPlayers(TF_TEAM_BLU, MID);
    uberState = EVEN_UBERS;
    redObjPoint = MID;
    bluObjPoint = RED_SECOND;
    ShowMessage("Mid to Second EVEN\n" +
                "RED must cap mid to win\n" +
                "BLU must cap second to win"
               );
}

::RedSecondToLastEven <- function()
{
    pointState = RED_OWNS_SECOND;
    TeleportPlayers(TF_TEAM_RED, BLU_SECOND);
    uberState = EVEN_UBERS;
    redObjPoint = BLU_LAST;
    bluObjPoint = BLU_SECOND;
    ShowMessage("Second to Last EVEN\n" +
                "RED must cap last to win\n" +
                "BLU must cap second to win"
               );
}

::BluSecondToLastEven <- function()
{
    pointState = BLU_OWNS_SECOND;
    TeleportPlayers(TF_TEAM_BLU, RED_SECOND);
    uberState = EVEN_UBERS;
    redObjPoint = RED_SECOND;
    bluObjPoint = RED_LAST;
    ShowMessage("Second to Last EVEN\n" +
                "RED must cap second to win\n" +
                "BLU must cap last to win"
               );
}

::GameStates <- {
    "0"  : null,

    // last ad pushes
    "1"  : RedMidToLastAd,
    "2"  : BluMidToLastAd,
    "3"  : RedSecondToLastAd,
    "4"  : BluSecondToLastAd,

    // dry pushes
    "5"  : RedMidToLastDryAd,
    "6"  : BluMidToLastDryAd,
    "7"  : RedSecondToSecondDryAd,
    "8"  : BluSecondToSecondDryAd,

    // even states
    "9"  : RedMidToSecondEven,
    "10" : BluMidToSecondEven,
    "11" : RedSecondToLastEven,
    "12" : BluSecondToLastEven
};

function InitGameState()
{
    gameStateEnt = Entities.FindByName(null, "game_state");
    if (gameStateEnt == null)
    {
        printl("InitGameState: ERROR - couldn't find game_state.");
        return;
    }

    gameState = NetProps.GetPropInt(gameStateEnt, "m_iHealth");
    printl("InitGameState: Loaded gameState = " + gameState);

    if (gameState == 0)
        return;

    local gs = gameState.tostring();
    GameStates[gs]();
}

::SaveGameStateAndRestart <- function(state)
{
    gameState = state;

    if (gameStateEnt == null)
    {
        gameStateEnt = Entities.FindByName(null, "persistent_state");
        if (gameStateEnt == null)
        {
            printl("SaveGameState: ERROR - couldn't find game_state.");
            return;
        }
    }

    NetProps.SetPropInt(gameStateEnt, "m_iHealth", gameState);
    printl("SaveGameState: Saved gameState = " + gameState);
    RestartRound();
}

::SaveGameState <- function(state)
{
    gameState = state;

    if (gameStateEnt == null)
    {
        gameStateEnt = Entities.FindByName(null, "persistent_state");
        if (gameStateEnt == null)
        {
            printl("SaveGameState: ERROR - couldn't find game_state.");
            return;
        }
    }

    NetProps.SetPropInt(gameStateEnt, "m_iHealth", gameState);
    printl("SaveGameState: Saved gameState = " + gameState);
}

::ForceChangeClass <- function(player, class_index)
{
	player.SetPlayerClass(class_index)
	NetProps.SetPropInt(player, "m_Shared.m_iDesiredPlayerClass", class_index)
	player.ForceRegenerateAndRespawn()
}

function CollectEventsInScope(events)
{
	local events_id = UniqueString()
	getroottable()[events_id] <- events

	foreach (name, callback in events)
		events[name] = callback.bindenv(this)

	local cleanup_user_func, cleanup_event = "OnGameEvent_scorestats_accumulated_update"
	if (cleanup_event in events)
		cleanup_user_func = events[cleanup_event]

	events[cleanup_event] <- function(params)
	{
		if (cleanup_user_func)
			cleanup_user_func(params)

		delete getroottable()[events_id]
	}
	__CollectGameEventCallbacks(events)
}

CollectEventsInScope
({
    function OnGameEvent_teamplay_round_start(params){
        charChangeable = true;
    }

    function OnGameEvent_player_changeclass(params){
        if (charChangeable && gameState != 0) {
            local id = params.userid;
            local player = GetPlayerFromUserID(id);
            if (player == null) {
                printl("OnGameEvent_player_changeclass: ERROR - Cannot find player " + id + ".");
                return;
            }

            ForceChangeClass(player, params["class"]);
            player.SetAbsOrigin(playerSpawns[id]);
            player.SetAbsVelocity(Vector(0,0,0));
        }
    }

    // cannot change cp ownership if round is not active, this is a workaround
    // giving teams uber on round activation allows for last minute medic class switches
    function OnGameEvent_teamplay_round_active(params) {
        charChangeable = false;

        switch (pointState)
        {
            case (-1): // if no cp ownership changes is needed
                break;
            case (RED_OWNS_MID):
                RedOwnsMid();
                break;
            case (RED_OWNS_SECOND):
                RedOwnsSecond();
                break;
            case (BLU_OWNS_MID):
                BluOwnsMid();
                break;
            case(BLU_OWNS_SECOND):
                BluOwnsSecond();
                break;
            default:
                printl("OnGameEvent_teamplay_round_active: ERROR - invalid pointState " + pointState + ".");
        }

        switch (uberState)
        {
            case (0): // default/no state loaded
                break;
            case (EVEN_UBERS):
                GiveTeamUber(TF_TEAM_RED, UBER_AD_AMOUNT);
                GiveTeamUber(TF_TEAM_BLU, UBER_AD_AMOUNT);
                break;
            case (RED_AD):
                GiveTeamUber(TF_TEAM_RED, UBER_AD_AMOUNT);
                break;
            case (BLU_AD):
                GiveTeamUber(TF_TEAM_BLU, UBER_AD_AMOUNT);
                break;
            default:
                printl("OnGameEvent_teamplay_round_active: ERROR - invalid uberState " + uberState + ".");
        }
    }

    // runs 'mp_restartgame 5' whenever a objective point is capped
	function OnGameEvent_teamplay_point_captured(params) {
        // unnecessary if last is capped
        if (params.cp == 0 || params.cp == 4)
        {
            SaveGameState(0);
            return;
        }

        // to prevent softlocking, teams can cap the objective point or any point "further" on
        if ((params.team == TF_TEAM_RED && params.cp <= redObjPoint) ||
            (params.team == TF_TEAM_BLU && params.cp >= bluObjPoint))
        {            
            printl("OnGameEvent_teamplay_point_captured: An ObjPoint was capped, resetting.");
            SaveGameStateAndRestart(0);
        }
    }
})

::RestartRound <- function()
{
    local psc = Entities.FindByClassname(null, "point_servercommand");
    if (psc == null)
    {
        printl("RestartRound: ERROR - no point_servercommand found.");
        return;
    }
    
    EntFireByHandle(psc, "Command", "mp_restartgame 5", 0.0, null, null);
}

// blu second spawn points
// -1665, -2176, 840 = on point
// -1663, -1835, 808 = catwalk
// -1329, -1645, 769 = near pipe
// -1651, -2645, 729 = side spire
// -1328, -2376, 641 = front spire
// -1659, -2409, 641 = under spire

// mid spawn points
// -2, 0, 552 = on point
// -153, 201, 808 = on blu crate
// 263, -200, 808 = on red crate
// -3, 10, 801 = middle of height
// -332, -316, 527 = near blue choke
// 290, 300, 520 = near red choke

// red second spawn points (negated x,y coords)
// 1665, 2176, 840 = on point
// 1663, 1835, 808 = catwalk
// 1329, 1645, 769 = near pipe
// 1651, 2645, 729 = side spire
// 1328, 2376, 641 = front spire
// 1659, 2409, 641 = under spire

::GetSpawnPositions <- function(point)
{
    switch (point)
    {
        case BLU_SECOND:
            return [
                Vector(-1665, -2176, 840), // on point
                Vector(-1663, -1835, 808), // catwalk
                Vector(-1329, -1645, 769), // near pipe
                Vector(-1651, -2645, 729), // side spire
                Vector(-1328, -2376, 641), // front spire
                Vector(-1659, -2409, 641)  // under spire
            ];
        case MID:
            return [
                Vector(-2, 0, 552),      // point
                Vector(-153, 201, 808),  // blu crate
                Vector(263, -200, 808),  // red crate
                Vector(-3, 10, 801),     // middle height
                Vector(-332, -316, 527), // near blue choke
                Vector(290, 300, 520)    // near red choke
            ];
        case RED_SECOND:
            return [
                Vector(1665, 2176, 840), // on point
                Vector(1663, 1835, 808), // catwalk
                Vector(1329, 1645, 769), // near pipe
                Vector(1651, 2645, 729), // side spire
                Vector(1328, 2376, 641), // front spire
                Vector(1659, 2409, 641)  // under spire
            ];
        default: // last point, do not teleport
            return [];
    }
}

::TeleportPlayers <- function(team, point)
{
    printl("TeleportPlayers: Teleporting players on team " + team + " to point " + point + ".");
    local playersToTeleport = [];
    local player = null;

    while (player = Entities.FindByClassname(player, "player"))
        if (NetProps.GetPropInt(player, "m_iTeamNum") == team)
            playersToTeleport.append(player);

    local spots = GetSpawnPositions(point);

    local limit = 0;
    if (playersToTeleport.len() < spots.len())
        limit = playersToTeleport.len();
    else
        limit = spots.len();

    for (local i = 0; i < limit; i++)
    {
        local p = playersToTeleport[i];
        local pos = spots[i];

        p.SetAbsOrigin(pos);
        p.SetAbsVelocity(Vector(0,0,0));
        
        local userid = GetPlayerUserID(p);
        playerSpawns[userid] <- spots[i];
    }
}

::GetPlayerUserID <- function(player)
{
    if (player == null || playerManager == null)
        return -1;

    return NetProps.GetPropIntArray(playerManager, "m_iUserID", player.entindex());
}

// names of the actual entities in the map file
const RED = "2";
const BLU = "3";
const MID_ENT_NAME = "cp_3";
const RED_SECOND_ENT_NAME = "cp_red2";
const RED_LAST_ENT_NAME = "cp_red1";
const BLU_SECOND_ENT_NAME = "cp_blu2";
const BLU_LAST_ENT_NAME = "cp_blu1";
const GAME_TEXT_ENT_NAME = "hud_msg";

::RedOwnsMid <- function()
{
    CapPointForTeam(RED_LAST_ENT_NAME, RED);
    CapPointForTeam(RED_SECOND_ENT_NAME, RED);
    CapPointForTeam(MID_ENT_NAME, RED);

}

::RedOwnsSecond <- function()
{
    CapPointForTeam(RED_LAST_ENT_NAME, RED);
    CapPointForTeam(RED_SECOND_ENT_NAME, RED);
    CapPointForTeam(MID_ENT_NAME, RED);
    CapPointForTeam(BLU_SECOND_ENT_NAME, RED);
}

::BluOwnsMid <- function()
{
    CapPointForTeam(BLU_LAST_ENT_NAME, BLU);
    CapPointForTeam(BLU_SECOND_ENT_NAME, BLU);
    CapPointForTeam(MID_ENT_NAME, BLU);
}

::BluOwnsSecond <- function()
{
    CapPointForTeam(BLU_LAST_ENT_NAME, BLU);
    CapPointForTeam(BLU_SECOND_ENT_NAME, BLU);
    CapPointForTeam(MID_ENT_NAME, BLU);
    CapPointForTeam(RED_SECOND_ENT_NAME, BLU);
}

// there is probably a better way of doing this? this approach does not fire any events however
::CapPointForTeam <- function(point, team)
{
    local cp = Entities.FindByName(null, point);

    if (cp == null)
    {
        printl("CapPointForTeam: ERROR - Could not find point " + point + ".");
        return;
    }
    EntFireByHandle(cp, "SetOwner", team, 0.0, null, null);
    printl("CapPointForTeam: Set owner of " + point + " to " + team + ".");

    // changes point skin
    local propName = point;
    if (point == MID_ENT_NAME) // mid prop is prop_cap_C
    {
        propName = "prop_cap_C";
    } else {
        propName += "_prop";
    }

    local cpProp = Entities.FindByName(null, propName);
    if (cpProp != null)
    {
        // 0 = neutral, 1 = RED, 2 = BLU
        local skinIndex = 0;
        switch (team)
        {
            case RED:
                skinIndex = 1;
                break;
            case BLU:
                skinIndex = 2;
                break;
            default:
                skinIndex = 0;
                break;
        }

        EntFireByHandle(cpProp, "Skin", skinIndex.tostring(), 0.0, null, null);
        printl("CapPointForTeam: Set skin of " + propName + " to " + skinIndex + " for team " + team + ".");
    }
    else
    {
        printl("CapPointForTeam: WARNING - Could not find prop " + propName + ".");
    }
}

// finds all meds on team, gives them amount uber
::GiveTeamUber <- function(team, amount)
{
    local player = null;
    while (player = Entities.FindByClassname(player, "player"))
    {
        if (NetProps.GetPropInt(player, "m_iTeamNum") == team &&
            player.GetPlayerClass() == Constants.ETFClass.TF_CLASS_MEDIC)
        {
            local medigun = NetProps.GetPropEntityArray(player, "m_hMyWeapons", 1);
            if (medigun == null)
                continue;

            NetProps.SetPropFloat(medigun, "m_flChargeLevel", amount.tofloat() / 100.0);
            medigun.AcceptInput("SetCharged", "", null, null);
        }
    }
    printl("GiveTeamUber: Set uber for team " + team + " medics to " + amount + "%.");
}

// displays a message on the game_text entity
::ShowMessage <- function(msg)
{
    local gt = Entities.FindByName(null, GAME_TEXT_ENT_NAME);
    if (gt == null)
    {
        printl("ShowMessage: ERROR - Did not find game_text named " + GAME_TEXT_ENT_NAME + ".");
        return;
    }

    EntFireByHandle(gt, "AddOutput", "message " + msg, 0.0, null, null);
    EntFireByHandle(gt, "Display", "", 0.01, null, null);
}