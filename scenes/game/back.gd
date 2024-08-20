extends Button


func _on_pressed() -> void:
	$clicksound.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file('res://scenes/game/main_menu.tscn')
