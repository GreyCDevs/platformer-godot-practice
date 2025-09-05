extends CharacterBody2D


const SPEED = 100.0
const ACCELERATION = 800.0
const FRICTION = 1000.0
const JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	handle_jump()

	handle_movement(delta)

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_jump() -> void:
	if not is_on_floor(): 
		if Input.is_action_just_released("ui_accept") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2		
	else: 
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY


func handle_movement(delta: float) -> void:
	var input_axis := Input.get_axis("ui_left", "ui_right")

	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)

	move_and_slide()

func apply_friction(input_axis: float, delta: float) -> void:
	if input_axis != 0: return
	velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func handle_acceleration(input_axis: float, delta: float) -> void:
	if input_axis == 0: return
	velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCELERATION * delta)
