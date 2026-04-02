class_name PlayerClass extends CharacterBody2D
const MAX_SPEED := 800
const AXCELERATION := 4000
const JUMP_SPEED := -600
@export var max_jump_velocity := -200
@export var jump_acceleration := -5000
@onready var sprite_animation: AnimationPlayer = $SpriteAnimation
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_area: JumpAreaNode = $JumpArea
var sprint_mode : bool
var max_add_jumps_count: int = 1
var current_add_jumps_count: int = 2
var sprint_coeff := 1.5

func _ready() -> void:
	sprite_animation.play("IDLE")

func _physics_process(delta: float) -> void:
	_handle_gravity(delta)
	_handle_input(delta)
	move_and_slide()
	
func _handle_gravity(delta):
	if not is_on_floor():
		var gravity = get_gravity() * delta 
		velocity += gravity

func _handle_input(delta):
	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_action_pressed("sprint"):
		sprint_mode = true
	else:
		sprint_mode = false
	if direction:
		if sprint_mode:
			velocity.x = move_toward(velocity.x, sprint_coeff*direction*MAX_SPEED, AXCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, direction*MAX_SPEED, AXCELERATION * delta)
		if sprite_animation.current_animation != "WALK":
			sprite_animation.play("WALK")
	else:
		velocity.x = move_toward(velocity.x, 0, AXCELERATION * delta)
		
		if sprite_animation.current_animation != "IDLE":
			sprite_animation.play("IDLE")
	if (direction < 0 and animated_sprite_2d.flip_h) or (direction > 0 and !animated_sprite_2d.flip_h):
		animated_sprite_2d.flip_h = not animated_sprite_2d.flip_h
		
	if Input.is_action_just_pressed("ui_accept"):
		if is_character_can_jump():
			current_add_jumps_count = 0
			velocity.y = JUMP_SPEED
			velocity.x /= 2
		elif current_add_jumps_count < max_add_jumps_count:
			current_add_jumps_count += 1
			velocity.y = JUMP_SPEED

func is_character_can_jump() -> bool:
	return jump_area.is_can_jump()
