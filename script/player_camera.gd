extends Camera2D
@onready var color_rect: ColorRect = $ColorRect
var t: Tween

func _ready() -> void:
	t = get_tree().create_tween()
	t.set_ease(Tween.EASE_IN_OUT)
	t.tween_property(color_rect, "modulate", Color(0,0,0,0), 1).from(Color())
	
func kill():
	t = get_tree().create_tween()
	t.tween_property(color_rect, "modulate", Color(), 1).from(Color(0,0,0,0))
	t.tween_callback(restart_game)

func restart_game():
	get_tree().reload_current_scene()
