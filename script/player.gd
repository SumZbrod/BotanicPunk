class_name PlayerClass extends MobClass

var is_can_jump := true
var cayoit_timer := 0.
var max_cayoit_timer := .2

func _physics_process(delta: float) -> void:
	_check_is_can_jump(delta)
	_handle_jump()
	_handle_input()
	super(delta)
	
func _handle_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func _handle_input():
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _handle_jump():
	if Input.is_action_just_pressed("ui_accept") and is_can_jump:
		velocity.y = JUMP_VELOCITY

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
