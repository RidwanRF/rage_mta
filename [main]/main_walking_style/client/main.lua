
local customBlockName = "gtav"
local IFP = engineLoadIFP( "assets/ifp/anim.ifp", customBlockName )

local list = { 'abseil' , 'ARRESTgun' , 'ATM' , 'batherdown' , 'batherscape' , 'batherup' , 'BIKE_elbowL' , 'BIKE_elbowR' , 'BIKE_fallR' , 'BIKE_fall_off' , 'BIKE_pickupL' , 'BIKE_pickupR' , 'BIKE_pullupL' , 'BIKE_pullupR' , 'bomber' , 'CAR_alignHI_LHS' , 'CAR_alignHI_RHS' , 'CAR_align_LHS' , 'CAR_align_RHS' , 'CAR_closedoorL_LHS' , 'CAR_closedoorL_RHS' , 'CAR_closedoor_LHS' , 'CAR_closedoor_RHS' , 'CAR_close_LHS' , 'CAR_close_RHS' , 'CAR_crawloutRHS' , 'CAR_doorlocked_LHS' , 'CAR_doorlocked_RHS' , 'CAR_getinL_LHS' , 'CAR_getinL_RHS' , 'CAR_getin_LHS' , 'CAR_getin_RHS' , 'CAR_getoutL_LHS' , 'CAR_getoutL_RHS' , 'CAR_getout_LHS' , 'CAR_getout_RHS' , 'car_hookertalk' , 'CAR_jackedLHS' , 'CAR_jackedRHS' , 'CAR_jumpin_LHS' , 'CAR_LB' , 'CAR_LjackedLHS' , 'CAR_LjackedRHS' , 'CAR_Lshuffle_RHS' , 'CAR_Lsit' , 'CAR_open_LHS' , 'CAR_open_RHS' , 'CAR_pulloutL_LHS' , 'CAR_pulloutL_RHS' , 'CAR_pullout_LHS' , 'CAR_pullout_RHS' , 'CAR_Qjack' , 'CAR_Qjacked' , 'CAR_rolldoor' , 'CAR_rolldoorLO' , 'CAR_rollout_LHS' , 'CAR_rollout_RHS' , 'CAR_shuffleLO' , 'CAR_shuffle_RHS' , 'CAR_sit' , 'CAR_sitp' , 'CAR_sitpLO' , 'cower' , 'DrivebyL_L' , 'DrivebyL_R' , 'Driveby_L' , 'Driveby_R' , 'DRIVE_BOAT' , 'DRIVE_BOAT_back' , 'DRIVE_BOAT_L' , 'DRIVE_BOAT_R' , 'Drive_L' , 'Drive_LO_l' , 'Drive_LO_R' , 'Drive_R' , 'Drown' , 'DUCK_down' , 'DUCK_low' , 'EV_dive' , 'EV_step' , 'FALL_back' , 'FALL_collapse' , 'FALL_fall' , 'FALL_front' , 'FALL_glide' , 'FALL_land' , 'FIGHT2IDLE' , 'FIGHTbkickL' , 'FIGHTbkickR' , 'FIGHTbodyblow' , 'FIGHTelbowL' , 'FIGHTelbowR' , 'FIGHThead' , 'FIGHTIDLE' , 'FIGHTjab' , 'FIGHTkick' , 'FIGHTknee' , 'FIGHTLhook' , 'FIGHTlngkck' , 'FIGHTppunch' , 'FIGHTpunch' , 'FIGHTrndhse' , 'FIGHTsh_back' , 'FIGHTsh_F' , 'FLOOR_hit' , 'FLOOR_hit_f' , 'fucku' , 'getup' , 'getup_front' , 'handscower' , 'handsup' , 'HIT_back' , 'HIT_behind' , 'HIT_bodyblow' , 'HIT_chest' , 'HIT_front' , 'HIT_head' , 'HIT_L' , 'HIT_R' , 'HIT_walk' , 'HIT_wall' , 'IDLE_armed' , 'IDLE_cam' , 'IDLE_chat' , 'IDLE_csaw' , 'IDLE_HBHB' , 'IDLE_ROCKET' , 'IDLE_stance' , 'IDLE_taxi' , 'IDLE_time' , 'IDLE_tired' , 'JOG_maleA' , 'JOG_maleB' , 'KD_left' , 'KD_right' , 'KICK_floor' , 'KO_shot_armL' , 'KO_shot_armR' , 'KO_shot_face' , 'KO_shot_front' , 'KO_shot_legL' , 'KO_shot_legR' , 'KO_shot_stom' , 'KO_skid_back' , 'KO_skid_front' , 'KO_spin_L' , 'KO_spin_R' , 'LIMP' , 'phone_in' , 'phone_out' , 'phone_talk' , 'pounds_A' , 'pounds_B' , 'PUNCHR' , 'RBLOCK_Cshoot' , 'roadcross' , 'run_1armed' , 'run_armed' , 'run_back' , 'run_civi' , 'run_csaw' , 'run_csaw_back' , 'run_csaw_left' , 'run_csaw_right' , 'run_fatold' , 'run_gang1' , 'run_left' , 'run_player' , 'run_right' , 'run_rocket' , 'run_rocket_back' , 'run_rocket_left' , 'run_rocket_right' , 'Run_stop' , 'Run_stopR' , 'SEAT_down' , 'SEAT_idle' , 'SEAT_rvrs' , 'SEAT_up' , 'SHOT_leftP' , 'SHOT_partial' , 'SHOT_rightP' , 'SLAPS_A' , 'SLAPS_B' , 'sprint_civi' , 'sprint_panic' , 'turn_180' , 'walkst_csaw_back' , 'walkst_csaw_left' , 'walkst_csaw_right' , 'walkst_rocket_back' , 'walkst_rocket_left' , 'walkst_rocket_right' , 'WALK_armed' , 'walk_back' , 'WALK_civi' , 'WALK_csaw' , 'walk_csaw_back' , 'walk_csaw_left' , 'walk_csaw_right' , 'WALK_fat' , 'WALK_fatold' , 'WALK_gang1' , 'WALK_gang2' , 'walk_left' , 'WALK_old' , 'WALK_player' , 'walk_right' , 'WALK_rocket' , 'walk_rocket_back' , 'walk_rocket_left' , 'walk_rocket_right' , 'WALK_shuffle' , 'WALK_start' , 'WALK_start_armed' , 'walk_start_back' , 'WALK_start_csaw' , 'walk_start_left' , 'walk_start_right' , 'WALK_start_rocket' , 'WEAPON_crouch' , 'WEAPON_throwu' , 'woman_idlestance' , 'woman_run' , 'woman_runpanic' , 'WOMAN_walkbusy' , 'WOMAN_walknorm' , 'WOMAN_walkold' , 'WOMAN_walksexy' , 'WOMAN_walkshop' , 'XPRESSscratch' }

function togglePlayerAnimation(player, flag)

	for _, anim in pairs( list ) do

		if flag then
			engineReplaceAnimation( player, "ped", anim, customBlockName, anim )
		else
			engineRestoreAnimation( player )
		end

	end

end

addEventHandler('onClientElementStreamIn', root, function()
	if source.type == 'player' then
		togglePlayerAnimation(source, source:getData('settings.walking_style'))
	end
end)

addEventHandler('onClientElementDataChange', root, function(dn, old, new)
	if source.type == 'player' and isElementStreamedIn(source) and dn == 'settings.walking_style' then
		togglePlayerAnimation(source, new)
	end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()

	for _, player in pairs( getElementsByType('player') ) do
		if isElementStreamedIn(player) then
			togglePlayerAnimation(player, player:getData('settings.walking_style'))
		end
	end

end)