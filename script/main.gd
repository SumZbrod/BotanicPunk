extends Node2D

var bt_player: BTPlayer

@onready var behavior_tree_view: BehaviorTreeView = %BehaviorTreeView
@onready var agent: CharacterBody2D = $Enemy

func _ready():
	bt_player = agent.find_child("BTPlayer")

func _physics_process(_delta: float) -> void:
	if bt_player:
		var inst: BTInstance = bt_player.get_bt_instance()
		var bt_data: BehaviorTreeData = BehaviorTreeData.create_from_bt_instance(inst)
		behavior_tree_view.update_tree(bt_data)

	
