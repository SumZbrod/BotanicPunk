@tool
extends BTAction

@export var target_name := &"target" 
@export var target_range :=  Vector2(10, 5) # (in radius, between radius)
@export var pos_name := &"flank_pos" 

func _generate_name() -> String:
	return "SetFrankPosition target: %s, pos: %s, range: %s " % [
		target_name,
		pos_name,
		target_range,
	]

func trapezoid_cos(x):
	return clamp(4*abs(1-2*fmod(x, 1)-2), -1, 1)

func get_random_squre_pos(target_range_:Vector2) -> Vector2:
	var R: float = (target_range_.x + target_range_.y*randf())
	var alpha := randf()
	return Vector2(R*trapezoid_cos(alpha), R*trapezoid_cos(alpha-.5))

func _tick(_delta: float) -> Status:
	print("[SetFrankPos:_tick] start")
	var random_squre_pos := get_random_squre_pos(target_range)
	var frank_pos: Vector2 = blackboard.get_var(target_name).global_position + random_squre_pos
	blackboard.set_var(pos_name, frank_pos)
	print("[SetFrankPos:_tick] frank pos -> %s " % frank_pos)
	return SUCCESS
	
