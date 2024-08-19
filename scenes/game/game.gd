extends Node2D

var current_time = 0
var fishing_checks = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$dialog.run_script('intro')
	for i in range(30):
		spawn_fish()

func _physics_process(delta: float) -> void:
	current_time += delta
	if int(current_time) % 30 >= fishing_checks:
		fishing_check()
		fishing_checks += 1

func _process(delta: float) -> void:
	$hud.set_time(current_time)

func spawn_fish():
	var fish = load('res://scenes/objects/fish/fish.tscn').instantiate()
	$water.add_child(fish)
	
	# randomise point in the water
	fish.global_position = $water/shape.global_position
	fish.position.x += randi_range(-$water/shape.shape.size.x/2+80, $water/shape.shape.size.x/2-80)
	fish.position.y += randi_range(-$water/shape.shape.size.y/2+80, $water/shape.shape.size.y/2-80)

func fishing_check():
	# spawn the fish environment protection police
	pass

func save_score():
	pass
	## template code
	# var save_game = File.new()
    # save_game.open("user://savegame.save", File.WRITE)
    # var save_nodes = get_tree().get_nodes_in_group("Persist")
    # for i in save_nodes:
    #     var node_data = i.call("save");
    #     save_game.store_line(to_json(node_data))
    # save_game.close()
