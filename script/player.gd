class_name PlayerClass extends CharacterBody2D
const MAX_SPEED = 800
const AXCELERATION = 4000
const JUMP_SPEED = -400
@export var max_jump_velocity := -200
@export var jump_acceleration := -5000
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_area: JumpAreaNode = $JumpArea

const DASH_SPEED = 8000
var dash_mode: bool
var dash_accepted : bool
var dash_speed: Vector2
const AVTER_DASH_SPEED := Vector2(2000, 500)

var max_add_jumps_count: int = 1
var current_add_jumps_count: int = 2
var sprint_coeff := 1.5
var jump_max_time := .2
var jump_time := 0.
var is_attack: bool
var attack_frame: int
var max_lives := 5.
var lives := max_lives
@onready var attack_area: AttackAreaNode = $AttackArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const ENEMY = preload("uid://d4d31ljkovmx0")
var fall_speed := 0.
@onready var health_bar: TextureRect = $Camera2D/HealthBar
var move_direction : Vector2
var velocity_bevore_dash: Vector2
var tween: Tween
var h_direction: = 1.
var dash_reseted: bool = true

func _ready() -> void:
	animated_sprite_2d.play("IDLE")
	
func _process(_delta: float) -> void:
	move_and_slide()

func _physics_process(delta: float) -> void:
	_handle_gravity(delta)
	_handle_input(delta)
	_handle_dash_reseted_anim()
	
func _handle_gravity(delta):
	if jump_time > 0:
		jump_time -= delta
		return
	if dash_mode:
		return
	elif not is_on_floor():
		jump_time = 0
		var gravity = get_gravity() * delta * 1.5
		velocity += gravity
		fall_speed = velocity.y
		if !is_attack:
			animated_sprite_2d.pause()
	elif fall_speed > 0:
		fall_damage()

func _handle_dash_reseted_anim():
	if !dash_reseted:
		if abs(velocity.x) + abs(velocity.y) < 1000: 
			reset_dash_shader()
			
func _handle_input(delta):
	_handle_attack(delta)
	if dash_mode:
		return
	move_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if move_direction.x:
		h_direction = move_direction.x
	if is_on_floor():
		animated_sprite_2d.play()
		dash_accepted = true
	if dash_accepted and Input.is_action_just_pressed("sprint"):
		dash_accepted = false
		dash_mode = true
		tween = get_tree().create_tween()
		if !move_direction:
			move_direction = Vector2(h_direction, 0)
		if move_direction.x != 0:
			animated_sprite_2d.material.set_shader_parameter("dash_horizon", true)
		if move_direction.y > 0:
			animated_sprite_2d.material.set_shader_parameter("dash_down", true)
		elif move_direction.y < 0:
			animated_sprite_2d.material.set_shader_parameter("dash_up", true)
		animated_sprite_2d.material.set_shader_parameter("dash_module", 1.)
		dash_speed = move_direction * DASH_SPEED * Vector2(1, .6)
		tween.tween_property(self, "velocity", dash_speed, .1).from(dash_speed)
		tween.tween_callback(dash_reset)
	
	_handle_sprite_anim(delta)
	_handle_jump()

func _handle_sprite_anim(delta):
	if move_direction.x:
		velocity.x = move_toward(velocity.x, h_direction*MAX_SPEED, AXCELERATION * delta)
		if !is_attack and animated_sprite_2d.animation != "WALK":
			animated_sprite_2d.play("WALK")
			if !is_on_floor() and !is_attack:
				animated_sprite_2d.pause()
	else:
		velocity.x = move_toward(velocity.x, 0, AXCELERATION * delta)
		if !is_attack and animated_sprite_2d.animation != "IDLE":
			animated_sprite_2d.play("IDLE")
	if (move_direction.x < 0 and !animated_sprite_2d.flip_h) or (move_direction.x > 0 and animated_sprite_2d.flip_h):
		animated_sprite_2d.flip_h = not animated_sprite_2d.flip_h

func _handle_jump():
	if Input.is_action_just_pressed("ui_accept"):
		if is_character_can_jump():
			current_add_jumps_count = 0
			velocity.x /= 2
			if !is_attack:
				animated_sprite_2d.pause()
		elif current_add_jumps_count < max_add_jumps_count:
			current_add_jumps_count += 1
			animated_sprite_2d.frame += 2
		else:
			return
		jump_time = jump_max_time
		velocity.y = JUMP_SPEED
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

func damage(hurt:float):
	if hurt <= 0:
		return
	print("[Player:damage] hurt ", hurt)
	lives -= hurt
	if lives > .1:
		animation_player.play("HURT")
	else:
		kill()
	var live_ration = lives / max_lives
	health_bar.texture.gradient.set_offset(0, live_ration)
	health_bar.texture.gradient.set_offset(1, live_ration)
	
func kill():
	queue_free() 
	
func fall_damage():
	damage(max((fall_speed/1000) - 1, 0))
	fall_speed = 0

func dash_reset():
	velocity = move_direction * AVTER_DASH_SPEED 
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_method(set_shader_value, 1., 0., .35)
	tween.tween_callback(reset_dash_shader)
	dash_mode = false
	dash_reseted = false
	
func set_shader_value(v:float):
	animated_sprite_2d.material.set_shader_parameter("dash_module", v)

func reset_dash_shader():
	if !dash_reseted:
		animated_sprite_2d.material.set_shader_parameter("dash_horizon", false)
		animated_sprite_2d.material.set_shader_parameter("dash_down", false)
		animated_sprite_2d.material.set_shader_parameter("dash_up", false)
		dash_reseted = true
	
