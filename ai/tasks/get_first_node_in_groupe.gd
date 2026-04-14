@tool
extends BTAction

@export var group_name: StringName

@export var output_var: StringName = &"target"

func _generate_name() -> String:
	return "GetFirsstNOdeInGroup \"%s\" -> %s " % [
		group_name,
		LimboUtility.decorate_var(output_var),
	]

func _tick(_delta: float) -> Status:
	var target = agent.get_tree().get_first_node_in_group(group_name)
	if target:
		#print("[GetFirstNodeInGroupe:_tick] \"%s\" -> %s " % [output_var, target])
		blackboard.set_var(output_var, target)
		return SUCCESS
	else:
		return FAILURE
