extends "../State.gd"

var velocity = Vector2();

func enter(prev_velocity):
	pass;

func get_input_direction():
	var input_direction = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"));
	return input_direction;

func update_look_direction(direction):
	if(direction && host.Direction != direction):
		host.Direction = direction;
	if not direction in [-1, 1]:
		return;
	host.set_scale(Vector2(direction, 1));