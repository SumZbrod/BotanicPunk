@tool
extends BTAction

@export var arrive_distance := 1.

@export var target_pos_name: StringName = &"flank_pos"

func _generate_name() -> String:
	return "ArrivePos \"%s\"" % target_pos_name

func _tick(delta: float) -> Status:
	var target:Vector2 = blackboard.get_var(target_pos_name)
	agent.chase(delta, target)
	agent.check_is_reach()
	if agent.is_reach:
		print("[ARRIVE:_tick] SUCCESS")
		return SUCCESS
	return RUNNING
