extends CharacterBody2D
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var state_machine = animationTree.get('parameters/playback')

@export var ACCELERATION = 400
@export var MAX_SPEED = 80
@export var FRICTION = 400

func _ready():
	animationTree.active = true
func _physics_process(delta):
	var input_vector = Vector2(
	Input.get_action_strength("walkRight") - Input.get_action_strength("walkLeft"),
	Input.get_action_strength("walkDown") - Input.get_action_strength("walkUp"))
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animationTree.set('parameters/idle/blend_position', input_vector)
		animationTree.set('parameters/walk/blend_position', input_vector)
		state_machine.travel('walk')
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		state_machine.travel('idle')
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
