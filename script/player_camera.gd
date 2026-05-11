extends Camera2D
@onready var color_rect: ColorRect = $ColorRect
var t: Tween
@onready var health_bar: TextureRect = $HealthBar

func _ready() -> void:
	health_bar.texture.gradient.set_color(0, Color("9e0000"))
	health_bar.texture.gradient.set_color(1, Color("000000"))
	health_bar.texture.gradient.set_offset(1, .99)
	health_bar.texture.gradient.set_offset(0, .98)
	t = get_tree().create_tween()
	t.set_ease(Tween.EASE_IN_OUT)
	t.tween_property(color_rect, "modulate", Color(0,0,0,0), 2).from(Color())

func kill():
	t = get_tree().create_tween()
	t.tween_property(color_rect, "modulate", Color(), 1).from(Color(0,0,0,0))
	t.tween_callback(restart_game)

func restart_game():
	get_tree().change_scene_to_file("res://scene/main.tscn")
