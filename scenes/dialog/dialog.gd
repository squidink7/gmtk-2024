extends CanvasLayer

var script_lines = []
var current_line = 0
var character_textures = []
var current_character_texture = 0

func run_script(script_name):
	visible = true
	var file = FileAccess.open("res://assets/scripts/" + script_name + ".txt", FileAccess.READ)
	var script_text = file.get_as_text()

	script_lines = script_text.split('\n')
	next_line()

func next_line():	
	while script_lines[current_line].begins_with('/CHAR'):
		# load character textures
		var character_texture_names = script_lines[current_line].split(' ').slice(1)
		character_textures = []
		
		for tex in character_texture_names:
			character_textures.append(load('res://assets/textures/objects/' + tex + '.png'))
		
		update_character_texture()
		current_line += 1

	%line_display.text = script_lines[current_line]

	current_line += 1


func update_character_texture():
	current_character_texture += 1
	if current_character_texture >= len(character_textures):
		current_character_texture = 0
	$character.texture = character_textures[current_character_texture]