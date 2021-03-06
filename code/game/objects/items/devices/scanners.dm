/*
CONTAINS:
T-RAY
DETECTIVE SCANNER
HEALTH ANALYZER
GAS ANALYZER
PLANT ANALYZER
MASS SPECTROMETER
REAGENT SCANNER
*/
/obj/item/device/t_scanner
	name = "T-ray scanner"
	desc = "A terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	icon_state = "t-ray0"
	var/on = 0
	flags = FPRINT
	slot_flags = SLOT_BELT
	w_class = 2
	item_state = "electronic"
	starting_materials = list(MAT_IRON = 150)
	w_type = RECYK_ELECTRONIC
	melt_temperature = MELTPOINT_PLASTIC
	origin_tech = "magnets=1;engineering=1"

/obj/item/device/t_scanner/Destroy()
	if(on)
		processing_objects.Remove(src)
	..()

/obj/item/device/t_scanner/attack_self(mob/user)

	on = !on
	icon_state = "t-ray[on]"

	if(on)
		processing_objects.Add(src)


/obj/item/device/t_scanner/process()
	if(!on)
		processing_objects.Remove(src)
		return null

	for(var/turf/T in range(1, src.loc) )

		if(!T.intact)
			continue

		for(var/obj/O in T.contents)

			if(O.level != 1)
				continue

			if(O.invisibility == 101)
				O.invisibility = 0
				spawn(10)
					if(O)
						var/turf/U = O.loc
						if(U && U.intact)
							O.invisibility = 101
		for(var/mob/living/M in T.contents)
			var/oldalpha = M.alpha
			if(M.alpha < 255 && istype(M))
				M.alpha = 255
				spawn(10)
					if(M)
						M.alpha = oldalpha

		var/mob/living/M = locate() in T
		if(M && M.invisibility == 2)
			M.invisibility = 0
			spawn(2)
				if(M)
					M.invisibility = INVISIBILITY_LEVEL_TWO


/obj/item/device/healthanalyzer
	name = "Health Analyzer"
	icon_state = "health"
	item_state = "analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	flags = FPRINT
	siemens_coefficient = 1
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = 1.0
	throw_speed = 5
	starting_materials = list(MAT_IRON = 200)
	w_type = RECYK_ELECTRONIC
	melt_temperature = MELTPOINT_PLASTIC
	origin_tech = "magnets=1;biotech=1"
	var/mode = 1;

/obj/item/device/healthanalyzer/attack(mob/living/M as mob, mob/living/user as mob)
	if(!user.hallucinating())
		healthanalyze(M, user, mode)
	else
		if( (M.stat == DEAD || (M.status_flags & FAKEDEATH)) )
			user.show_message("<span class='game say'><span class='name'>[src]</span> beeps, \"It's dead, Jim.\"</span>",MESSAGE_HEAR,"<span class='notice'>The [name] glows black.</span>")
		else
			user << "<span class='notice'>[src] glows [pick("red","green","blue","pink")]! You wonder what would that mean.</span>"
	src.add_fingerprint(user)

proc/healthanalyze(mob/living/M as mob, mob/living/user as mob, var/mode = 0, var/skip_checks=0, var/silent=0)
	if(!skip_checks)
		//writepanic("[__FILE__].[__LINE__] \\/proc/healthanalyze() called tick#: [world.time]")
		if (( (M_CLUMSY in user.mutations) || user.getBrainLoss() >= 60) && prob(50))
			user << text("<span class='warning'>You try to analyze the floor's vitals!</span>")
			for(var/mob/O in viewers(M, null))
				O.show_message(text("<span class='warning'>[user] has analyzed the floor's vitals!</span>"), 1)
			user.show_message(text("<span class='notice'>Analyzing Results for The floor:\n\t Overall Status: Healthy</span>"), 1)
			user.show_message(text("<span class='notice'>\t Damage Specifics: [0]-[0]-[0]-[0]</span>"), 1)
			user.show_message("<span class='notice'>Key: Suffocation/Toxin/Burns/Brute</span>", 1)
			user.show_message("<span class='notice'>Body Temperature: ???</span>", 1)
			return
		if (!usr.dexterity_check())
			usr << "<span class='warning'>You don't have the dexterity to do this!</span>"
			return
	if(!silent)
		user.visible_message("<span class='notice'>[user] has analyzed [M]'s vitals.</span>","<span class='notice'>You have analyzed [M]'s vitals.</span>")
	var/fake_oxy = max(rand(1,40), M.getOxyLoss(), (300 - (M.getToxLoss() + M.getFireLoss() + M.getBruteLoss())))
	var/OX = M.getOxyLoss() > 50 	? 	"<b>[M.getOxyLoss()]</b>" 		: M.getOxyLoss()
	var/TX = M.getToxLoss() > 50 	? 	"<b>[M.getToxLoss()]</b>" 		: M.getToxLoss()
	var/BU = M.getFireLoss() > 50 	? 	"<b>[M.getFireLoss()]</b>" 		: M.getFireLoss()
	var/BR = M.getBruteLoss() > 50 	? 	"<b>[M.getBruteLoss()]</b>" 	: M.getBruteLoss()
	playsound(get_turf(src), 'sound/items/healthanalyzer.ogg', 50, 1)
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 			? 	"<b>[fake_oxy]</b>" 			: fake_oxy
		user.show_message("<span class='notice'>Analyzing Results for [M]:\n\t Overall Status: dead</span>")
	else
		user.show_message("<span class='notice'>Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "dead" : "[M.health - M.halloss]% healthy"]</span>")
	user.show_message("\t Key: <font color='blue'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font>", 1)
	user.show_message("\t Damage Specifics: <font color='blue'>[OX]</font> - <font color='green'>[TX]</font> - <font color='#FFA500'>[BU]</font> - <font color='red'>[BR]</font>")
	user.show_message("<span class='notice'>Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)</span>", 1)
	if(M.tod && (M.stat == DEAD || (M.status_flags & FAKEDEATH)))
		user.show_message("<span class='notice'>Time of Death: [M.tod]</span>")
	if(istype(M, /mob/living/carbon/human) && mode == 1)
		var/mob/living/carbon/human/H = M
		var/list/damaged = H.get_damaged_organs(1,1)
		user.show_message("<span class='notice'>Localized Damage, Brute/Burn:</span>",1)
		if(length(damaged)>0)
			for(var/datum/organ/external/org in damaged)
				var/organ_msg="<span class='notice'>\t </span>"
				organ_msg+=capitalize(org.display_name)
				organ_msg+=": "
				if(org.brute_dam>0)
					organ_msg+="<span class='warning'>[org.brute_dam]</span>"
				else
					organ_msg+="0"
				if(org.burn_dam > 0)
					organ_msg+="/<font color='#FFA500'>[org.burn_dam]</font>"
				else
					organ_msg+="/0"
				if(org.status & ORGAN_BLEEDING)
					organ_msg+="<span class='danger'>\[BLEEDING\]</span>"
				if(org.status & ORGAN_PEG)
					organ_msg+="<span class='notice'><b>\[WOOD DETECTED?\]</b></span>"
				if(org.status & ORGAN_ROBOT)
					organ_msg+="<span class='notice'><b>\[METAL DETECTED?\]</b></span>"
				user.show_message(organ_msg,1)
		else
			user.show_message("<span class='notice'>\t Limbs are OK.</span>",1)

	OX = M.getOxyLoss() > 50 ? 	"<font color='blue'><b>Severe oxygen deprivation detected</b></font>" 		: 	"Subject bloodstream oxygen level normal"
	TX = M.getToxLoss() > 50 ? 	"<font color='green'><b>Dangerous amount of toxins detected</b></font>" 	: 	"Subject bloodstream toxin level minimal"
	BU = M.getFireLoss() > 50 ? 	"<font color='#FFA500'><b>Severe burn damage detected</b></font>" 			:	"Subject burn injury status O.K"
	BR = M.getBruteLoss() > 50 ? "<font color='red'><b>Severe anatomical damage detected</b></font>" 		: 	"Subject brute-force injury status O.K"
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 ? 		"<span class='warning'>Severe oxygen deprivation detected<span class='danger'></span></span>" 	: 	"Subject bloodstream oxygen level normal"
	user.show_message("[OX] | [TX] | [BU] | [BR]")
	if (istype(M, /mob/living/carbon))
		if(M:reagents.total_volume > 0)
			user.show_message(text("<span class='warning'>Warning: Unknown substance detected in subject's blood.</span>"))
		if(M:virus2.len)
			var/mob/living/carbon/C = M
			for (var/ID in C.virus2)
				if (ID in virusDB)
					var/datum/data/record/V = virusDB[ID]
					user.show_message(text("<span class='warning'>Warning: Pathogen [V.fields["name"]] detected in subject's blood. Known antigen : [V.fields["antigen"]]</span>"))
//			user.show_message(text("<span class='warning'>Warning: Unknown pathogen detected in subject's blood.</span>"))
	if (M.getCloneLoss())
		user.show_message("<span class='warning'>Subject appears to have been imperfectly cloned.</span>")
	for(var/datum/disease/D in M.viruses)
		if(!D.hidden[SCANNER])
			user.show_message(text("<span class='warning'><b>Warning: [D.form] Detected</b>\nName: [D.name].\nType: [D.spread].\nStage: [D.stage]/[D.max_stages].\nPossible Cure: [D.cure]</span>"))
	if (M.reagents && M.reagents.get_reagent_amount("inaprovaline"))
		user.show_message("<span class='notice'>Bloodstream Analysis located [M.reagents:get_reagent_amount("inaprovaline")] units of rejuvenation chemicals.</span>")
	if (M.has_brain_worms())
		user.show_message("<span class='warning'>Subject suffering from aberrant brain activity. Recommend further scanning.</span>")
	else if (M.getBrainLoss() >= 100 || !M.has_brain())
		user.show_message("<span class='warning'>Subject is brain-dead.</span>")
	else if (M.getBrainLoss() >= 60)
		user.show_message("<span class='warning'>Severe brain damage detected. Subject likely to have mental retardation.</span>")
	else if (M.getBrainLoss() >= 10)
		user.show_message("<span class='warning'>Significant brain damage detected. Subject may have had a concussion.</span>")
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/name in H.organs_by_name)
			var/datum/organ/external/e = H.organs_by_name[name]
			var/limb = e.display_name
			if(e.status & ORGAN_BROKEN)
				if(((e.name == "l_arm") || (e.name == "r_arm") || (e.name == "l_leg") || (e.name == "r_leg")) && (!(e.status & ORGAN_SPLINTED)))
					user << "<span class='warning'>Unsecured fracture in subject [limb]. Splinting recommended for transport.</span>"
			if(e.has_infected_wound())
				user << "<span class='warning'>Infected wound detected in subject [limb]. Disinfection recommended.</span>"

		for(var/name in H.organs_by_name)
			var/datum/organ/external/e = H.organs_by_name[name]
			if(e.status & ORGAN_BROKEN)
				user.show_message(text("<span class='warning'>Bone fractures detected. Advanced scanner required for location.</span>"), 1)
				break
		for(var/datum/organ/external/e in H.organs)
			for(var/datum/wound/W in e.wounds) if(W.internal)
				user.show_message(text("<span class='warning'>Internal bleeding detected. Advanced scanner required for location.</span>"), 1)
				break
		if(M:vessel)
			var/blood_volume = round(M:vessel.get_reagent_amount("blood"))
			var/blood_percent =  blood_volume / 560
			blood_percent *= 100
			if(blood_volume <= 500)
				user.show_message("<span class='warning'><b>Warning: Blood Level LOW: [blood_percent]% [blood_volume]cl</span>")
			else if(blood_volume <= 336)
				user.show_message("<span class='warning'><b>Warning: Blood Level CRITICAL: [blood_percent]% [blood_volume]cl</span>")
			else
				user.show_message("<span class='notice'>Blood Level Normal: [blood_percent]% [blood_volume]cl</span>")
		user.show_message("<span class='notice'>Subject's pulse: <font color='[H.pulse == PULSE_THREADY || H.pulse == PULSE_NONE ? "red" : "blue"]'>[H.get_pulse(GETPULSE_TOOL)] bpm.</font></span>")
	return

/obj/item/device/healthanalyzer/verb/toggle_mode()
	set name = "Switch Verbosity"
	set category = "Object"
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""]) \\/obj/item/device/healthanalyzer/verb/toggle_mode()  called tick#: [world.time]")

	mode = !mode
	switch (mode)
		if(1)
			usr << "The scanner now shows specific limb damage."
		if(0)
			usr << "The scanner no longer shows limb damage."


/obj/item/device/analyzer
	desc = "A hand-held environmental scanner which reports current gas levels."
	name = "atmospheric analyzer"
	icon_state = "atmos"
	item_state = "analyzer"
	w_class = 2.0
	flags = FPRINT
	siemens_coefficient = 1
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20
	starting_materials = list(MAT_IRON = 30, MAT_GLASS = 20)
	w_type = RECYK_ELECTRONIC
	melt_temperature = MELTPOINT_PLASTIC
	origin_tech = "magnets=1;engineering=1"

/obj/item/device/analyzer/attack_self(mob/user as mob)

	if (user.stat)
		return
	if (!user.dexterity_check())
		user << "<span class='warning'>You don't have the dexterity to do this!</span>"
		return

	var/turf/location = user.loc
	if (!( istype(location, /turf) ))
		return

	var/datum/gas_mixture/environment = location.return_air()
	user.show_message(output_gas_scan(environment, get_turf(src), 1), 1)

	src.add_fingerprint(user)
	return

//if human_standard is enabled, the message will be formatted to show which values are dangerous
/obj/item/device/analyzer/proc/output_gas_scan(var/datum/gas_mixture/scanned, var/atom/container, human_standard = 0)
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/obj/item/device/analyzer/proc/output_gas_scan() called tick#: [world.time]")
	if(!scanned)
		return "<span class='warning'>No gas mixture found.</span>"
	scanned.update_values()
	var/pressure = scanned.return_pressure()
	var/total_moles = scanned.total_moles()
	var/message = ""
	if(!container || istype(container, /turf))
		message += "<span class='notice'><B>Results:</B><br></span>"
	else
		message += "<span class='notice'><B>\icon [container] Results of [container] scan:</B><br></span>"
	if(total_moles)
		message += "[human_standard && abs(pressure - ONE_ATMOSPHERE) > 10 ? "<span class='bad'>" : "<span class='notice'>"] Pressure: [round(pressure,0.1)] kPa</span><br>"
		var/o2_concentration = scanned.oxygen/total_moles
		var/n2_concentration = scanned.nitrogen/total_moles
		var/co2_concentration = scanned.carbon_dioxide/total_moles
		var/plasma_concentration = scanned.toxins/total_moles

		var/unknown_concentration =  1-(o2_concentration+n2_concentration+co2_concentration+plasma_concentration)

		if(n2_concentration > 0.01)
			message += "[human_standard && abs(n2_concentration - N2STANDARD) > 20 ? "<span class='bad'>" : "<span class='notice'>"] Nitrogen: [round(scanned.nitrogen, 0.1)] mol, [round(n2_concentration*100)]%</span><br>"
		if(o2_concentration > 0.01)
			message += "[human_standard && abs(o2_concentration - O2STANDARD) > 2 ? "<span class='bad'>" : "<span class='notice'>"] Oxygen: [round(scanned.oxygen, 0.1)] mol, [round(o2_concentration*100)]%</span><br>"
		if(co2_concentration > 0.01)
			message += "[human_standard ? "<span class='bad'>" : "<span class='notice'>"] CO2: [round(scanned.carbon_dioxide, 0.1)] mol, [round(co2_concentration*100)]%</span><br>"
		if(plasma_concentration > 0.01)
			message += "[human_standard ? "<span class='bad'>" : "<span class='notice'>"] Plasma: [round(scanned.toxins, 0.1)] mol, [round(plasma_concentration*100)]%</span><br>"
		if(unknown_concentration > 0.01)
			message += "<span class='notice'>Unknown: [round(unknown_concentration*100)]%<br></span>"

		message += "[human_standard && !(scanned.temperature-T0C in range(0, 40)) ? "<span class='bad'>" : "<span class='notice'>"] Temperature: [round(scanned.temperature-T0C)]&deg;C"
	else
		message += "<span class='warning'>No gasses detected[container && !istype(container, /turf) ? " in \the [container]." : ""]!</span>"
	return message

/obj/item/device/mass_spectrometer
	desc = "A hand-held mass spectrometer which identifies trace chemicals in a blood sample."
	name = "mass-spectrometer"
	icon_state = "spectrometer"
	item_state = "analyzer"
	w_class = 2.0
	flags = FPRINT | OPENCONTAINER
	siemens_coefficient = 1
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20
	starting_materials = list(MAT_IRON = 30, MAT_GLASS = 20)
	w_type = RECYK_ELECTRONIC
	origin_tech = "magnets=2;biotech=2"
	var/details = 0
	var/recent_fail = 0

/obj/item/device/mass_spectrometer/New()
	. = ..()
	create_reagents(5)

/obj/item/device/mass_spectrometer/on_reagent_change()
	if(reagents.total_volume)
		icon_state = initial(icon_state) + "_s"
	else
		icon_state = initial(icon_state)

/obj/item/device/mass_spectrometer/attack(mob/living/M as mob, mob/living/user as mob)
	if(!M.reagents) return
	if(iscarbon(M))
		if(crit_fail)
			user << "<span class='warning'>This device has critically failed and is no longer functional!</span>"
			return
		if(reagents.total_volume)
			user << "<span class='warning'>This device already has a blood sample!</span>"
			return
		if (!user.dexterity_check())
			user << "<span class='warning'>You don't have the dexterity to do this!</span>"
			return

		var/mob/living/carbon/T = M
		if(!T.dna)
			return
		if(M_NOCLONE in T.mutations)
			return

		var/datum/reagent/B = T.take_blood(src,src.reagents.maximum_volume)
		if (B)
			src.reagents.reagent_list |= B
			src.reagents.update_total()
			src.on_reagent_change()
			src.reagents.handle_reactions()
			update_icon()
			user.visible_message("<span class='warning'>[user] takes a blood sample from [M].</span>", \
				"<span class='notice'>You take a blood sample from [M]</span>")

/obj/item/device/mass_spectrometer/attack_self(mob/user as mob)
	if (user.stat)
		return
	if (crit_fail)
		user << "<span class='warning'>This device has critically failed and is no longer functional!</span>"
		return
	if (!user.dexterity_check())
		user << "<span class='warning'>You don't have the dexterity to do this!</span>"
		return
	if(reagents.total_volume)
		var/list/blood_traces = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			if(R.id != "blood")
				reagents.clear_reagents()
				user << "<span class='warning'>The sample was contaminated! Please insert another sample.</span>"
				return
			else
				blood_traces = params2list(R.data["trace_chem"])
				break
		var/dat
		if (blood_traces.len)
			dat = "Trace Chemicals Found: "
			for(var/R in blood_traces)
				if(prob(reliability))
					if(details)
						dat += "[R] ([blood_traces[R]] units) "
					else
						dat += "[R] "
					recent_fail = 0
				else
					if(recent_fail)
						crit_fail = 1
						reagents.clear_reagents()
						return
					else
						recent_fail = 1
		else
			dat = "No trace chemicals found in the sample."
		user << "[dat]"
		reagents.clear_reagents()
	return

/obj/item/device/mass_spectrometer/adv
	name = "advanced mass-spectrometer"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = "magnets=4;biotech=2"

/obj/item/device/reagent_scanner
	name = "reagent scanner"
	desc = "A hand-held reagent scanner which identifies chemical agents."
	icon_state = "spectrometer"
	item_state = "analyzer"
	w_class = 2.0
	flags = FPRINT
	siemens_coefficient = 1
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20
	starting_materials = list(MAT_IRON = 30, MAT_GLASS = 20)
	w_type = RECYK_ELECTRONIC
	origin_tech = "magnets=2;biotech=2"
	var/details = 0
	var/recent_fail = 0

/obj/item/device/reagent_scanner/afterattack(obj/O, mob/user as mob)
	if (user.stat)
		return
	if (!user.dexterity_check())
		user << "<span class='warning'>You don't have the dexterity to do this!</span>"
		return
	if(!istype(O))
		return
	if (crit_fail)
		user << "<span class='warning'>This device has critically failed and is no longer functional!</span>"
		return

	if(!isnull(O.reagents))
		var/dat = ""
		if(O.reagents.reagent_list.len > 0)
			var/one_percent = O.reagents.total_volume / 100
			for (var/datum/reagent/R in O.reagents.reagent_list)
				if(prob(reliability))
					dat += "\n \t <span class='notice'>[R][details ? ": [R.volume / one_percent]%" : ""]</span>"
					recent_fail = 0
				else if(recent_fail)
					crit_fail = 1
					dat = null
					break
				else
					recent_fail = 1
		if(dat)
			user << "<span class='notice'>Chemicals found: [dat]</span>"
		else
			user << "<span class='notice'>No active chemical agents found in [O].</span>"
	else
		user << "<span class='notice'>No significant chemical agents found in [O].</span>"

	return

/obj/item/device/reagent_scanner/adv
	name = "advanced reagent scanner"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = "magnets=4;biotech=2"
