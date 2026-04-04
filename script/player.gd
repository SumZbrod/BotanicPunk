class_name PlayerClass extends CharacterBody2D
const MAX_SPEED = 800
const DASH_SPEED = 1500
const AXCELERATION = 4000
const JUMP_SPEED = -400
@export var max_jump_velocity := -200
@export var jump_acceleration := -5000
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_area: JumpAreaNode = $JumpArea
var sprint_mode : bool
var max_add_jumps_count: int = 1
var current_add_jumps_count: int = 2
var sprint_coeff := 1.5
var jump_max_time := .2
var jump_time := 0.
var dash_accepted : bool
func _ready() -> void:
	animated_sprite_2d.play("IDLE")

func _physics_process(delta: float) -> void:
	_handle_gravity(delta)
	_handle_input(delta)
	move_and_slide()
	
func _handle_gravity(delta):
	if jump_time > 0:
		jump_time -= delta
	elif not is_on_floor():
		jump_time = 0
		var gravity = get_gravity() * delta 
		velocity += gravity

func _handle_input(delta):
	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_action_pressed("sprint"):
		sprint_mode = true
	else:
		sprint_mode = false
	
	if is_on_floor():
		dash_accepted = true
	elif dash_accepted and Input.is_action_just_pressed("sprint"):
		dash_accepted = false
		if animated_sprite_2d.flip_h:
			velocity.x += DASH_SPEED
		else:
			velocity.x += -DASH_SPEED
	if direction:
		if sprint_mode:
			velocity.x = move_toward(velocity.x, sprint_coeff*direction*MAX_SPEED, AXCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, direction*MAX_SPEED, AXCELERATION * delta)
		if animated_sprite_2d.animation != "WALK":
			animated_sprite_2d.play("WALK")
	else:
		velocity.x = move_toward(velocity.x, 0, AXCELERATION * delta)
		
		if animated_sprite_2d.animation != "IDLE":
			animated_sprite_2d.play("IDLE")
	if (direction < 0 and animated_sprite_2d.flip_h) or (direction > 0 and !animated_sprite_2d.flip_h):
		animated_sprite_2d.flip_h = not animated_sprite_2d.flip_h
		
	if Input.is_action_just_pressed("ui_accept"):
		if is_character_can_jump():
			current_add_jumps_count = 0
			velocity.y = JUMP_SPEED
			velocity.x /= 2
			jump_time = jump_max_time
		elif current_add_jumps_count < max_add_jumps_count:
			current_add_jumps_count += 1
			velocity.y = JUMP_SPEED
			jump_time = jump_max_time
	elif Input.is_action_just_released("ui_accept"):
		jump_time = 0
		if velocity.y < 0:
			velocity.y /= 2

func is_character_can_jump() -> bool:
	return jump_area.is_can_jump()
