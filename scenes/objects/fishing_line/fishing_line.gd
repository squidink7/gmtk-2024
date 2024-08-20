class_name FishingLine

extends Node2D

var current_state = LineState.IDLE
var state_progress: float = 0.0
var cast_force: float = 0

signal caught_fish(fish: Fish)

enum LineState {
	IDLE,
	PRIMED,
	CASTING,
	CAST,
	FLOATING
}

var sounds = {
	'cast': load('res://assets/audio/sfx/rod cast whip.ogg'),
	'reel_in': load('res://assets/audio/sfx/rod reel in.ogg'),
	'prime_start': load('res://assets/audio/sfx/rod initial pull-back.ogg'),
	'primed': load('res://assets/audio/sfx/pull-back buildup.ogg'),
	'splash': load('res://assets/audio/sfx/sinker splash.ogg'),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# move and progrss to next line state
	match current_state:
		LineState.IDLE:
			$hook.freeze = true
			# pull hook back to idle if user doesn't keep pulling
			state_progress -= 0.01
			state_progress = max(state_progress, 0)
			
			if state_progress == 0:
				$audio.stop()
			else:
				$audio.stream = sounds['prime_start']
				$audio.play()


			# set the hook to primed
			if state_progress >= 1:
				cast_force = 0
				$hook.linear_damp = 1
				$hook.gravity_scale = 1
				set_current_state(LineState.PRIMED)
		
		LineState.PRIMED:
			pass
			$audio.stream = sounds['primed']
		
		LineState.CASTING:
			fling_line(delta)
			# state_progress measures time left to add force to the flick
			state_progress += 0.08
			$audio.stream = sounds['cast']
			$audio.play()
			if state_progress >= 1:
				set_current_state(LineState.CAST)
		LineState.CAST:
			state_progress += 1
		LineState.FLOATING:
			pass
	
	$line.points[1] = $hook.position

func set_current_state(state):
	current_state = state
	state_progress = 0

func fling_line(delta: float):
	cast_force -= 0.1 * delta * 60
	cast_force = max(cast_force, 0)
	$hook.apply_central_force(Vector2(cast_force, -cast_force/2))

func set_line_origin(pos: Vector2):
	$line.points[0] = to_local(pos)

func _input(event: InputEvent) -> void:
	# don't move if dialog active
	if $/root/game/dialog.visible:
		return
	
	if event is InputEventMouseMotion:
		
		match current_state:
			LineState.IDLE:
				# pull back on line
				if event.relative.x < 0:
					# only draw back when holding the mouse button
					if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
						state_progress -= max(event.relative.x / 200, -0.03)
					else:
						if event.relative.x <= -0.15:
							# show "hold down mouse" label
							pass

			LineState.PRIMED:
				if event.relative.x >= 0.2 and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					set_current_state(LineState.CASTING)
					$audio.stream = sounds['cast']
					$audio.play()
					$hook.freeze = false

			LineState.CASTING:
				# flick line forward
				if event.relative.x > 0:
					# this does *not* scale with delta, should fix
					cast_force += event.relative.x * 10
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if current_state == LineState.FLOATING:
				var fish = await $hook.reel_in()
				$audio.stream = sounds['reel_in']
				$audio.play()
				if fish != null:
					caught_fish.emit(fish)
