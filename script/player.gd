class_name PlayerClass extends MobClass

var is_can_jump := true
var cayoit_timer := 0.
var max_cayoit_timer := .2
var jump_time := 0.
var max_jump_time := 1.

func _physics_process(delta: float) -> void:
	_handle_input(delta)
	super(delta)

func _handle_input(delta):
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			is_can_jump = true
	if is_can_jump and Input.is_action_pressed("ui_accept"):
		jump_time += delta
		if jump_time >= max_jump_time:
			is_can_jump = false
			jump_time = 0 
		else:
			velocity.y += jump_acceleration * delta
			if velocity.y < max_jump_velocity:
				print(jump_time)
				velocity.y = max_jump_velocity
				is_can_jump = false
	else:
		_check_is_can_jump(delta)

func _check_is_can_jump(delta):
	if is_can_jump:
		if !is_on_floor():
			cayoit_timer += delta
		else:
			cayoit_timer = 0
		if cayoit_timer >= max_cayoit_timer:
			cayoit_timer = 0
			is_can_jump = false
	if is_on_floor():
		is_can_jump = true
