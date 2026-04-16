class_name HurtAreaNode extends Area2D

var hurt := 1.
signal damage_signal(hurt:float) 


func damage(hurt_value:float):
	damage_signal.emit(hurt_value)


func _on_body_entered(body: Node2D) -> void:
	body.damage(hurt)
	print("[HurtArea] body ", body)
