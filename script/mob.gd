class_name MobClass extends CharacterBody2D

@export var SPEED := 500.
@export var max_jump_velocity := -200
@export var jump_acceleration := -5000

func _physics_process(delta: float) -> void:
	_handle_gravity(delta)
	move_and_slide()
	
func _handle_gravity(delta):
	if not is_on_floor():
		var gravity = get_gravity() * delta 
		velocity += gravity
