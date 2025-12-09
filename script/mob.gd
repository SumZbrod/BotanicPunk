class_name MobClass extends CharacterBody2D

@export var SPEED := 500.
@export var JUMP_VELOCITY := -800.

func _physics_process(delta: float) -> void:
	_handle_gravity(delta)
	move_and_slide()
	
func _handle_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
