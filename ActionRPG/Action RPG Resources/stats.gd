extends Node

var DEATH = 0
@export var max_health = 1
signal no_health
signal health_changed(value)

@onready var health = max_health:
	set = set_health
#		emit_signal("health_changed", health)
#		if health <= DEATH:
#			emit_signal("no_health")
func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= DEATH:
		emit_signal("no_health")
