extends CharacterBody2D

@export var movement_data: PlayerMovementData

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer

func _physics_process(delta: float) -> void:
	var input_axis := Input.get_axis("ui_left", "ui_right")
	
	apply_gravity(delta)
	handle_jump()
	handle_movement(input_axis, delta)
	update_animations(input_axis)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	
	if just_left_ledge:
		coyote_jump_timer.start()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * movement_data.gravity_scale * delta

func handle_jump() -> void:
	if is_on_floor() or coyote_jump_timer.time_left > 0.0: 
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = movement_data.jump_velocity 
	if not is_on_floor():
		if  (Input.is_action_just_released("ui_up") and velocity.y < movement_data.jump_velocity / 2):
			velocity.y = movement_data.jump_velocity / 2		

func handle_movement(input_axis: float, delta: float) -> void:
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	apply_air_resistance(input_axis, delta)

func apply_friction(input_axis: float, delta: float) -> void:
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction)

func apply_air_resistance(input_axis: float, delta: float) -> void:
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance)

func handle_acceleration(input_axis: float, delta: float) -> void:
	if input_axis == 0: return
	velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration)

func update_animations(input_axis: float) -> void:
	if input_axis != 0:
		handle_character_orientation(input_axis)
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")

	if not is_on_floor():
		animated_sprite_2d.play("jump")		

func handle_character_orientation (input_axis: float) -> void:
	animated_sprite_2d.flip_h = input_axis < 0
