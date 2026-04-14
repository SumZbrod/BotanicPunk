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


func __test_get_random_squre_pos():
	var current_vieport = get_viewport().size * 1.
	print("current_vieport ", current_vieport)
	var C_
	var N = 1000.
	for i in N:
		C_ = Utils.get_random_squre_pos(Vector2(300, 100))
		draw_circle(C_+Vector2.DOWN*100, 5, Utils.rainbow(i/N))

func _draw():
	__test_get_random_squre_pos()
