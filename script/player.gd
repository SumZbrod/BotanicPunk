class_name PlayerClass extends CharacterBody2D
const MAX_SPEED = 800
const DASH_SPEED = 2000
const AXCELERATION = 4000
const JUMP_SPEED = -400
const DASH_SPEED_Y = 100
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
var is_attack: bool
var attack_frame: int
@onready var attack_area: AttackAreaNode = $AttackArea

func _ready() -> void:
	animated_sprite_2d.play("IDLE")

func _process(_delta: float) -> void:
	move_and_slide()

func _physics_process(delta: float) -> void:
	_handle_gravity(delta)
	_handle_input(delta)
	
func _handle_gravity(delta):
	if jump_time > 0:
		jump_time -= delta
	elif not is_on_floor():
		jump_time = 0
		var gravity = get_gravity() * delta 
		velocity += gravity
		if !is_attack:
			animated_sprite_2d.pause()

func _handle_input(delta):
	_handle_attack(delta)
	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_action_pressed("sprint"):
		sprint_mode = true
	else:
		sprint_mode = false
	
	if is_on_floor():
		animated_sprite_2d.play()
		dash_accepted = true
	elif dash_accepted and Input.is_action_just_pressed("sprint"):
		dash_accepted = false
		if !animated_sprite_2d.flip_h:
			velocity.x += DASH_SPEED
		else:
			velocity.x += -DASH_SPEED
		velocity.y = min(0, velocity.y) - DASH_SPEED_Y 
	if direction:
		if sprint_mode:
			velocity.x = move_toward(velocity.x, sprint_coeff*direction*MAX_SPEED, AXCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, direction*MAX_SPEED, AXCELERATION * delta)
		if !is_attack and animated_sprite_2d.animation != "WALK":
			animated_sprite_2d.play("WALK")
			if !is_on_floor() and !is_attack:
				animated_sprite_2d.pause()
	else:
		velocity.x = move_toward(velocity.x, 0, AXCELERATION * delta)
		if !is_attack and animated_sprite_2d.animation != "IDLE":
			animated_sprite_2d.play("IDLE")
	if (direction < 0 and !animated_sprite_2d.flip_h) or (direction > 0 and animated_sprite_2d.flip_h):
		animated_sprite_2d.flip_h = not animated_sprite_2d.flip_h
		
	if Input.is_action_just_pressed("ui_accept"):
		if is_character_can_jump():
			current_add_jumps_count = 0
			velocity.y = JUMP_SPEED
			velocity.x /= 2
			jump_time = jump_max_time
			if !is_attack:
				animated_sprite_2d.pause()
		elif current_add_jumps_count < max_add_jumps_count:
			current_add_jumps_count += 1
			velocity.y = JUMP_SPEED
			jump_time = jump_max_time
			animated_sprite_2d.frame += 2
	elif Input.is_action_just_released("ui_accept"):
		jump_time = 0
		if velocity.y < 0:
			velocity.y /= 2

func is_character_can_jump() -> bool:
	return jump_area.is_can_jump()

func _handle_attack(_delta):
	if Input.is_action_just_pressed('attack'):
		animated_sprite_2d.play("ATTACK")
		attack_area.attack(!animated_sprite_2d.flip_h)
		is_attack = true
		attack_frame = 0
	if attack_frame < animated_sprite_2d.frame:
		attack_frame = animated_sprite_2d.frame
	elif attack_frame > animated_sprite_2d.frame:
		is_attack = false
