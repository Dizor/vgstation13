/mob/living/silicon/ai/proc/ai_statuschange()
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/mob/living/silicon/ai/proc/ai_statuschange() called tick#: [world.time]")
	set category = "AI Commands"
	set name = "AI status"

	if(usr.stat == 2 || (usr.status_flags & FAKEDEATH))
		usr <<"You cannot change your emotional status because you are dead!"
		return
	var/list/ai_emotions = list("Very Happy", "Happy", "Neutral", "Unsure", "Confused", "Sad", "BSOD", "Blank", "Problems?", "Awesome", "Facepalm", "Friend Computer", "Beer mug", "Dwarf", "Fishtank", "Plump Helmet")
	if(src.ckey == "serithi")
		ai_emotions.Add("Tribunal","Tribunal Malfunctioning")
	var/emote = input("Please, select a status!", "AI Status", null, null) in ai_emotions
	for (var/obj/machinery/ai_status_display/AISD in machines) //change status
		spawn( 0 )
		AISD.emotion = emote
	for (var/obj/machinery/status_display/SD in machines) //if Friend Computer, change ALL displays
		if(emote=="Friend Computer")
			spawn(0)
			SD.friendc = 1
		else
			spawn(0)
			SD.friendc = 0
	return