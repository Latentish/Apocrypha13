//Used to process and handle roundstart trait datums
//Trait datums are separate from trait strings:
// - Trait strings are used for faster checking in code
// - Trait datums are stored and hold different effects, as well as being a vector for applying trait string
PROCESSING_SUBSYSTEM_DEF(quirks)
	name = "Quirks"
	init_order = INIT_ORDER_TRAITS
	flags = SS_BACKGROUND
	wait = 10
	runlevels = RUNLEVEL_GAME

	var/list/quirks = list()		//Assoc. list of all roundstart quirk datum types; "name" = /path/
	var/list/quirk_points = list()	//Assoc. list of quirk names and their "point cost"; positive numbers are good traits, and negative ones are bad
	var/list/quirk_objects = list()	//A list of all quirk objects in the game, since some may process

/datum/controller/subsystem/processing/quirks/Initialize(timeofday)
	if(!quirks.len)
		SetupQuirks()
	..()

/datum/controller/subsystem/processing/quirks/proc/SetupQuirks()
	for(var/V in subtypesof(/datum/quirk))
		var/datum/quirk/T = V
		quirks[initial(T.name)] = T
		quirk_points[initial(T.name)] = initial(T.value)

/datum/controller/subsystem/processing/quirks/proc/AssignQuirks(mob/living/user, client/cli, spawn_effects)
	GenerateQuirks(cli)
	for(var/V in cli.prefs.character_quirks)
		user.add_quirk(V, spawn_effects)

/datum/controller/subsystem/processing/quirks/proc/GenerateQuirks(client/user)
	if(user.prefs.character_quirks.len)
		return
	user.prefs.character_quirks = user.prefs.all_quirks
