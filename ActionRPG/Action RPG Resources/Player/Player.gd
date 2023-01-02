extends CharacterBody2D

const ACCELERATION = 400
const MAX_SPEED = 80
const FRICTION = 400
var roll_vector = Vector2.DOWN
const roll_speed = 110
#var stats = PlayerStats

enum {
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE
@onready var Animation_Player = $AnimationPlayer
@onready var Animation_Tree = $AnimationTree
@onready var state_machine = Animation_Tree.get('parameters/playback')
@onready var swordHitbox = $HitboxPivot/SwordHitbox

@onready var stats = $Stats
@onready var hurtbox = $Hurtbox

func _ready():
	
	Animation_Tree.active = true
	swordHitbox.knockback_vector = roll_vector
	
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2(
	Input.get_action_strength("right") - Input.get_action_strength("left"),
	Input.get_action_strength("down") - Input.get_action_strength("up"))
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		Animation_Tree.set('parameters/idle/blend_position', input_vector)
		Animation_Tree.set('parameters/walk/blend_position', input_vector)
		Animation_Tree.set('parameters/attack/blend_position', input_vector)
		Animation_Tree.set('parameters/roll/blend_position', input_vector)
		state_machine.travel('walk')
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)	
	else:
		state_machine.travel('idle')
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()
	
	if Input.is_action_just_pressed('attack'):
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
func roll_state(delta):
	velocity = roll_vector * roll_speed
	state_machine.travel('roll')
	move()
func attack_state(delta):
	velocity = velocity * 0.8
	state_machine.travel('attack')
func move():
	var _move = move_and_slide()
func roll_state_finished():
	velocity = Vector2.ZERO
	state = MOVE
func attack_animation_finished():
	state = MOVE


func _on_hurtbox_area_entered(area):
	stats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()


func _on_stats_no_health():
	queue_free()
