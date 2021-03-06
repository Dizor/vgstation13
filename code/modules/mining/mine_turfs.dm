/**********************Mineral deposits**************************/

/datum/controller/game_controller
	var/list/artifact_spawning_turfs = list()

/turf/unsimulated/mineral //wall piece
	name = "Rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock"
	oxygen = 0
	nitrogen = 0
	opacity = 1
	density = 1
	blocks_air = 1
	//temperature = TCMB
	var/mineral/mineral
	var/mined_ore = 0
	var/last_act = 0
	var/datum/geosample/geologic_data
	var/excavation_level = 0
	var/list/finds = list()//no longer null to prevent those pesky runtime errors
//	var/next_rock = 0
	var/archaeo_overlay = ""
	var/excav_overlay = ""
	var/obj/item/weapon/last_find
	var/datum/artifact_find/artifact_find
	var/scan_state = null //Holder for the image we display when we're pinged by a mining scanner
	var/busy = 0 //Used for a bunch of do_after actions, because we can walk into the rock to trigger them

/turf/unsimulated/mineral/Destroy()
	return

/turf/unsimulated/mineral/New()
	. = ..()
	MineralSpread()

	spawn(1)
		var/turf/T
		if((istype(get_step(src, NORTH), /turf/simulated/floor)) || (istype(get_step(src, NORTH), /turf/space)) || (istype(get_step(src, NORTH), /turf/simulated/shuttle/floor)))
			T = get_step(src, NORTH)
			if (T)
				T.overlays += image('icons/turf/walls.dmi', "rock_side_s")
		if((istype(get_step(src, SOUTH), /turf/simulated/floor)) || (istype(get_step(src, SOUTH), /turf/space)) || (istype(get_step(src, SOUTH), /turf/simulated/shuttle/floor)))
			T = get_step(src, SOUTH)
			if (T)
				T.overlays += image('icons/turf/walls.dmi', "rock_side_n", layer=6)
		if((istype(get_step(src, EAST), /turf/simulated/floor)) || (istype(get_step(src, EAST), /turf/space)) || (istype(get_step(src, EAST), /turf/simulated/shuttle/floor)))
			T = get_step(src, EAST)
			if (T)
				T.overlays += image('icons/turf/walls.dmi', "rock_side_w", layer=6)
		if((istype(get_step(src, WEST), /turf/simulated/floor)) || (istype(get_step(src, WEST), /turf/space)) || (istype(get_step(src, WEST), /turf/simulated/shuttle/floor)))
			T = get_step(src, WEST)
			if (T)
				T.overlays += image('icons/turf/walls.dmi', "rock_side_e", layer=6)
	/*
	if (mineralName && mineralAmt && spread && spreadChance)
		for(var/trydir in list(1,2,4,8))
			if(prob(spreadChance))
				if(istype(get_step(src, trydir), /turf/unsimulated/mineral/random))
					var/turf/unsimulated/mineral/T = get_step(src, trydir)
					var/turf/unsimulated/mineral/M = new src.type(T)
					//keep any digsite data as constant as possible
					if(T.finds.len && !M.finds.len)
						M.finds = T.finds
						if(T.archaeo_overlay)
							M.overlays += archaeo_overlay


	//---- Xenoarchaeology BEGIN

	//put into spawn so that digsite data can be preserved over the turf replacements via spreading mineral veins
	spawn(0)
		if(mineralAmt > 0 && !excavation_minerals.len)
			for(var/i=0, i<mineralAmt, i++)
				excavation_minerals.Add(rand(5,95))
			excavation_minerals = insertion_sort_numeric_list_descending(excavation_minerals)

		if(!finds.len && prob(XENOARCH_SPAWN_CHANCE))
			//create a new archaeological deposit
			var/digsite = get_random_digsite_type()

			var/list/turfs_to_process = list(src)
			var/list/processed_turfs = list()
			while(turfs_to_process.len)
				var/turf/unsimulated/mineral/M = turfs_to_process[1]
				for(var/turf/unsimulated/mineral/T in orange(1, M))
					if(T.finds.len)
						continue
					if(T in processed_turfs)
						continue
					if(prob(XENOARCH_SPREAD_CHANCE))
						turfs_to_process.Add(T)

				turfs_to_process.Remove(M)
				processed_turfs.Add(M)
				if(!M.finds.len)
					if(prob(50))
						M.finds.Add(new/datum/find(digsite, rand(5,95)))
					else if(prob(75))
						M.finds.Add(new/datum/find(digsite, rand(5,45)))
						M.finds.Add(new/datum/find(digsite, rand(55,95)))
					else
						M.finds.Add(new/datum/find(digsite, rand(5,30)))
						M.finds.Add(new/datum/find(digsite, rand(35,75)))
						M.finds.Add(new/datum/find(digsite, rand(75,95)))

					//sometimes a find will be close enough to the surface to show
					var/datum/find/F = M.finds[1]
					if(F.excavation_required <= F.view_range)
						archaeo_overlay = "overlay_archaeo[rand(1,3)]"
						M.overlays += archaeo_overlay

			//dont create artifact machinery in animal or plant digsites, or if we already have one
			if(!artifact_find && digsite != 1 && digsite != 2 && prob(ARTIFACT_SPAWN_CHANCE))
				artifact_find = new()
				artifact_spawning_turfs.Add(src)

		if(!src.geological_data)
			src.geological_data = new/datum/geosample(src)
		src.geological_data.UpdateTurf(src)

		//for excavated turfs placeable in the map editor
		/*if(excavation_level > 0)
			if(excavation_level < 25)
				src.overlays += image('icons/obj/xenoarchaeology.dmi', "overlay_excv1_[rand(1,3)]")
			else if(excavation_level < 50)
				src.overlays += image('icons/obj/xenoarchaeology.dmi', "overlay_excv2_[rand(1,3)]")
			else if(excavation_level < 75)
				src.overlays += image('icons/obj/xenoarchaeology.dmi', "overlay_excv3_[rand(1,3)]")
			else
				src.overlays += image('icons/obj/xenoarchaeology.dmi', "overlay_excv4_[rand(1,3)]")
			desc = "It appears to be partially excavated."*/

	return
	*/

/turf/unsimulated/mineral/ex_act(severity)
	switch(severity)
		if(3.0)
			if (prob(75))
				GetDrilled()
		if(2.0)
			if (prob(90))
				GetDrilled()
		if(1.0)
			GetDrilled()


/turf/unsimulated/mineral/Bumped(AM)
	. = ..()
	if(istype(AM,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = AM
		if(istype(H.get_active_hand(),/obj/item/weapon/pickaxe))
			attackby(H.get_active_hand(), H)
		else if(istype(H.get_inactive_hand(),/obj/item/weapon/pickaxe))
			attackby(H.get_inactive_hand(), H)

	else if(istype(AM,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active,/obj/item/weapon/pickaxe))
			attackby(R.module_active, R)

	else if(istype(AM,/obj/mecha))
		var/obj/mecha/M = AM
		if(istype(M.selected,/obj/item/mecha_parts/mecha_equipment/tool/drill))
			M.selected.action(src)

/turf/unsimulated/mineral/proc/MineralSpread()
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/unsimulated/mineral/proc/MineralSpread() called tick#: [world.time]")
	if(mineral && mineral.spread)
		for(var/trydir in cardinal)
			if(prob(mineral.spread_chance))
				var/turf/unsimulated/mineral/random/target_turf = get_step(src, trydir)
				if(istype(target_turf) && !target_turf.mineral)
					target_turf.mineral = mineral
					target_turf.UpdateMineral()
					target_turf.MineralSpread()

/turf/unsimulated/mineral/proc/UpdateMineral()
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/unsimulated/mineral/proc/UpdateMineral() called tick#: [world.time]")
	icon_state = "rock"
	if(!mineral)
		name = "\improper Rock"
		return
	name = "\improper [mineral.display_name] deposit"
	icon_state = "rock_[mineral.name]"

/turf/unsimulated/mineral/proc/updateMineralOverlays()
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/unsimulated/mineral/proc/updateMineralOverlays() called tick#: [world.time]")
	// TODO: Figure out what this is supposed to do.
	return

/turf/unsimulated/mineral/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(busy)
		return

	if (!usr.dexterity_check())
		usr << "<span class='warning>You don't have the dexterity to do this!</span>"
		return

	if (istype(W, /obj/item/device/core_sampler))
		if(!geologic_data)
			geologic_data = new/datum/geosample(src)
		geologic_data.UpdateNearbyArtifactInfo(src)
		var/obj/item/device/core_sampler/C = W
		C.sample_item(src, user)
		return

	if (istype(W, /obj/item/device/depth_scanner))
		var/obj/item/device/depth_scanner/C = W
		C.scan_atom(user, src)
		return

	if (istype(W, /obj/item/device/measuring_tape))
		var/obj/item/device/measuring_tape/P = W
		user.visible_message("<span class='notice'>[user] extends [P] towards [src].</span>","<span class='notice'>You extend [P] towards [src].</span>")
		busy = 1
		if(do_after(user, src,25))
			user << "<span class='notice'>\icon[P] [src] has been excavated to a depth of [2*excavation_level]cm.</span>"
			busy = 0
		else
			busy = 0
		return

	if (istype(W, /obj/item/weapon/pickaxe))
		if(user.loc != get_turf(user))
			return //if we aren't in the tile we are located in, return

		var/obj/item/weapon/pickaxe/P = W

		if(!istype(P))
			return

		if(!(P.diggables & DIG_ROCKS))
			return

		if(last_act + P.digspeed > world.time)//prevents message spam
			return

		last_act = world.time

		playsound(user, P.drill_sound, 20, 1)

		//handle any archaeological finds we might uncover
		var/fail_message = ""
		if(finds && finds.len)
			var/datum/find/F = finds[1]
			if(excavation_level + P.excavation_amount > F.excavation_required)

				fail_message = ", <b>[pick("there is a crunching noise","[W] collides with some different rock","part of the rock face crumbles away","something breaks under [W]")]</b>"

		user << "<span class='rose'>You start [P.drill_verb][fail_message].</span>"

		if(fail_message && prob(90))
			if(prob(25))
				excavate_find(5, finds[1])
			else if(prob(50))
				finds.Remove(finds[1])
				if(prob(50))
					artifact_debris()

		busy = 1

		if(do_after(user, src, P.digspeed) && user)
			user << "<span class='notice'>You finish [P.drill_verb] the rock.</span>"

			busy = 0

			if(finds && finds.len)
				var/datum/find/F = finds[1]
				if(round(excavation_level + P.excavation_amount) == F.excavation_required)

					if(excavation_level + P.excavation_amount > F.excavation_required)

						excavate_find(100, F)
					else
						excavate_find(80, F)

				else if(excavation_level + P.excavation_amount > F.excavation_required - F.clearance_range)

					excavate_find(0, F)

			if( excavation_level + P.excavation_amount >= 100 )

				var/obj/structure/boulder/B
				if(artifact_find)
					if( excavation_level > 0 || prob(15) )

						B = getFromPool(/obj/structure/boulder, src)
						if(artifact_find)
							B.artifact_find = artifact_find
					else
						artifact_debris(1)

				else if(prob(15))
					B = getFromPool(/obj/structure/boulder, src)

				var/mineral/has_minerals = mineral
				if(B)
					GetDrilled(0)
				else
					GetDrilled(1)

				if(!B && !has_minerals)
					var/I = rand(1,500)
					if(I == 1)
						switch(polarstar)
							if(0)
								new/obj/item/weapon/gun/energy/polarstar(src)
								polarstar = 1
								visible_message("<span class='notice'>A gun was buried within!</span>")
							if(1)
								new/obj/item/device/modkit/spur_parts(src)
								visible_message("<span class='notice'>Something came out of the wall! Looks like scrap metal.</span>")
								polarstar = 2
				return

			if(finds && finds.len)
				var/I = rand(1,100)
				if(I == 1)
					switch(polarstar)
						if(0)
							new/obj/item/weapon/gun/energy/polarstar(src)
							polarstar = 1
							visible_message("<span class='notice'>A gun was buried within!</span>")
						if(1)
							new/obj/item/device/modkit/spur_parts(src)
							visible_message("<span class='notice'>Something came out of the wall! Looks like scrap metal.</span>")
							polarstar = 2

			excavation_level += P.excavation_amount

			if(!archaeo_overlay && finds && finds.len)
				var/datum/find/F = finds[1]
				if(F.excavation_required <= excavation_level + F.view_range)
					archaeo_overlay = "overlay_archaeo[rand(1,3)]"
					overlays += archaeo_overlay

			var/update_excav_overlay = 0

			var/subtractions = 0
			while(excavation_level - 25*(subtractions + 1) >= 0 && subtractions < 3)
				subtractions++
			if(excavation_level - P.excavation_amount < subtractions * 25)
				update_excav_overlay = 1

			//update overlays displaying excavation level
			if( !(excav_overlay && excavation_level > 0) || update_excav_overlay )
				var/excav_quadrant = round(excavation_level / 25) + 1
				excav_overlay = "overlay_excv[excav_quadrant]_[rand(1,3)]"
				overlays += excav_overlay
/*
			//drop some rocks
			next_rock += P.excavation_amount * 10
			while(next_rock > 100)
				next_rock -= 100
				var/obj/item/weapon/ore/O = new(src)
				if(!geologic_data)
					geologic_data = new/datum/geosample(src)
				geologic_data.UpdateNearbyArtifactInfo(src)
				O.geologic_data = geologic_data
*/

		else //Note : If the do_after() fails
			busy = 0

	else
		return attack_hand(user)

/turf/unsimulated/mineral/proc/DropMineral()
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/unsimulated/mineral/proc/DropMineral() called tick#: [world.time]")
	if(!mineral)
		return

	var/obj/item/weapon/ore/O = new mineral.ore (src)
	if(istype(O))
		if(!geologic_data)
			geologic_data = new/datum/geosample(src)
		geologic_data.UpdateNearbyArtifactInfo(src)
		O.geologic_data = geologic_data
	return O

/turf/unsimulated/mineral/proc/GetDrilled(var/artifact_fail = 0)
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/unsimulated/mineral/proc/GetDrilled() called tick#: [world.time]")
	if (mineral && mineral.result_amount)
		for (var/i = 1 to mineral.result_amount - mined_ore)
			DropMineral()

	//destroyed artifacts have weird, unpleasant effects
	//make sure to destroy them before changing the turf though
	if(artifact_find && artifact_fail)
		for(var/mob/living/M in range(src, 200))
			M << "<font color='red'><b>[pick("A high pitched [pick("keening","wailing","whistle")]","A rumbling noise like [pick("thunder","heavy machinery")]")] somehow penetrates your mind before fading away!</b></font>"
			if(prob(50)) //pain
				flick("pain",M.pain)
				if(prob(50))
					M.adjustBruteLoss(5)
			else
				flick("flash",M.flash)
				if(prob(50))
					M.Stun(5)
			M.apply_effect(25, IRRADIATE)

	if(rand(1,500) == 1)
		visible_message("<span class='notice'>An old dusty crate was buried within!</span>")
		DropAbandonedCrate()

	var/turf/unsimulated/floor/asteroid/N = ChangeTurf(/turf/unsimulated/floor/asteroid)
	N.fullUpdateMineralOverlays()

/turf/unsimulated/mineral/proc/DropAbandonedCrate()
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/unsimulated/mineral/proc/DropAbandonedCrate() called tick#: [world.time]")
	var/crate_type = pick(valid_abandoned_crate_types)
	new crate_type(src)

/turf/unsimulated/mineral/proc/excavate_find(var/prob_clean = 0, var/datum/find/F)
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/unsimulated/mineral/proc/excavate_find() called tick#: [world.time]")
	//with skill and luck, players can cleanly extract finds
	//otherwise, they come out inside a chunk of rock
	var/obj/item/weapon/X
	if(prob_clean)
		X = new /obj/item/weapon/archaeological_find(src, new_item_type = F.find_type)
	else
		X = new /obj/item/weapon/strangerock(src, inside_item_type = F.find_type)
		if(!geologic_data)
			geologic_data = new/datum/geosample(src)
		geologic_data.UpdateNearbyArtifactInfo(src)
		X:geologic_data = geologic_data

	//some find types delete the /obj/item/weapon/archaeological_find and replace it with something else, this handles when that happens
	//yuck
	var/display_name = "something"
	if(!X)
		X = last_find
	if(X)
		display_name = X.name

	//many finds are ancient and thus very delicate - luckily there is a specialised energy suspension field which protects them when they're being extracted
	if(prob(F.prob_delicate))
		var/obj/effect/suspension_field/S = locate() in src
		if(!S || S.field_type != get_responsive_reagent(F.find_type))
			if(X)
				visible_message("<span class='danger'>[pick("[display_name] crumbles away into dust","[display_name] breaks apart")].</span>")
				del(X)

	finds.Remove(F)

/turf/unsimulated/mineral/proc/artifact_debris(var/severity = 0)
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/unsimulated/mineral/proc/artifact_debris() called tick#: [world.time]")
	for(var/j in 1 to rand(1, 3 + max(min(severity, 1), 0) * 2))
		switch(rand(1,7))
			if(1)
				var/obj/item/stack/rods/R = new(src)
				R.amount = rand(5,25)

			if(2)
				var/obj/item/stack/tile/R = new(src)
				R.amount = rand(1,5)

			if(3)
				var/obj/item/stack/sheet/metal/M = getFromPool(/obj/item/stack/sheet/metal, (src))
				M.amount = rand(5,25)

			if(4)
				var/obj/item/stack/sheet/plasteel/R = new(src)
				R.amount = rand(5,25)

			if(5)
				var/quantity = rand(1,3)
				for(var/i=0, i<quantity, i++)
					getFromPool(/obj/item/weapon/shard, loc)

			if(6)
				var/quantity = rand(1,3)
				for(var/i=0, i<quantity, i++)
					getFromPool(/obj/item/weapon/shard/plasma, loc)

			if(7)
				var/obj/item/stack/sheet/mineral/uranium/R = new(src)
				R.amount = rand(5,25)


/**********************Asteroid**************************/

/turf/unsimulated/floor/airless //floor piece
	oxygen = 0.01
	nitrogen = 0.01
	temperature = TCMB

/turf/unsimulated/floor/asteroid //floor piece
	name = "Asteroid"
	icon = 'icons/turf/floors.dmi'
	icon_state = "asteroid"
	oxygen = 0.01
	nitrogen = 0.01
	temperature = TCMB
	//icon_plating = "asteroid"
	var/dug = 0       //0 = has not yet been dug, 1 = has already been dug

/turf/unsimulated/floor/asteroid/New()
	var/proper_name = name
	..()

	name = proper_name

	if(prob(20))
		icon_state = "asteroid[rand(0,12)]"
	updateMineralOverlays()

/turf/unsimulated/floor/asteroid/ex_act(severity)
	switch(severity)
		if(3.0)
			return
		if(2.0)
			if (prob(70))
				gets_dug()
		if(1.0)
			gets_dug()
	return

/turf/unsimulated/floor/asteroid/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(!W || !user)
		return 0

	if (istype(W, /obj/item/weapon/pickaxe))
		var/obj/item/weapon/pickaxe/used_digging = W //cast for dig speed and flags
		if (get_turf(user) != user.loc) //if we aren't somehow on the turf we're in
			return

		if(!(used_digging.diggables & DIG_SOIL)) //if the pickaxe can't dig soil, we don't
			user << "<span class='rose'>You can't dig soft soil with \the [W].</span>"
			return

		if (dug)
			user << "<span class='rose'>This area has already been dug.</span>"
			return

		user << "<span class='rose'>You start digging.<span>"
		playsound(get_turf(src), 'sound/effects/rustle1.ogg', 50, 1) //russle sounds sounded better

		if(do_after(user, used_digging.digspeed) && user) //the better the drill, the faster the digging
			playsound(loc, 'sound/items/shovel.ogg', 50, 1)
			user << "<span class='notice'>You dug a hole.</span>"
			gets_dug()

	else
		..(W,user)
	return

/turf/unsimulated/floor/asteroid/proc/gets_dug()
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/unsimulated/floor/asteroid/proc/gets_dug() called tick#: [world.time]")
	if(dug)
		return
	new/obj/item/weapon/ore/glass(src)
	new/obj/item/weapon/ore/glass(src)
	new/obj/item/weapon/ore/glass(src)
	new/obj/item/weapon/ore/glass(src)
	new/obj/item/weapon/ore/glass(src)
	dug = 1
	//icon_plating = "asteroid_dug"
	icon_state = "asteroid_dug"
	return

/turf/unsimulated/floor/asteroid/proc/updateMineralOverlays()
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/unsimulated/floor/asteroid/proc/updateMineralOverlays() called tick#: [world.time]")
	src.overlays.len = 0

	if(istype(get_step(src, NORTH), /turf/unsimulated/mineral))
		src.overlays += image('icons/turf/walls.dmi', "rock_side_n")
	if(istype(get_step(src, SOUTH), /turf/unsimulated/mineral))
		src.overlays += image('icons/turf/walls.dmi', "rock_side_s", layer=6)
	if(istype(get_step(src, EAST), /turf/unsimulated/mineral))
		src.overlays += image('icons/turf/walls.dmi', "rock_side_e", layer=6)
	if(istype(get_step(src, WEST), /turf/unsimulated/mineral))
		src.overlays += image('icons/turf/walls.dmi', "rock_side_w", layer=6)

/turf/unsimulated/floor/asteroid/proc/fullUpdateMineralOverlays()
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/unsimulated/floor/asteroid/proc/fullUpdateMineralOverlays() called tick#: [world.time]")
	var/turf/unsimulated/floor/asteroid/A
	if(istype(get_step(src, WEST), /turf/unsimulated/floor/asteroid))
		A = get_step(src, WEST)
		A.updateMineralOverlays()
	if(istype(get_step(src, EAST), /turf/unsimulated/floor/asteroid))
		A = get_step(src, EAST)
		A.updateMineralOverlays()
	if(istype(get_step(src, NORTH), /turf/unsimulated/floor/asteroid))
		A = get_step(src, NORTH)
		A.updateMineralOverlays()
	if(istype(get_step(src, NORTHWEST), /turf/unsimulated/floor/asteroid))
		A = get_step(src, NORTHWEST)
		A.updateMineralOverlays()
	if(istype(get_step(src, NORTHEAST), /turf/unsimulated/floor/asteroid))
		A = get_step(src, NORTHEAST)
		A.updateMineralOverlays()
	if(istype(get_step(src, SOUTHWEST), /turf/unsimulated/floor/asteroid))
		A = get_step(src, SOUTHWEST)
		A.updateMineralOverlays()
	if(istype(get_step(src, SOUTHEAST), /turf/unsimulated/floor/asteroid))
		A = get_step(src, SOUTHEAST)
		A.updateMineralOverlays()
	if(istype(get_step(src, SOUTH), /turf/unsimulated/floor/asteroid))
		A = get_step(src, SOUTH)
		A.updateMineralOverlays()
	src.updateMineralOverlays()

/turf/unsimulated/mineral/random
	name = "Mineral deposit"
	var/mineralSpawnChanceList = list(
		"Iron"      = 50,
		"Plasma"    = 25,
		"Uranium"   = 5,
		"Gold"      = 5,
		"Silver"    = 5,
		"Gibtonite" = 5,
		"Diamond"   = 1,
		"Cave"      = 1,
		/*
		"Pharosium"  = 5,
		"Char"  = 5,
		"Claretine"  = 5,
		"Bohrum"  = 5,
		"Syreline"  = 5,
		"Erebite"  = 5,
		"Uqill"  = 5,
		"Telecrystal"  = 5,
		"Mauxite"  = 5,
		"Cobryl"  = 5,
		"Cerenkite"  = 5,
		"Molitz"  = 5,
		"Cytine"  = 5
		*/
	)
	//Currently, Adamantine won't spawn as it has no uses. -Durandan
	var/mineralChance = 10  //means 10% chance of this plot changing to a mineral deposit

/turf/unsimulated/mineral/random/New()
	icon_state = "rock"
	if (prob(mineralChance) && !mineral)
		var/mineral_name = pickweight(mineralSpawnChanceList) //temp mineral name

		if(!name_to_mineral)
			SetupMinerals()

		if (mineral_name)
			if(mineral_name in name_to_mineral)
				mineral = name_to_mineral[mineral_name]
				mineral.UpdateTurf(src)
			else
				warning("Unknown mineral ID: [mineral_name]")

	. = ..()

/turf/unsimulated/mineral/random/high_chance
	icon_state = "rock(high)"
	mineralChance = 25
	mineralSpawnChanceList = list(
		"Uranium" = 10,
		"Iron"    = 30,
		"Diamond" = 2,
		"Gold"    = 10,
		"Silver"  = 10,
		"Plasma"  = 25,
		/*
		"Pharosium"  = 5,
		"Char"  = 5,
		"Claretine"  = 5,
		"Bohrum"  = 5,
		"Syreline"  = 5,
		"Erebite"  = 5,
		"Uqill"  = 5,
		"Telecrystal"  = 5,
		"Mauxite"  = 5,
		"Cobryl"  = 5,
		"Cerenkite"  = 5,
		"Molitz"  = 5,
		"Cytine"  = 5
		*/
	)

/turf/unsimulated/mineral/random/high_chance_clown
	icon_state = "rock(clown)"
	mineralChance = 40
	mineralSpawnChanceList = list(
		"Uranium" = 10,
		//"Iron"    = 10,
		"Diamond" = 2,
		"Gold"    = 5,
		"Silver"  = 5,
		/*
		"Pharosium"  = 1,
		"Char"  = 1,
		"Claretine"  = 1,
		"Bohrum"  = 1,
		"Syreline"  = 1,
		"Erebite"  = 1,
		"Uqill"  = 1,
		"Telecrystal"  = 1,
		"Mauxite"  = 1,
		"Cobryl"  = 1,
		"Cerenkite"  = 1,
		"Molitz"  = 1,
		"Cytine"  = 1,
		*/
		"Plasma"  = 25,
		"Clown"   = 15,
		"Phazon"  = 10
	)

/turf/unsimulated/mineral/random/Destroy()
	return

/turf/unsimulated/mineral/uranium
	name = "Uranium deposit"
	icon_state = "rock_Uranium"
	mineral = new /mineral/uranium
	scan_state = "rock_Uranium"


/turf/unsimulated/mineral/iron
	name = "Iron deposit"
	icon_state = "rock_Iron"
	mineral = new /mineral/iron


/turf/unsimulated/mineral/diamond
	name = "Diamond deposit"
	icon_state = "rock_Diamond"
	mineral = new /mineral/diamond
	scan_state = "rock_Diamond"


/turf/unsimulated/mineral/gold
	name = "Gold deposit"
	icon_state = "rock_Gold"
	mineral = new /mineral/gold
	scan_state = "rock_Gold"


/turf/unsimulated/mineral/silver
	name = "Silver deposit"
	icon_state = "rock_Silver"
	mineral = new /mineral/silver
	scan_state = "rock_Silver"


/turf/unsimulated/mineral/plasma
	name = "Plasma deposit"
	icon_state = "rock_Plasma"
	mineral = new /mineral/plasma
	scan_state = "rock_Plasma"


/turf/unsimulated/mineral/clown
	name = "Bananium deposit"
	icon_state = "rock_Clown"
	mineral = new /mineral/clown
	scan_state = "rock_Clown"


/turf/unsimulated/mineral/phazon
	name = "Phazite deposit"
	icon_state = "rock_Phazon"
	mineral = new /mineral/phazon
	scan_state = "rock_Phazon"

/turf/unsimulated/mineral/pharosium
	name = "Pharosium deposit"
	icon_state = "rock_Pharosium"
	mineral = new /mineral/pharosium

/turf/unsimulated/mineral/char
	name = "Char deposit"
	icon_state = "rock_Char"
	mineral = new /mineral/char

/turf/unsimulated/mineral/claretine
	name = "Claretine deposit"
	icon_state = "rock_Claretine"
	mineral = new /mineral/claretine

/turf/unsimulated/mineral/bohrum
	name = "Bohrum deposit"
	icon_state = "rock_Bohrum"
	mineral = new /mineral/bohrum

/turf/unsimulated/mineral/syreline
	name = "Syreline deposit"
	icon_state = "rock_Syreline"
	mineral = new /mineral/syreline

/turf/unsimulated/mineral/erebite
	name = "Erebite deposit"
	icon_state = "rock_Erebite"
	mineral = new /mineral/erebite

/turf/unsimulated/mineral/cytine
	name = "Cytine deposit"
	icon_state = "rock_Cytine"
	mineral = new /mineral/cytine

/turf/unsimulated/mineral/uqill
	name = "Uqill deposit"
	icon_state = "rock_Uqill"
	mineral = new /mineral/uqill

/turf/unsimulated/mineral/telecrystal
	name = "Telecrystal deposit"
	icon_state = "rock_Telecrystal"
	mineral = new /mineral/telecrystal

/turf/unsimulated/mineral/mauxite
	name = "Mauxite deposit"
	icon_state = "rock_Mauxite"
	mineral = new /mineral/mauxite

/turf/unsimulated/mineral/cobryl
	name = "Cobryl deposit"
	icon_state = "rock_Cobryl"
	mineral = new /mineral/cobryl

/turf/unsimulated/mineral/cerenkite
	name = "Cerenkite deposit"
	icon_state = "rock_Cerenkite"
	mineral = new /mineral/cerenkite

/turf/unsimulated/mineral/molitz
	name = "Molitz deposit"
	icon_state = "rock_Molitz"
	mineral = new /mineral/molitz

////////////////////////////////Gibtonite
/turf/unsimulated/mineral/gibtonite
	name = "Diamond deposit" //honk
	icon_state = "rock_Gibtonite"
	mineral = new /mineral/gibtonite
	scan_state = "rock_Gibtonite"
	var/det_time = 8 //Countdown till explosion, but also rewards the player for how close you were to detonation when you defuse it
	var/stage = 0 //How far into the lifecycle of gibtonite we are, 0 is untouched, 1 is active and attempting to detonate, 2 is benign and ready for extraction
	var/activated_ckey = null //These are to track who triggered the gibtonite deposit for logging purposes
	var/activated_name = null

/turf/unsimulated/mineral/gibtonite/New()
	icon_state="rock_Diamond"
	det_time = rand(8,10) //So you don't know exactly when the hot potato will explode
	..()

/turf/unsimulated/mineral/gibtonite/Bumped(AM)
	var/bump_reject = 0
	if(istype(AM,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = AM
		if((istype(H.get_active_hand(),/obj/item/weapon/pickaxe) || istype(H.get_inactive_hand(),/obj/item/weapon/pickaxe)) && src.stage == 1)
			H << "<span class='warning'>You don't think that's a good idea...</span>"
			bump_reject = 1

	else if(istype(AM,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active, /obj/item/weapon/pickaxe))
			R << "<span class='warning'>You don't think that's a good idea...</span>"
			bump_reject = 1
		else if(istype(R.module_active, /obj/item/device/mining_scanner))
			attackby(R.module_active, R) //let's bump to disable. This is kinder, because borgs need some love

	else if(istype(AM,/obj/mecha))
		var/obj/mecha/M = AM
		if(istype(M.selected, /obj/item/mecha_parts/mecha_equipment/tool/drill))
			M.occupant_message("<span class='warning'>Safety features prevent this action.</span>")
			bump_reject = 1

	if(!bump_reject) //if we haven't been pushed off, we do the drilling bit
		return ..()

/turf/unsimulated/mineral/gibtonite/attackby(obj/item/I, mob/user)
	if(((istype(I, /obj/item/device/mining_scanner)) || (istype(I, /obj/item/device/depth_scanner))) && stage == 1)
		user.visible_message("<span class='notice'>You use [I] to locate where to cut off the chain reaction and attempt to stop it...</span>")
		defuse()
	if(istype(I, /obj/item/weapon/pickaxe))
		src.activated_ckey = "[user.ckey]"
		src.activated_name = "[user.name]"
	..()

/turf/unsimulated/mineral/gibtonite/proc/explosive_reaction()
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/unsimulated/mineral/gibtonite/proc/explosive_reaction() called tick#: [world.time]")
	if(stage == 0)
		icon_state = "rock_Gibtonite_active"
		name = "Gibtonite deposit"
		desc = "An active gibtonite reserve. Run!"
		stage = 1
		visible_message("<span class='warning'>There was gibtonite inside! It's going to explode!</span>")
		var/turf/bombturf = get_turf(src)
		var/area/A = get_area(bombturf)
		var/log_str = "[src.activated_ckey]<A HREF='?_src_=holder;adminmoreinfo=\ref[usr]'>?</A> [src.activated_name] has triggered a gibtonite deposit reaction <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[bombturf.x];Y=[bombturf.y];Z=[bombturf.z]'>[A.name] (JMP)</a>."
		log_game(log_str)
		countdown()

/turf/unsimulated/mineral/gibtonite/proc/countdown()
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/unsimulated/mineral/gibtonite/proc/countdown() called tick#: [world.time]")
	spawn(0)
		while(stage == 1 && det_time > 0 && mineral.result_amount >= 1)
			det_time--
			sleep(5)
		if(stage == 1 && det_time <= 0 && mineral.result_amount >= 1)
			var/turf/bombturf = get_turf(src)
			mineral.result_amount = 0
			explosion(bombturf,1,3,5, adminlog = 0)
		if(stage == 0 || stage == 2)
			return

/turf/unsimulated/mineral/gibtonite/proc/defuse()
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/unsimulated/mineral/gibtonite/proc/defuse() called tick#: [world.time]")
	if(stage == 1)
		icon_state = "rock_Gibtonite" //inactive does not exist. The other icon is active.
		desc = "An inactive gibtonite reserve. The ore can be extracted."
		stage = 2
		if(det_time < 0)
			det_time = 0
		visible_message("<span class='notice'>The chain reaction was stopped! The gibtonite had [src.det_time] reactions left till the explosion!</span>")

/turf/unsimulated/mineral/gibtonite/GetDrilled()
	if(stage == 0 && mineral.result_amount >= 1) //Gibtonite deposit is activated
		playsound(src,'sound/effects/hit_on_shattered_glass.ogg',50,1)
		explosive_reaction()
		return
	if(stage == 1 && mineral.result_amount >= 1) //Gibtonite deposit goes kaboom
		var/turf/bombturf = get_turf(src)
		mineral.result_amount = 0
		explosion(bombturf,1,2,5, adminlog = 0)
	if(stage == 2) //Gibtonite deposit is now benign and extractable. Depending on how close you were to it blowing up before defusing, you get better quality ore.
		var/obj/item/weapon/gibtonite/G = new /obj/item/weapon/gibtonite/(src)
		if(det_time <= 0)
			G.quality = 3
			G.icon_state = "Gibtonite ore 3"
		if(det_time >= 1 && det_time <= 2)
			G.quality = 2
			G.icon_state = "Gibtonite ore 2"
	var/turf/unsimulated/floor/asteroid/gibtonite_remains/G = ChangeTurf(/turf/unsimulated/floor/asteroid/gibtonite_remains)
	G.fullUpdateMineralOverlays()

/turf/unsimulated/floor/asteroid/gibtonite_remains
	var/det_time = 0
	var/stage = 0

////////////////////////////////End Gibtonite

/turf/unsimulated/floor/asteroid/cave
	var/length = 100
	var/mob_spawn_list = list(
		/mob/living/simple_animal/hostile/asteroid/goliath  = 5,
		/mob/living/simple_animal/hostile/asteroid/goldgrub = 1,
		/mob/living/simple_animal/hostile/asteroid/basilisk = 3,
		/mob/living/simple_animal/hostile/asteroid/hivelord = 5
	)
	var/sanity = 1

/turf/unsimulated/floor/asteroid/cave/New(loc, var/length, var/go_backwards = 1, var/exclude_dir = -1)

	// If length (arg2) isn't defined, get a random length; otherwise assign our length to the length arg.
	if(!length)
		src.length = rand(25, 50)
	else
		src.length = length

	// Get our directiosn
	var/forward_cave_dir = pick(alldirs - exclude_dir)
	// Get the opposite direction of our facing direction
	var/backward_cave_dir = angle2dir(dir2angle(forward_cave_dir) + 180)

	// Make our tunnels
	make_tunnel(forward_cave_dir)
	if(go_backwards)
		make_tunnel(backward_cave_dir)
	// Kill ourselves by replacing ourselves with a normal floor.
	SpawnFloor(src)
	..()

/turf/unsimulated/floor/asteroid/cave/proc/make_tunnel(var/dir)

	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/unsimulated/floor/asteroid/cave/proc/make_tunnel() called tick#: [world.time]")

	var/turf/unsimulated/mineral/tunnel = src
	var/next_angle = pick(45, -45)

	for(var/i = 0; i < length; i++)
		if(!sanity)
			break

		var/list/L = list(45)
		if(IsOdd(dir2angle(dir))) // We're going at an angle and we want thick angled tunnels.
			L += -45

		// Expand the edges of our tunnel
		for(var/edge_angle in L)
			var/turf/unsimulated/mineral/edge = get_step(tunnel, angle2dir(dir2angle(dir) + edge_angle))
			if(istype(edge))
				SpawnFloor(edge)

		// Move our tunnel forward
		tunnel = get_step(tunnel, dir)

		if(istype(tunnel))
			// Small chance to have forks in our tunnel; otherwise dig our tunnel.
			if(i > 3 && prob(20))
				new src.type(tunnel, rand(10, 15), 0, dir)
			else
				SpawnFloor(tunnel)
		else //if(!istype(tunnel, src.parent)) // We hit space/normal/wall, stop our tunnel.
			break

		// Chance to change our direction left or right.
		if(i > 2 && prob(33))
			// We can't go a full loop though
			next_angle = -next_angle
			dir = angle2dir(dir2angle(dir) + next_angle)
/turf/unsimulated/floor/asteroid/cave/proc/SpawnFloor(var/turf/T)
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/unsimulated/floor/asteroid/cave/proc/SpawnFloor() called tick#: [world.time]")
	for(var/turf/S in range(2,T))
		if(istype(S, /turf/space) || istype(S.loc, /area/mine/explored))
			sanity = 0
			break
	if(!sanity)
		return

	SpawnMonster(T)

	new /turf/unsimulated/floor/asteroid(T)

/turf/unsimulated/floor/asteroid/cave/proc/SpawnMonster(var/turf/T)
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/unsimulated/floor/asteroid/cave/proc/SpawnMonster() called tick#: [world.time]")
	if(prob(2))
		if(istype(loc, /area/mine/explored))
			return
		for(var/atom/A in range(7,T))//Lowers chance of mob clumps
			if(istype(A, /mob/living/simple_animal/hostile/asteroid))
				return
		var/randumb = pickweight(mob_spawn_list)
		new randumb(T)
	return

/turf/unsimulated/floor/asteroid/plating
	intact=0
	icon_state="asteroidplating"

/turf/unsimulated/floor/asteroid/canBuildCatwalk()
	return BUILD_FAILURE

/turf/unsimulated/floor/asteroid/canBuildLattice()
	if(!(locate(/obj/structure/lattice) in contents))
		return BUILD_SUCCESS
	return BUILD_FAILURE

/turf/unsimulated/floor/asteroid/canBuildPlating()
	if(!dug)
		return BUILD_IGNORE
	if(locate(/obj/structure/lattice) in contents)
		return BUILD_SUCCESS
	return BUILD_FAILURE
