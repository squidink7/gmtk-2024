extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$dialog.run_script('intro')
	for i in range(100):
		spawn_fish()

func spawn_fish():
	var fish = load('res://scenes/objects/fish/fish.tscn').instantiate()
	$water.add_child(fish)
	
	# randomise point in the water
	fish.global_position = $water/shape.global_position
	fish.position.x += randi_range(-$water/shape.shape.size.x/2+80, $water/shape.shape.size.x/2-80)
	fish.position.y += randi_range(-$water/shape.shape.size.y/2+80, $water/shape.shape.size.y/2-80)
