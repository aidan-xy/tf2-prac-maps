const TF_TEAM_RED = 2;
const TF_TEAM_BLU = 3;

// indices of the control points
const BLU_LAST = 0;
const BLU_SECOND = 1;
const MID = 2;
const RED_SECOND = 3;
const RED_LAST = 4;

redObjPoint <- -1;
bluObjPoint <- MID;

// mid spawn points, arbitrarily chosen
// -2, 0, 552 = on point
// -153, 201, 808 = on blu crate
// 263, -200, 808 = on red crate
// -3, 10, 801 = middle of height
// -444, -359, 549 = near blue choke
// 434, 355, 546 = near red choke

function GetSpawnPositions(point) 
{
    switch (point)
    {
        case 2: // mid
            return [
                Vector(-2,    0,   552),  // point
                Vector(-153, 201,  808),  // blu crate
                Vector(263, -200,  808),  // red crate
                Vector(-3,   10,   801),  // middle height
                Vector(-444,-359,  549),  // near blue choke
                Vector(434, 355,   546)   // near red choke
            ];
        default: // either last, do not teleport            
            return [];
    }
}

function TeleportPlayers(team, point) 
{
    printl("TeleportPlayers: Teleporting players on team " + team + " to point " + point);
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
    function OnGameEvent_teamplay_round_start(params) {
        TeleportPlayers(TF_TEAM_BLU, MID);
    }

	function OnGameEvent_teamplay_point_captured(params) {
        // runs mp_restartgame 5 on point cap that is not last, unnecessary then
        if (params.cp == 0 || params.cp == 4) 
        {
            return;
        }
        
        // TODO: change logic to factor in team that capped
        if (params.cp == redObjPoint || params.cp == bluObjPoint)
        {
            local psc = Entities.FindByClassname(null, "point_servercommand");
            if (psc == null)
            {
                printl("OnGameEvent_teamplay_point_captured: ERROR - no point_servercommand found");
                return;
            }

            EntFireByHandle(psc, "Command", "mp_restartgame 5", 0.0, null, null);
            printl("OnGameEvent_teamplay_point_captured: ObjPoint capped, executing mp_restartgame 5");
        }
    }
})

// names of the actual entities in the map file
const RED = "2";
const BLU = "3";
const MID_ENT_NAME = "cp_3";
const RED_SECOND_ENT_NAME = "cp_red2";
const RED_LAST_ENT_NAME = "cp_red1";
const BLU_SECOND_ENT_NAME = "cp_blu2";
const BLU_LAST_ENT_NAME = "cp_blu1";

function RedOwnsMid()
{
    CapPointForTeam(RED_LAST_ENT_NAME, RED);
    CapPointForTeam(RED_SECOND_ENT_NAME, RED);
    CapPointForTeam(MID_ENT_NAME, RED);

}

function RedOwnsSecond()
{
    CapPointForTeam(RED_LAST_ENT_NAME, RED);
    CapPointForTeam(RED_SECOND_ENT_NAME, RED);
    CapPointForTeam(MID_ENT_NAME, RED);
    CapPointForTeam(BLU_SECOND_ENT_NAME, RED);
}

function BluOwnsMid()
{
    CapPointForTeam(BLU_LAST_ENT_NAME, BLU);
    CapPointForTeam(BLU_SECOND_ENT_NAME, BLU);
    CapPointForTeam(MID_ENT_NAME, BLU);
}

function BluOwnsSecond()
{
    CapPointForTeam(BLU_LAST_ENT_NAME, BLU);
    CapPointForTeam(BLU_SECOND_ENT_NAME, BLU);
    CapPointForTeam(MID_ENT_NAME, BLU);
    CapPointForTeam(RED_SECOND_ENT_NAME, BLU);
}

// there is probably a better way of doing this, however this approach does not fire any events
function CapPointForTeam(point, team)
{
    local cp = Entities.FindByName(null, point);
    if (cp != null)
    {
        EntFireByHandle(cp, "SetOwner", team, 0.0, null, null);
        printl("Set owner of " + point + " to " + team);
    }
    else
    {
        printl("CapPointForTeam: ERROR - Could not find point" + point);
    }
}