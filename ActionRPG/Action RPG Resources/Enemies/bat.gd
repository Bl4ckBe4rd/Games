extends CharacterBody2D

@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var sprite = $AnimatedSprite
@onready var hurtbox = $Hurtbox

const DeathEffect = preload("res://Action RPG Resources/Effects/death_effect.tscn")

@export var ACCELERATION = 100
@export var MAX_SPEED = 30
@export var FRICTION = 100

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = CHASE

var knockback = Vector2.ZERO

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 10 * delta)
	velocity += knockback
	move_and_collide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
			
	move_and_slide()

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_hurtbox_area_entered(area):
	
	stats.health -= area.damage
	knockback = area.knockback_vector * 4
	hurtbox.create_hit_effect()
#	queue_free()

func _on_stats_no_health():
	queue_free()
	var enemy_death_effect = DeathEffect.instantiate()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position
