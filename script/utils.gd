extends Node


func cheb_distance(A:Vector2, B:Vector2) -> float:
	return max(abs(A.x-B.x), abs(A.y-B.y))


func trapezoid_cos(x):
	return clamp(4*abs(1- 2*fmod(x, 1))-2, -1, 1)

func get_random_squre_pos(target_range_:Vector2) -> Vector2:
	var R: float = (target_range_.x + target_range_.y*randf())
	var alpha := randf()*.5
	return Vector2(R*trapezoid_cos(alpha), R*trapezoid_cos(alpha+ .25))

func piramida(x):
	return max(0, 1-(x-1)**2)

func rainbow(t: float) -> Color:
	return Color(piramida(2*t+1), piramida(2*t), piramida(2*t-1))
