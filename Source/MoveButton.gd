extends Button

var move_id = 0


func _ready():
	var move_name = Moves.INFO[move_id][Moves.INFO_NAME]
	var cost = Moves.INFO[move_id][Moves.INFO_COST]
	var cost_string = Moves.INFO[move_id][Moves.INFO_COST_STRING]
	$MoveName.text = move_name
	if cost == null:
		$MoveCost.text = "Free"
	else:
		if cost_string == null:
			$MoveCost.text = str(cost) + " AP"
		else:
			$MoveCost.text = str(cost_string)

