extends CanvasLayer

var script_lines = []
var current_line = 0
var character_textures = []
var current_character_texture = 0

signal script_end

func run_script(script_name):
	visible = true
	current_line = 0
	script_lines = []
	character_textures = []
	current_character_texture = 0
	var file = FileAccess.open("res://assets/scripts/" + script_name + ".txt", FileAccess.READ)
	
	if not file:
		print('Error opening script: ' + script_name)
		return
	
	var script_text = file.get_as_text()

	script_lines = script_text.split('\n')
	next_line()

	await script_end

func next_line():
	# script complete
	if current_line >= len(script_lines):
		close_dialog()
		return

	while script_lines[current_line].begins_with('/CHAR'):
		# load character textures
		var character_texture_names = script_lines[current_line].split(' ').slice(1)
		character_textures = []
		
		for tex in character_texture_names:
			character_textures.append(ResourceLoader.load('res://assets/textures/objects/' + tex + '.png'))
		
		update_character_texture()
		current_line += 1
		if current_line >= len(script_lines):
			close_dialog()
			return
	
	while script_lines[current_line] == '':
		current_line += 1
		if current_line >= len(script_lines):
			close_dialog()
			return
	
	# play voice line
	$voice.play()
	$voice/timer.wait_time = max(float(len(script_lines[current_line])) / 20.0, 1)
	$voice/timer.start()
	$character_timer.start()

	# show line
	%line_display.text = '\n'+script_lines[current_line]

	current_line += 1

func update_character_texture():
	current_character_texture += 1
	if current_character_texture >= len(character_textures):
		current_character_texture = 0
	
	if len(character_textures) == 0:
		print('No character textures!')
		return
	
	$character.texture = character_textures[current_character_texture]

func on_background_gui_input(event:InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		next_line()

func stop_voice() -> void:
	$voice.stop()
	current_character_texture = -1
	update_character_texture()
	$character_timer.stop()


func close_dialog() -> void:
	visible = false
	$voice.stop()
	script_end.emit()
