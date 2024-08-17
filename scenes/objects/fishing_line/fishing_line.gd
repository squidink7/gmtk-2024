class_name FishingLine

extends Node2D

var current_state = LineState.IDLE
var state_progress: float = 0.0
var cast_force: float = 0

enum LineState {
	IDLE,
	PRIMED,
	CASTING,
	CAST,
	FLOATING
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
			state_progress -= 0.05
			state_progress = max(state_progress, 0)
			$hook.position.x = lerp(0.0, -100.0, state_progress)
			if state_progress >= 1:
				cast_force = 0
				set_current_state(LineState.PRIMED)
		LineState.CASTING:
			fling_line()
			# state_progress measures time left to add force to the flick
			state_progress += 0.1
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

func fling_line():
	cast_force -= 0.1
	cast_force = max(cast_force, 0)
	$hook.apply_central_force(Vector2(cast_force, -cast_force/2))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		match current_state:
			LineState.IDLE:
				# pull back on line
				if event.relative.x < 0:
					# only draw back when holding the mouse button
					if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
						state_progress -= max(event.relative.x / 100, -0.15)
					else:
						if event.relative.x <= -0.15:
							# show "hold down mouse" label
							pass
			LineState.PRIMED:
				if event.relative.x >= 0.2:
					set_current_state(LineState.CASTING)
					$hook.freeze = false
			LineState.CASTING:
				# flick line forward
				if event.relative.x > 0:
					cast_force += event.relative.x * 10
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if current_state == LineState.FLOATING:
				$hook.reel_in()
