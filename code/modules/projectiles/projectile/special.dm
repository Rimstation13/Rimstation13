/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	damage = 0
	damage_type = BURN
	nodamage = 1
	flag = "energy"


/obj/item/projectile/ion/on_hit(atom/target, blocked = 0)
	empulse(target, 1, 1)
	return 1


/obj/item/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	damage = 50
	flag = "bullet"

/obj/item/projectile/bullet/gyro/on_hit(atom/target, blocked = 0)
	explosion(target, -1, 0, 2)
	return 1

/obj/item/projectile/bullet/a40mm
	name ="40mm grenade"
	desc = "USE A WEEL GUN"
	icon_state= "bolter"
	damage = 60
	flag = "bullet"

/obj/item/projectile/bullet/a40mm/on_hit(atom/target, blocked = 0)
	explosion(target, -1, 0, 2, 1, 0, flame_range = 3)
	return 1

/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	damage = 0
	damage_type = BURN
	nodamage = 1
	flag = "energy"
	var/temperature = 100


/obj/item/projectile/temp/on_hit(atom/target, blocked = 0)//These two could likely check temp protection on the mob
	if(istype(target, /mob/living))
		var/mob/M = target
		M.bodytemperature = temperature
	return 1

/obj/item/projectile/temp/hot
	name = "heat beam"
	temperature = 400

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "small1"
	damage = 0
	damage_type = BRUTE
	nodamage = 1
	flag = "bullet"

/obj/item/projectile/meteor/Bump(atom/A)
	if(A == firer)
		loc = A.loc
		return
	A.ex_act(2)
	playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)
	for(var/mob/M in range(10, src))
		if(!M.stat)
			shake_camera(M, 3, 1)
	qdel(src)

/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	damage = 0
	damage_type = TOX
	nodamage = 1
	flag = "energy"

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	damage = 0
	damage_type = TOX
	nodamage = 1
	flag = "energy"

/obj/item/projectile/beam/mindflayer
	name = "flayer ray"

/obj/item/projectile/beam/mindflayer/on_hit(atom/target, blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		M.adjustBrainLoss(20)
		M.hallucination += 20

/obj/item/projectile/kinetic
	name = "kinetic force"
	icon_state = null
	damage = 15
	damage_type = BRUTE
	flag = "bomb"
	range = 3

obj/item/projectile/kinetic/New()
	var/turf/proj_turf = get_turf(src)
	if(!istype(proj_turf, /turf))
		return
	var/datum/gas_mixture/environment = proj_turf.return_air()
	var/pressure = environment.return_pressure()
	if(pressure < 50)
		name = "full strength kinetic force"
		damage = 30
	..()

/obj/item/projectile/kinetic/Range()
	range--
	if(range <= 0)
		new /obj/item/effect/kinetic_blast(src.loc)
		qdel(src)

/obj/item/projectile/kinetic/on_hit(atom/target)
	var/turf/target_turf= get_turf(target)
	if(istype(target_turf, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = target_turf
		M.gets_drilled(firer)
	new /obj/item/effect/kinetic_blast(target_turf)
	..()

/obj/item/effect/kinetic_blast
	name = "kinetic explosion"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "kinetic_blast"
	layer = 4.1

/obj/item/effect/kinetic_blast/New()
	spawn(4)
		qdel(src)

/obj/item/projectile/beam/wormhole
	name = "bluespace beam"
	icon_state = "spark"
	hitsound = "sparks"
	damage = 3
	var/obj/item/weapon/gun/energy/wormhole_projector/gun
	color = "#33CCFF"

/obj/item/projectile/beam/wormhole/orange
	name = "orange bluespace beam"
	color = "#FF6600"

/obj/item/projectile/beam/wormhole/New(var/obj/item/ammo_casing/energy/wormhole/casing)
	if(casing)
		gun = casing.gun

/obj/item/ammo_casing/energy/wormhole/New(var/obj/item/weapon/gun/energy/wormhole_projector/wh)
	gun = wh

/obj/item/projectile/beam/wormhole/on_hit(var/atom/target)
	if(ismob(target))
		..()
		return
	if(!gun)
		qdel(src)
	gun.create_portal(src)


/obj/item/projectile/bullet/gyro/on_hit(atom/target, blocked = 0)
	explosion(target, -1, 0, 2)
	return 1


/obj/item/projectile/bullet/frag12
	name ="explosive slug"
	damage = 25
	weaken = 5

/obj/item/projectile/bullet/magspear
	name = "magnetic spear"
	desc = "WHITE WHALE, HOLY GRAIL"
	damage = 30 //takes 3 spears to kill a mega carp, one to kill a normal carp
	icon_state = "magspear"

/obj/item/projectile/bullet/magspear/on_hit(var/atom/target, var/blocked = 0)
	if(!proj_hit)
		proj_hit = 1
		new /obj/item/ammo_casing/caseless/magspear(src.loc)
	..()

/obj/item/projectile/bullet/magspear/on_range()
	if(!proj_hit)
		new /obj/item/ammo_casing/caseless/magspear(src.loc)
		..()