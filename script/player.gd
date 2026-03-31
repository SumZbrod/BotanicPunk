class_name PlayerClass extends CharacterBody2D
const  SPEED := 30_000
const JUMP_SPEED := 30_000
@export var max_jump_velocity := -200
@export var jump_acceleration := -5000
@onready var sprite_animation: AnimationPlayer = $SpriteAnimation
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

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
	if direction:
		velocity.x = direction * SPEED * delta
		if sprite_animation.current_animation != "WALK":
			sprite_animation.play("WALK")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if sprite_animation.current_animation != "IDLE":
			sprite_animation.play("IDLE")
	if (velocity.x < 0 and animated_sprite_2d.flip_h) or (velocity.x > 0 and !animated_sprite_2d.flip_h):
		animated_sprite_2d.flip_h = not animated_sprite_2d.flip_h
		
	if Input.is_action_just_pressed("ui_accept"):
		if is_character_can_jump():
			velocity.y = JUMP_SPEED
func is_character_can_jump() -> bool:
	return true
