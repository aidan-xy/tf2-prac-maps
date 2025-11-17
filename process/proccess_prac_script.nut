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

const UBER_AD_AMOUNT = 50.0;

::redObjPoint <- -1;
::bluObjPoint <- -1;

::pointState <- -1;

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

// full ad last conversions from mid/second
function RedMidToLastAd()
{
    pointState = RED_OWNS_MID;
    TeleportPlayers(TF_TEAM_RED, MID);
    GiveTeamUber(TF_TEAM_RED, UBER_AD_AMOUNT);
    redObjPoint = BLU_LAST;
    bluObjPoint = BLU_SECOND; 
    ShowMessage("Mid to Last AD Push\n" +
                "RED must cap last to win\n" +
                "BLU must cap second or further to win"
               );
}

function BluMidToLastAd()
{
    pointState = BLU_OWNS_MID;
    TeleportPlayers(TF_TEAM_BLU, MID);
    GiveTeamUber(TF_TEAM_BLU, UBER_AD_AMOUNT);
    redObjPoint = RED_SECOND;
    bluObjPoint = RED_LAST;
    ShowMessage("Mid to Last AD Push\n" +
                "RED must cap second or further to win\n" +
                "BLU must cap last to win"
               );    
}

function RedSecondToLastAd()
{
    pointState = RED_OWNS_SECOND;
    TeleportPlayers(TF_TEAM_RED, BLU_SECOND);
    GiveTeamUber(TF_TEAM_RED, UBER_AD_AMOUNT);
    redObjPoint = BLU_LAST;
    bluObjPoint = BLU_SECOND;
    ShowMessage("Second to Last AD Push\n" +
                "RED must cap last to win\n" +
                "BLU must cap second to win"
               );
}

function BluSecondToLastAd()
{
    pointState = BLU_OWNS_SECOND;
    TeleportPlayers(TF_TEAM_BLU, RED_SECOND);
    GiveTeamUber(TF_TEAM_BLU, UBER_AD_AMOUNT);
    redObjPoint = RED_SECOND;
    bluObjPoint = RED_LAST;
    ShowMessage("Second to Last AD Push\n" +
                "RED must cap second to win\n" +
                "BLU must cap last to win"
               );
}

// dry game states require pushing two points with one ad
function RedMidToLastDryAd()
{
    pointState = RED_OWNS_MID;
    TeleportPlayers(TF_TEAM_RED, MID);
    TeleportPlayers(TF_TEAM_BLU, BLU_SECOND);
    GiveTeamUber(TF_TEAM_RED, UBER_AD_AMOUNT);
    redObjPoint = BLU_LAST;
    bluObjPoint = BLU_SECOND;
    ShowMessage("Mid to Last DRY Push\n" +
                "RED must cap last to win\n" +
                "BLU must cap second or further to win"
               );
}

function BluMidToLastDryAd()
{
    pointState = BLU_OWNS_MID;
    TeleportPlayers(TF_TEAM_RED, RED_SECOND);
    TeleportPlayers(TF_TEAM_BLU, MID);
    GiveTeamUber(TF_TEAM_BLU, UBER_AD_AMOUNT);
    redObjPoint = RED_SECOND;
    bluObjPoint = RED_LAST;
    ShowMessage("Mid to Last DRY Push\n" +
                "RED must cap second or further to win\n" +
                "BLU must cap last to win"
               );
}

function RedSecondToSecondDryAd()
{
    pointState = BLU_OWNS_MID;
    TeleportPlayers(TF_TEAM_RED, RED_SECOND);
    TeleportPlayers(TF_TEAM_BLU, MID);
    GiveTeamUber(TF_TEAM_RED, UBER_AD_AMOUNT);
    redObjPoint = BLU_SECOND;
    bluObjPoint = MID;
    ShowMessage("Second to Second DRY Push\n" +
                "RED must cap second to win\n" +
                "BLU must cap mid or further to win"
               );
}

function BluSecondToSecondDryAd()
{
    pointState = RED_OWNS_MID;
    TeleportPlayers(TF_TEAM_RED, MID);
    TeleportPlayers(TF_TEAM_BLU, BLU_SECOND);
    GiveTeamUber(TF_TEAM_BLU, UBER_AD_AMOUNT);
    redObjPoint = MID;
    bluObjPoint = RED_SECOND;
    ShowMessage("Second to Second DRY Push\n" +
                "RED must cap mid or further to win\n" +
                "BLU must cap second to win"
               );
}

// even states
function RedMidToSecondEven()
{
    pointState = RED_OWNS_MID;
    TeleportPlayers(TF_TEAM_RED, MID);
    TeleportPlayers(TF_TEAM_BLU, BLU_SECOND);
    GiveTeamUber(TF_TEAM_RED, UBER_AD_AMOUNT);
    GiveTeamUber(TF_TEAM_BLU, UBER_AD_AMOUNT);
    redObjPoint = BLU_SECOND;
    bluObjPoint = MID;
    ShowMessage("Mid to Second EVEN\n" +
                "RED must cap second to win\n" +
                "BLU must cap mid to win"
               );
}

function BluMidToSecondEven()
{
    pointState = BLU_OWNS_MID;
    TeleportPlayers(TF_TEAM_RED, RED_SECOND);
    TeleportPlayers(TF_TEAM_BLU, MID);
    GiveTeamUber(TF_TEAM_RED, UBER_AD_AMOUNT);
    GiveTeamUber(TF_TEAM_BLU, UBER_AD_AMOUNT);
    redObjPoint = MID;
    bluObjPoint = RED_SECOND;
    ShowMessage("Mid to Second EVEN\n" +
                "RED must cap mid to win\n" +
                "BLU must cap second to win"
               );
}

function RedSecondToLastEven()
{
    pointState = RED_OWNS_SECOND;
    TeleportPlayers(TF_TEAM_RED, BLU_SECOND);
    GiveTeamUber(TF_TEAM_RED, UBER_AD_AMOUNT);
    GiveTeamUber(TF_TEAM_BLU, UBER_AD_AMOUNT);
    redObjPoint = BLU_LAST;
    bluObjPoint = BLU_SECOND;
    ShowMessage("Second to Last EVEN\n" +
                "RED must cap last to win\n" +
                "BLU must cap second to win"
               );
}

function BluSecondToLastEven()
{
    pointState = BLU_OWNS_SECOND;
    TeleportPlayers(TF_TEAM_BLU, RED_SECOND);
    GiveTeamUber(TF_TEAM_RED, UBER_AD_AMOUNT);
    GiveTeamUber(TF_TEAM_BLU, UBER_AD_AMOUNT);
    redObjPoint = RED_SECOND;
    bluObjPoint = RED_LAST;
    ShowMessage("Second to Last EVEN\n" +
                "RED must cap second to win\n" +
                "BLU must cap last to win"
               );
}

::GameStates <- {
    // last ad pushes
    "RedMidToLastAd"        : RedMidToLastAd,
    "BluMidToLastAd"        : BluMidToLastAd,
    "RedSecondToLastAd"     : RedSecondToLastAd,
    "BluSecondToLastAd"     : BluSecondToLastAd,
    
    // dry pushes
    "RedMidToLastDryAd"     : RedMidToLastDryAd,
    "BluMidToLastDryAd"     : BluMidToLastDryAd,
    "RedSecondToSecondDryAd": RedSecondToSecondDryAd,
    "BluSecondToSecondDryAd": BluSecondToSecondDryAd,

    // even states
    "RedMidToSecondEven"    : RedMidToSecondEven,
    "BluMidToSecondEven"    : BluMidToSecondEven,
    "RedSecondToLastEven"   : RedSecondToLastEven,
    "BluSecondToLastEven"   : BluSecondToLastEven
};


CollectEventsInScope
({
    function OnGameEvent_teamplay_round_start(params) {
        local gameState = GameStates.keys()[RandomInt(0, GameStates.keys().len() - 1)];

        printl("OnGameEvent_teamplay_round_start: Creating game state " + gameState + ".");
        GameStates[gameState]();
    }

    // cannot change cp ownership if round is not active, this is a workaround
    function OnGameEvent_teamplay_round_active(params) {
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
    }

    // runs 'mp_restartgame 5' whenever a objective point is capped
	function OnGameEvent_teamplay_point_captured(params) {
        // unnecessary if last is capped
        if (params.cp == 0 || params.cp == 4)
        {
            return;
        }

        // to prevent softlocking, teams can cap the objective point or any point "further" on
        if ((params.team == TF_TEAM_RED && params.cp <= redObjPoint) ||
            (params.team == TF_TEAM_BLU && params.cp >= bluObjPoint))
        {
            local psc = Entities.FindByClassname(null, "point_servercommand");
            if (psc == null)
            {
                printl("OnGameEvent_teamplay_point_captured: ERROR - no point_servercommand found.");
                return;
            }

            EntFireByHandle(psc, "Command", "mp_restartgame 5", 0.0, null, null);
            printl("OnGameEvent_teamplay_point_captured: An ObjPoint was capped, executing mp_restartgame 5.");
        }
    }
})

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
    }
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


// pointState corresponds to calling these since can't update cp's before round active
function RedOwnsMid() // 0
{
    CapPointForTeam(RED_LAST_ENT_NAME, RED);
    CapPointForTeam(RED_SECOND_ENT_NAME, RED);
    CapPointForTeam(MID_ENT_NAME, RED);

}

function RedOwnsSecond() // 1
{
    CapPointForTeam(RED_LAST_ENT_NAME, RED);
    CapPointForTeam(RED_SECOND_ENT_NAME, RED);
    CapPointForTeam(MID_ENT_NAME, RED);
    CapPointForTeam(BLU_SECOND_ENT_NAME, RED);
}

function BluOwnsMid() // 2
{
    CapPointForTeam(BLU_LAST_ENT_NAME, BLU);
    CapPointForTeam(BLU_SECOND_ENT_NAME, BLU);
    CapPointForTeam(MID_ENT_NAME, BLU);
}

function BluOwnsSecond() // 3
{
    CapPointForTeam(BLU_LAST_ENT_NAME, BLU);
    CapPointForTeam(BLU_SECOND_ENT_NAME, BLU);
    CapPointForTeam(MID_ENT_NAME, BLU);
    CapPointForTeam(RED_SECOND_ENT_NAME, BLU);
}

// there is probably a better way of doing this? this approach does not fire any events however
function CapPointForTeam(point, team)
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