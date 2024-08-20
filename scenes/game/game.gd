extends Node2D

var current_time = -1
var fishing_checks = 0

var max_fish = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$hud.high_score = high_score()
	for i in range(30):
		spawn_fish()
	
	await $dialog.run_script('intro')
	current_time = 0

func _physics_process(delta: float) -> void:
	if current_time != -1:
		current_time += delta
	if int(current_time) % 30 >= fishing_checks:
		fishing_check()
		fishing_checks += 1

func _process(delta: float) -> void:
	$hud.set_time(max(current_time, 0))

func spawn_fish():
	var fish = load('res://scenes/objects/fish/fish.tscn').instantiate()
	$water.add_child(fish)
	
	# randomise point in the water
	fish.global_position = $water/shape.global_position
	fish.position.x += randi_range(-$water/shape.shape.size.x/2+80, $water/shape.shape.size.x/2-80)
	fish.position.y += randi_range(-$water/shape.shape.size.y/2+80, $water/shape.shape.size.y/2-80)

func fishing_check():
	# spawn the fish environment protection police
	var path = 'res://assets/scripts/inspector/pre-check/'
	var files = []
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and not file_name.ends_with('.import'):
			files.append(file_name)
		file_name = dir.get_next()

	var randfile = randi_range(0, len(files)-1)

	await %dialog.run_script('inspector/pre-check/' + randfile)

	if $hud.score <= max_fish:
		path = 'res://assets/scripts/inspector/pass/'
	else:
		path = 'res://assets/scripts/inspector/fail/'
	
	files = []
	dir = DirAccess.open(path)
	dir.list_dir_begin()
	file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and not file_name.ends_with('.import'):
			files.append(file_name)
		file_name = dir.get_next()

	randfile = randi_range(0, len(files)-1)
	
	if $hud.score <= max_fish:
		await %dialog.run_script('inspector/pass' + randfile)
	else:
		await %dialog.run_script('inspector/fail' + randfile)
		get_tree().change_scene_to_file('res://scenes/game/main_menu.tscn')


func high_score():
	var save_file = ConfigFile.new()
	save_file.load('user://highscore')
	return save_file.get_value('high', 'score', 0)

func save_score(score):
	var save_file = ConfigFile.new()
	save_file.set_value('high', 'score', score)
	save_file.set_value('high', 'time', current_time)
	save_file.save('user://highscore')
