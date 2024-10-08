extends Node2D

var current_time = -1
var fishing_checks = 0

var max_fish = 5
var inspector_time = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$hud.set_highscore(high_score())
	for i in range(30):
		spawn_fish()
	
	await $dialog.run_script('intro')
	current_time = 0

func _physics_process(delta: float) -> void:
	if current_time != -1:
		current_time += delta
	if int(current_time) / inspector_time > fishing_checks:
		fishing_checks += 1

		if fishing_checks == 1:
			$dialog.run_script('inspector/inspectorintro')
		else:
			fishing_check()

func _process(delta: float) -> void:
	$hud.set_time(max(current_time, 0))
	

func spawn_fish():
	var fish = ResourceLoader.load('res://scenes/objects/fish/fish.tscn').instantiate()
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
	dir.list_dir_end()

	var randfile = randi_range(0, len(files)-1)

	await %dialog.run_script('inspector/pre-check/' + files[randfile].left(-4))

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
	dir.list_dir_end()

	randfile = randi_range(0, len(files)-1)
	
	if $hud.score <= max_fish:
		await %dialog.run_script('inspector/pass/' + files[randfile].left(-4))
	else:
		await %dialog.run_script('inspector/fail/' + files[randfile].left(-4))
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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT):
		get_tree().change_scene_to_file('res://scenes/game/main_menu.tscn')