extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var player: PlayerClass
var lives := 5.
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

enum {
	IDLE,
	ATTACK,
	HURT,
	DEATH
}
var state := IDLE
func _ready() -> void:
	player = get_tree().get_first_node_in_group('player')
	set_idle()

func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			_on_idle()
		_:
			push_warning("[BEE:_physaics_process] unkonw state %s" % state)
	
	move_and_slide()

func set_idle():
	state = IDLE
	animated_sprite_2d.play("IDLE")

func _on_idle():
	pass
		
