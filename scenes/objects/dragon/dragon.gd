extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$sprite.play('idle')

func _process(delta: float) -> void:
	if %fishingline.current_state == %fishingline.LineState.IDLE and is_instance_valid(%fishingline) and %fishingline.state_progress != 0:
		if $sprite.animation != 'prime':
			$sprite.animation = 'prime'
			$sprite.stop()
		var frame = int(%fishingline.state_progress * 3)
		$sprite.frame = frame
		%fishingline.set_line_origin($primeanimpoints.get_child(frame).global_position)
	elif %fishingline.current_state == %fishingline.LineState.CAST:
		if $sprite.animation != 'cast':
			$sprite.play('cast')
		print($sprite.frame)
		%fishingline.set_line_origin($castanimpoints.get_child($sprite.frame).global_position)
