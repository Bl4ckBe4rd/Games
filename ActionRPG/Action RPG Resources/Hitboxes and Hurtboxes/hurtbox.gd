extends Area2D

@onready var timer = $Timer
#@export var show_hit := true
const hit_effect = preload("res://Action RPG Resources/Effects/hit_effect.tscn")

signal invincibility_started
signal invincibility_ended
@onready var invincible = true:
	set(value):
		invincible = value
		if invincible == true:
			emit_signal('invincibility_started')
		else:
			emit_signal('invincibility_ended')
	
func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = hit_effect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_timer_timeout():
	self.invincible == false


func _on_invincibility_started():
	set_deferred("monitorable", false)


func _on_invincibility_ended():
	set_deferred("monitorable", true)
