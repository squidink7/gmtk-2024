extends CharacterBody2D

var curiosity: float = 1
var target_position = Vector2.ZERO
var move_distance = 80

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var movevec = (target_position - global_position)

	# find new spot
	if movevec.length_squared() < 8 or target_position == Vector2.ZERO:
		var water_shape = ($"../shape" as CollisionShape2D)
		
		# generate random offset
		var randx = randi_range(-move_distance, move_distance)
		var randy = randi_range(-move_distance, move_distance)
		
		target_position = global_position + Vector2(randx, randy)

		# ensure fish stays in water
		target_position = target_position.clamp(water_shape.global_position-water_shape.shape.size/2+Vector2(80,80), water_shape.global_position+water_shape.shape.size/2-Vector2(80,80))
		
	velocity = movevec * 2
	move_and_slide()
