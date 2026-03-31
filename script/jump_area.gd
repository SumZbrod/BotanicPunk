class_name JumpAreaNode extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var block_count := 0

func is_can_jump() -> bool:
	return block_count > 0

func _on_body_entered(_body: Node2D) -> void:
	block_count += 1


func _on_body_exited(body: Node2D) -> void:
	block_count -= 1
