class_name FishHook

extends RigidBody2D

var reset = false
var caught_fish: Fish = null

func _ready() -> void:
	if not is_instance_valid($/root/game/camera):
		print('cannot find camera in scene tree')

func hit_water():
	linear_damp = 10
	var line = get_parent() as FishingLine
	line.current_state = line.LineState.FLOATING
	get_tree().create_tween().tween_property(self, 'gravity_scale', 0, 2)

func _process(delta: float) -> void:
	# pull fish to self
	if caught_fish != null:
		caught_fish.global_position = global_position
	
	if is_instance_valid($/root/game/camera):
		$/root/game/camera.position.x = lerp($/root/game/camera.position.x, position.x, 0.3)

func reel_in():
	await get_tree().process_frame
	freeze = true
	get_parent().set_current_state(get_parent().LineState.IDLE)
	var tween = get_tree().create_tween()
	tween.tween_property(self, 'position', Vector2.ZERO, 1)
	await tween.finished
	reset = true

	var fish = caught_fish
	caught_fish.queue_free()
	caught_fish = null
	return fish

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if reset:
		reset = false
		state.transform = Transform2D(0, Vector2.ZERO)
		position = Vector2(0,0)

func get_line() -> FishingLine:
	return get_parent() as FishingLine
