class_name Fish

extends CharacterBody2D

var curiosity: float = 1
var target_position = Vector2.ZERO
var move_distance = 80
var is_garbage = false
var is_redacted = false

enum FishState {
	IDLE,
	SEENHOOK,
	CURIOUS,
	CAUGHT,
}

var current_state = FishState.IDLE
var hook: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var path = 'res://assets/textures/objects/fish/'
	
	# 1/4 fish are garbage
	if randi() % 4 == 0:
		is_garbage = true
		$hookdetector/shape.disabled = true
		$hookdetector/garbageshape.disabled = false
		path = 'res://assets/textures/objects/garbage/'
	
	# 1/20 fish are beeg fish or redacted fish
	if randi() % 20 == 0:
		is_redacted = true
		# $hookdetector/shape.shape.radius /= 2
		path = 'res://assets/textures/objects/fish/rare/'
	
	var files = []
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with('.import'):
			files.append(file_name.left(-7))
		file_name = dir.get_next()

	var randfile = randi_range(0, len(files)-1)

	$sprite.texture = ResourceLoader.load(path+files[randfile])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# stop chasing an already taken hook
	if (current_state == FishState.CURIOUS or current_state == FishState.SEENHOOK) and hook != null and (hook.caught_fish != null or hook.get_line().current_state != hook.get_line().LineState.FLOATING):
		current_state = FishState.IDLE
	
	if current_state == FishState.SEENHOOK:
		if randi_range(0, 100) == 0:
			current_state = FishState.CURIOUS
		
	if current_state == FishState.CURIOUS and reached_target():
		hook.caught_fish = self
		current_state = FishState.CAUGHT
	elif current_state == FishState.CURIOUS:
		target_position = hook.global_position
	
	if (current_state == FishState.IDLE or current_state == FishState.SEENHOOK):
		# find new spot
		if reached_target():
			var water_shape = ($"../shape" as CollisionShape2D)
			
			if is_garbage:
				$sprite.position.y = sin(Time.get_ticks_msec()/500.0) * 10
				target_position = global_position
			else:
				# generate random offset
				var randx = randi_range(-move_distance, move_distance)
				var randy = randi_range(-move_distance, move_distance)
				target_position = global_position + Vector2(randx, randy)
			

			# ensure fish stays in water
			target_position = target_position.clamp(water_shape.global_position-water_shape.shape.size/2+Vector2(80,80), water_shape.global_position+water_shape.shape.size/2-Vector2(80,80))
		
	if current_state != FishState.CAUGHT:
		var movevec = (target_position - global_position)
		velocity = movevec * 2
		move_and_slide()

func reached_target():
	return (target_position - global_position).length_squared() < 8 or target_position == Vector2.ZERO

func on_hook_area_enter(body: Node2D):
	if body is FishHook and body.get_line().current_state == body.get_line().LineState.FLOATING:
		current_state = FishState.SEENHOOK
		hook = body
