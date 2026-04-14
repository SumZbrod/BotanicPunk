extends CharacterBody2D


const FLY_SPEED = 30000
var player: PlayerClass
var lives := 5.
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const reach_distance := .1
const min_square_velocity := .1

enum {
	IDLE,
	ATTACK,
	HURT,
	DEATH,
	CHASE,
}
var state := IDLE
var is_reach = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group('player')
	#set_idle()
	animated_sprite_2d.flip_h = true

func _physics_process(_delta: float) -> void:
	#print('[BEE:_physics_process] velocity ', velocity)
	move_and_slide()
	if animated_sprite_2d.flip_h and velocity.x < 0:
		animated_sprite_2d.flip_h = false
	if not animated_sprite_2d.flip_h and velocity.x > 0:
		animated_sprite_2d.flip_h = true

func set_idle():
	#print("[BEE:set_idlea]")
	state = IDLE
	animated_sprite_2d.play("IDLE")
	
func chase(delta:float, A:Vector2):
	set_chase()
	var direction := (A - global_position).normalized()
	var new_velocity = direction * FLY_SPEED * delta
	if (new_velocity + velocity).length_squared() < min_square_velocity:
		set_is_reach(true)
		return
	if Utils.cheb_distance(global_position, A) < reach_distance:
		set_is_reach(true)
		return
	velocity = new_velocity
	
func set_chase():
	if state != CHASE:
		state = CHASE
		set_is_reach(false)

func set_is_reach(v:bool):
	is_reach = v
	if is_reach:
		velocity = Vector2.ZERO

func is_chasing():
	return state == CHASE

func check_is_reach():
	if is_chasing() and velocity.length_squared() < .001:
		set_is_reach(true)
		return

func damage(hurt:float):
	lives -= hurt
	animated_sprite_2d.play("HURT")
