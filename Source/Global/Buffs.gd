extends Node

enum {
	ACCURACY_UP,
	BURN,
	POISON,
	SPEED_UP
}

func handle_buff(character : Character, buff):
	match(buff):
		BURN:
			character.deal_damage(character.Max_hp * -0.1, 0.1)
		ACCURACY_UP:
			character.base_accuracy = 1
		POISON:
			character.deal_damage(-8, 0.1)
		_:
			pass

func stop_buff(character : Character, buff):
	match(buff):
		ACCURACY_UP:
			character.base_accuracy = 0.7
		BURN:
			var effect = character.get_node_or_null("FireBuff")
			if effect != null:
				effect.queue_free()
		POISON:
			var effect = character.get_node_or_null("PosionBuff")
			if effect != null:
				effect.queue_free()
		SPEED_UP:
			character.SPEED = character.SPEED / 1.5
		_:
			pass
