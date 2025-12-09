class_name Enemy extends MobClass

enum {IDLE, MOVE}

var state := IDLE 
var _direction := 1.
var time := 0.
var max_time := 1.

func _process(delta: float) -> void:
	time += delta
	if time >= max_time:
		time = 0
		_update_state()

func _physics_process(delta: float) -> void:
	super(delta)
	match state:
		IDLE:
			_on_idle()
		MOVE:
			_on_move()

func _update_state():
	var rand_value = randf()
	if rand_value <= .5:
		if state == IDLE:
			state = MOVE
			
			if rand_value:
				_direction = SPEED * sign(rand_value * 4 - 1)
			
		else:
			state = IDLE

func _on_idle():
	velocity.x = 0
	
func _on_move():
	velocity.x = _direction
