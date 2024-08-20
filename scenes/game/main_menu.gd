extends Node2D

## Continue -> Hide MainMenu 
## Tutorial -> Play Tutorial
## Settings -> Open Settings
## Exit to Tile -> Open Title Screen
## Quit Game -> take a wild guess as to what this needs to do



func _on_quit_game_pressed() -> void:
	$clicksound.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
	

func _on_continue_pressed() -> void:
	$clicksound.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file('res://scenes/game/game.tscn')


func _on_tutorial_pressed() -> void:
	$clicksound.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file('res://scenes/game/tutorial.tscn')


func _on_settings_pressed() -> void:
	$clicksound.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file('res://scenes/game/settings.tscn')


func _on_exit_to_title_pressed() -> void:
	$clicksound.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file('res://scenes/game/title.tscn')
