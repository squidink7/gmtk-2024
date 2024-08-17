extends Node2D

var current_state = LineState.IDLE
var state_progress: float = 0.0
var cast_force: float = 0

enum LineState {
	IDLE,
	PRIMED,
	CASTING,
	CAST
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	# move and progrss to next line state
	match current_state:
		LineState.IDLE:
			# pull hook back to idle if user doesn't keep pulling
			state_progress -= 0.05
			state_progress = max(state_progress, 0)
			%hook.position.x = lerp(0.0, -100.0, state_progress)
			if state_progress >= 1:
				current_state = LineState.PRIMED
				state_progress = 0
		LineState.CASTING:
			fling_line()
			# state_progress measures time left to add force to the flick
			state_progress += 0.1
			if state_progress >= 1:
				current_state = LineState.CAST
				state_progress = 0
		LineState.CAST:
			state_progress += 1
			fling_line()
	
	# print(current_state)

func fling_line():
	cast_force -= 0.1
	cast_force = max(cast_force, 0)
	%hook.position.x += cast_force
	%hook.position.y += state_progress

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
					current_state = LineState.CASTING
			LineState.CASTING:
				# flick line forward
				if event.relative.x > 0:
					cast_force += event.relative.x / 10
