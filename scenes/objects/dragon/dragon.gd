extends Node2D

signal add_score(score: int)

var sounds = {
	'good_catch': load('res://assets/audio/sfx/good catch.ogg'),
	'bad_catch': load('res://assets/audio/sfx/bad catch.ogg'),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$sprite.play('idle')
	%fishingline.set_line_origin($primeanimpoints.get_child(0).global_position)

func _process(delta: float) -> void:
	if %fishingline.current_state == %fishingline.LineState.IDLE and is_instance_valid(%fishingline) and %fishingline.state_progress != 0:
		if $sprite.animation != 'prime':
			$sprite.animation = 'prime'
			$sprite.stop()
		var frame = int(%fishingline.state_progress * 3)
		$sprite.frame = frame
		
		$hookpath/pathfollow.progress_ratio = clamp(%fishingline.state_progress, 0, 1)
		%fishingline.set_line_origin($primeanimpoints.get_child($sprite.frame).global_position)


	elif %fishingline.current_state == %fishingline.LineState.IDLE and %fishingline.state_progress == 0:
		if $sprite.animation != 'idle':
			$sprite.play('idle')
		
		$hookpath/pathfollow.progress_ratio = clamp(%fishingline.state_progress, 0, 1)
		%fishingline.set_line_origin($idleanimpoints.get_child($sprite.frame).global_position)
		
	
	elif %fishingline.current_state == %fishingline.LineState.CAST:
		if $sprite.animation != 'cast':
			$sprite.play('cast')

		%fishingline.set_line_origin($castanimpoints.get_child($sprite.frame).global_position)

func caught_fish(fish: Fish):
	if not fish.is_garbage:
		add_score.emit(1)
		$audio.stream = sounds['good_catch']
	else:
		$audio.stream = sounds['bad_catch']

	$audio.play()
