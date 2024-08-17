extends Area2D

func on_water_entered(body: Node2D) -> void:
	if body is FishHook:
		body.hit_water()


func on_boundry_entered(body: Node2D) -> void:
	if body is FishHook:
		body.reel_in()
