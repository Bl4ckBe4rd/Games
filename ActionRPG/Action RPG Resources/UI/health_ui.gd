extends Control

@onready var label = $Label

@onready var hearts = 4:
	set(value):
		hearts = value
@onready var max_hearts = 4:
	set(value):
		max_hearts = value
	
func set_hearts(value):
	hearts = value
	if label != value:
		label.text = "HP = " + str(hearts)

func set_max_hearts(value):
	max_hearts = value
		
func _ready():
	max_hearts = PlayerStats.max_health
	hearts = PlayerStats.health
	PlayerStats.health_changed.connect(set_hearts)
