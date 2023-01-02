extends Node2D

const grass_effect = preload("res://Action RPG Resources/Effects/grass_effect.tscn")

func create_grass_effect():
	
	var GrassEffect = grass_effect.instantiate()
	var world = get_tree().current_scene
	world.add_child(GrassEffect)
	GrassEffect.global_position = global_position


func _on_hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
