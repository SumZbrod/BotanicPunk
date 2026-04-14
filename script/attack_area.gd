class_name AttackAreaNode extends Area2D
@onready var coll_r: CollisionShape2D = $CollR
@onready var coll_l: CollisionShape2D = $CollL
@onready var timer: Timer = $Timer

var hurt := 1.

func attack(dir_r:bool):
	if dir_r:
		coll_r.disabled = false
	else:
		coll_l.disabled = false
	timer.start()
func _on_body_entered(body: Node2D) -> void:
	body.damage(hurt)

func _on_timer_timeout() -> void:
	coll_r.disabled = true
	coll_l.disabled = true

func _on_area_entered(area: Area2D) -> void:
	area.damage(hurt)
