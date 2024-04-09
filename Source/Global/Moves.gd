extends Node

var lightning_scene = preload("res://Assets/SkillsScenes/Thunder.tscn")
var biglightning_scene = preload("res://Assets/SkillsScenes/BigThunder.tscn")
var yellowcircle_scene = preload("res://Assets/SkillsScenes/YellowCircle.tscn")
var accuracy_scene = preload("res://Assets/SkillsScenes/AccuracyUp.tscn")
var firetornado_scene = preload("res://Assets/SkillsScenes/FireTornado.tscn")
var staminaorbs_scene = preload("res://Assets/SkillsScenes/Orb.tscn")
var poisonswamp_scene = preload("res://Assets/SkillsScenes/poison_swamp.tscn")
var sworddrop_scene = preload("res://Assets/SkillsScenes/SwordDrop.tscn")
var lifecircle_scene = preload("res://Assets/SkillsScenes/lifecircle.tscn")
var rainofblades_scene = preload("res://Assets/SkillsScenes/rain_blades.tscn")
var speedboost_scene = preload("res://Assets/SkillsScenes/SpeedBoost.tscn")

var fire_effect = preload("res://Assets/BuffScenes/FireBuff.tscn")
var poison_effect = preload("res://Assets/BuffScenes/PoisonBuff.tscn")

# Скорее всего потом создать сцену магии с данными, которые можно менять баффами и т.д.

enum {
	SKIP,
	DEATH,
	ATTACK_MELEE,
	SHIELD_PROTECT,
	SEVERAL_PUNCHES,
	ENERGY_DIVISION,
	SEMI_SACRIFICE,
	STORMY_WEATHER,
	ZEUS_RAGE,
	PARALYZING_CURSE,
	CASTLING,
	EYE_PRECISION,
	FIRE_TORNADO,
	STAMINA_RESTORE,
	POISON_SWAMP,
	SWORD_DROP,
	POWER_OF_LIFE,
	INVISIBILITY,
	RAIN_OF_BLADES,
	SPEED_BOOST,# Скорость 1.5 на три хода

}

enum {
	INFO_NAME,
	INFO_COST,
	INFO_TIME,
	INFO_TARGETS,
	INFO_COST_STRING
}

enum TargType {
	SELF,
	ENEMY,
	ALL_ENEMIES,
	ALLY,
	DEAD_ALLY,
	ALLIES,
	SQUAD
}

const INFO = {
	SKIP:["Skip", null, 2, TargType.SELF, null],
	DEATH:["Death", null, 2, TargType.SELF, null],
	ATTACK_MELEE:["Cutting Attack", null, 3, TargType.ENEMY, null],
	SHIELD_PROTECT:["Protection", 5, 2.5, TargType.ALLY, null],
	SEVERAL_PUNCHES:["Several punches", 6, 3, TargType.ENEMY, null],
	ENERGY_DIVISION:["Enegy Division", 0, 2, TargType.ALLIES, "ALL AP"],
	SEMI_SACRIFICE:["Semi Sacrifice", 0, 2, TargType.ALLIES, "1 / 2 HP"],
	STORMY_WEATHER:["Stormy Weather", 10, 2, TargType.ALL_ENEMIES, null],
	ZEUS_RAGE:["Zeus Rage", 7, 2, TargType.ENEMY, null],
	PARALYZING_CURSE:["Paralyzing Curse", 0, 3, TargType.ENEMY, "MAX AP"],
	CASTLING:["Castling", 0, 3, TargType.ALLY, "1 / 2 AP"],
	EYE_PRECISION:["Eye Precision", 5, 2, TargType.ALLY, null], # Не лучший скилл, поэтому ставить в комбинацию с чем-то сильным.
	FIRE_TORNADO: ["Fire Tornado", 8, 3, TargType.ENEMY, null],
	STAMINA_RESTORE:["Stamina Restore", 5, 2.5, TargType.ALLY, null],
	POISON_SWAMP: ["Poison Swamp", 8, 3, TargType.ENEMY, null],
	SWORD_DROP:["Sword Drop", 9, 3, TargType.ENEMY, null],
	POWER_OF_LIFE:["Power Of Life", 10, 3, TargType.DEAD_ALLY, null],
	INVISIBILITY:["Invisibility", 8, 2, TargType.ALLY, null],
	RAIN_OF_BLADES:["Rain Of Blades", 4, 3, TargType.ALL_ENEMIES, null],
	SPEED_BOOST:["Speed Boost", 3, 2, TargType.ALLY, null]
}


func get_price(caster : Character, skill):
	match skill:
		_:
			return INFO[skill][INFO_COST]
		CASTLING:
			return caster.Max_ap / 2
		PARALYZING_CURSE:
			return caster.Max_ap

# Тут прописывать все реакции с направленными атаками, твины анимаций в одном методе,
# принимающим значение первого енума

func make_move(caster : Character, move_id, target):
	match move_id:
		SKIP:
			pass
		DEATH:
			pass
		ATTACK_MELEE:
			var f = randf()
			if f < caster.base_accuracy:
				target.deal_damage(caster.base_strength, 2)
			else:
				target.deal_damage(null, 2)
			caster.look_at(target.global_position)
			var default_pos = caster.global_position
			var target_pos = target.global_position - default_pos
			target_pos = target_pos - (target_pos / 8)
			var tw = get_tree().create_tween()
			tw.tween_property(caster, "global_position", default_pos + target_pos, 1)
			await tw.finished
			if caster.AnimPlayer.has_animation("1H_Melee_Attack_Chop"):
				caster.AnimPlayer.play("1H_Melee_Attack_Chop")
			caster.AnimPlayer.queue("Idle")
			await caster.AnimPlayer.animation_changed
			tw = get_tree().create_tween()
			tw.tween_property(caster, "global_position", default_pos, 1)
		SHIELD_PROTECT:
			caster.look_at(target.global_position)
			if caster.AnimPlayer.has_animation("Spellcast_Raise"):
				caster.AnimPlayer.play("Spellcast_Raise")
			caster.AnimPlayer.queue("Idle")
			await caster.AnimPlayer.animation_changed
			target.create_shield()
			caster.AP -= INFO[SHIELD_PROTECT][INFO_COST]
		SEVERAL_PUNCHES:
			for i in randi_range(1, 3):
				target.deal_damage(-randi_range(10, 15), 2 + (i * 0.2))
			caster.look_at(target.global_position)
			var default_pos = caster.global_position
			var target_pos = target.global_position - default_pos
			target_pos = target_pos - (target_pos / 8)
			var tw = get_tree().create_tween()
			tw.tween_property(caster, "global_position", default_pos + target_pos, 1)
			await tw.finished
			if caster.AnimPlayer.has_animation("1H_Melee_Attack_Chop"):
				caster.AnimPlayer.play("1H_Melee_Attack_Chop")
			caster.AnimPlayer.queue("Idle")
			await caster.AnimPlayer.animation_changed
			tw = get_tree().create_tween()
			tw.tween_property(caster, "global_position", default_pos, 1)
			caster.AP -= INFO[SEVERAL_PUNCHES][INFO_COST]
		ENERGY_DIVISION:
			if caster.AnimPlayer.has_animation("Spellcasting"):
				caster.AnimPlayer.play("Spellcasting")
				caster.AnimPlayer.queue("Spellcasting")
			caster.AnimPlayer.queue("Idle")
			await caster.AnimPlayer.animation_changed
			for ally in target:
				ally.restore_ap(caster.AP / caster.allies.size())
			caster.AP -= caster.AP
		SEMI_SACRIFICE:
			if caster.AnimPlayer.has_animation("Spellcasting"):
				caster.AnimPlayer.play("Spellcasting")
				caster.AnimPlayer.queue("Spellcasting")
			caster.AnimPlayer.queue("Idle")
			await caster.AnimPlayer.animation_changed
			caster.HP -= floor(caster.HP / 2)
			for ally in target:
				ally.deal_damage(caster.HP / caster.allies.size(), 0.1)
		STORMY_WEATHER:
			if caster.AnimPlayer.has_animation("Spellcasting"):
				caster.AnimPlayer.play("Spellcasting")
				caster.AnimPlayer.queue("Spellcasting")
			caster.AnimPlayer.queue("Idle")
			await caster.AnimPlayer.animation_changed
			caster.AP -= INFO[STORMY_WEATHER][INFO_COST]
			for targ in target:
				targ.add_child(lightning_scene.instantiate())
				targ.deal_damage(-12, 0.1)
		ZEUS_RAGE:
			if caster.AnimPlayer.has_animation("Spellcasting"):
				caster.AnimPlayer.play("Spellcasting")
				caster.AnimPlayer.queue("Spellcasting")
			caster.AnimPlayer.queue("Idle")
			await caster.AnimPlayer.animation_changed
			caster.AP -= INFO[ZEUS_RAGE][INFO_COST]
			caster.SKIPS = 1
			target.add_child(biglightning_scene.instantiate())
			target.deal_damage(-40, 0.1)
		PARALYZING_CURSE:
			if caster.AnimPlayer.has_animation("Spellcasting"):
				caster.AnimPlayer.play("Spellcasting")
				caster.AnimPlayer.queue("Spellcasting")
			caster.AnimPlayer.queue("Idle")
			await caster.AnimPlayer.animation_changed
			var yellow_scn = yellowcircle_scene.instantiate()
			yellow_scn.position.y += 0.2
			target.add_child(yellow_scn)
			target.SKIPS = 1
			caster.AP -= caster.Max_ap
		CASTLING:
			caster.AP -= caster.Max_ap / 2
			var glob_pos = caster.global_position
			var caster_position = caster.CHAR_POSITION
			caster.CHAR_POSITION = target.CHAR_POSITION
			target.CHAR_POSITION = caster_position
			get_tree().create_tween().tween_property(caster, "global_position", target.global_position, 2)
			get_tree().create_tween().tween_property(target, "global_position", glob_pos, 2)
		EYE_PRECISION:
			if caster.AnimPlayer.has_animation("Spellcasting"):
				caster.AnimPlayer.play("Spellcasting")
				caster.AnimPlayer.queue("Spellcasting")
			caster.AnimPlayer.queue("Idle")
			await caster.AnimPlayer.animation_changed
			caster.AP -= INFO[EYE_PRECISION][INFO_COST]
			var accuracy = accuracy_scene.instantiate()
			accuracy.position.y += 4
			target.add_child(accuracy)
			target.BUFFS[Buffs.ACCURACY_UP] = 3
		FIRE_TORNADO:
			if caster.AnimPlayer.has_animation("Spellcasting"):
				caster.AnimPlayer.play("Spellcasting")
				caster.AnimPlayer.queue("Spellcasting")
			caster.AnimPlayer.queue("Idle")
			await caster.AnimPlayer.animation_changed
			var fire_tornado = firetornado_scene.instantiate()
			target.add_child(fire_tornado)
			caster.AP -= INFO[FIRE_TORNADO][INFO_COST]
			target.BUFFS[Buffs.BURN] = 3
			target.add_child(fire_effect.instantiate())
		STAMINA_RESTORE:
			if caster.AnimPlayer.has_animation("Spellcasting"):
				caster.AnimPlayer.play("Spellcasting")
				caster.AnimPlayer.queue("Spellcasting")
			caster.AnimPlayer.queue("Idle")
			await caster.AnimPlayer.animation_changed
			var orbs = staminaorbs_scene.instantiate()
			target.add_child(orbs)
			target.AP += 10
			caster.AP -= INFO[STAMINA_RESTORE][INFO_COST]
		POISON_SWAMP:
			if caster.AnimPlayer.has_animation("Spellcasting"):
				caster.AnimPlayer.play("Spellcasting")
				caster.AnimPlayer.queue("Spellcasting")
			caster.AnimPlayer.queue("Idle")
			await caster.AnimPlayer.animation_changed
			var poison_swamp = poisonswamp_scene.instantiate()
			target.add_child(poison_swamp)
			caster.AP -= INFO[POISON_SWAMP][INFO_COST]
			target.BUFFS[Buffs.POISON] = 100
			target.add_child(poison_effect.instantiate())
		SWORD_DROP:
			caster.look_at(target.global_position)
			var default_pos = caster.global_position
			var target_position = target.global_position
			var sword_position = target_position + Vector3(0, 10, 0)
			var sworddrop = sworddrop_scene.instantiate()
			target.add_child(sworddrop)
			sworddrop.global_position = sword_position
			var tw = get_tree().create_tween()
			tw.tween_property(caster, "global_position", sword_position, 1)
			tw.tween_property(caster, "global_position", target_position, 0.5)
			tw.tween_property(caster, "global_position", default_pos, 1)
			target.deal_damage(randi_range(-40, -20), 1.5)
			caster.AP -= INFO[SWORD_DROP][INFO_COST]
		POWER_OF_LIFE:
			if caster.AnimPlayer.has_animation("Spellcasting"):
				caster.AnimPlayer.play("Spellcasting")
				caster.AnimPlayer.queue("Spellcasting")
			caster.AnimPlayer.queue("Idle")
			await caster.AnimPlayer.animation_changed
			var lifepower = lifecircle_scene.instantiate()
			lifepower.position.y += 0.2
			target.add_child(lifepower)
			target.ALIVE = true
			target.HP = target.Max_hp * 0.1
			target.AnimPlayer.play_backwards("Death_A")
			caster.AP -= INFO[POWER_OF_LIFE][INFO_COST]
		INVISIBILITY:
			if caster.AnimPlayer.has_animation("Spellcasting"):
				caster.AnimPlayer.play("Spellcasting")
				caster.AnimPlayer.queue("Spellcasting")
			caster.AnimPlayer.queue("Idle")
			await caster.AnimPlayer.animation_changed
			target.HIDDEN = true
			caster.AP -= INFO[INVISIBILITY][INFO_COST]
		RAIN_OF_BLADES:
			if caster.AnimPlayer.has_animation("Spellcasting"):
				caster.AnimPlayer.play("Spellcasting")
				caster.AnimPlayer.queue("Spellcasting")
			caster.AnimPlayer.queue("Idle")
			await caster.AnimPlayer.animation_changed
			caster.AP -= INFO[RAIN_OF_BLADES][INFO_COST]
			for targ in target:
				targ.add_child(rainofblades_scene.instantiate())
				for i in randi_range(2, 6):
					targ.deal_damage(-randi_range(2, 4), 1 + (i * 0.2))
		SPEED_BOOST:
			if caster.AnimPlayer.has_animation("Spellcasting"):
				caster.AnimPlayer.play("Spellcasting")
				caster.AnimPlayer.queue("Spellcasting")
			caster.AnimPlayer.queue("Idle")
			await caster.AnimPlayer.animation_changed
			caster.AP -= INFO[SPEED_BOOST][INFO_COST]
			var speedboost = speedboost_scene.instantiate()
			speedboost.position.y += 4
			target.add_child(speedboost)
			target.SPEED = target.SPEED * 1.5
			target.BUFFS[Buffs.SPEED_UP] = 4
