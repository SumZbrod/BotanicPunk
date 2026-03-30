extends AnimatedSprite2D


func _ready() -> void:
	stop()
	
func play_idle():
	play("IDLE")

func play_walk():
	play("WALK")
