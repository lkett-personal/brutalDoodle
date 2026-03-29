extends CharacterBody2D
@export var WALK_SPEED = 200.0
@export var SPRINT_SPEED = 400.0
@export var ACCELERATION = 1500.0
@export var FRICTION = 1200.0
@export var JUMP_VELOCITY = -500.0
@export var sprite : AnimatedSprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if not Input.is_action_pressed("jump") and velocity.y < 0:
		velocity.y = 0.4

	var direction = Input.get_axis("move_left", "move_right")
	var target_speed = SPRINT_SPEED if Input.is_action_pressed("sprint") else WALK_SPEED

	if direction:
		velocity.x = move_toward(velocity.x, direction * target_speed, ACCELERATION * delta)
		sprite.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	move_and_slide()

	if not is_on_floor():
		if velocity.y < 0:
			sprite.play("jump")
		else:
			if velocity.y >= 400:
				sprite.play("fast_fall")
			elif velocity.y > 1:
				sprite.play("fall")
	else:
		if direction:
			if Input.is_action_pressed("sprint"):
				sprite.play("run")
			else:
				sprite.play("walk")
		else:
			if abs(velocity.x) > 0:
				sprite.play("decel")
			else:
				sprite.play("idle")
