//Refer to life.dm for caller

/mob/living/carbon/human/proc/handle_stasis_bag()
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/mob/living/carbon/human/proc/handle_stasis_bag() called tick#: [world.time]")
	// Handle side effects from stasis bag
	if(in_stasis)
		// First off, there's no oxygen supply, so the mob will slowly take brain damage
		adjustBrainLoss(0.1)

		// Next, the method to induce stasis has some adverse side-effects, manifesting
		// as cloneloss
		adjustCloneLoss(0.1)
