extends "../Motion_State.gd"

func enter(prev_velocity):
	velocity = prev_velocity;
	
	var input_direction = get_input_direction();
	update_look_direction(input_direction);
	host.get_node("animator").play("run");	
	pass

func handleInput(event):
	if(event.is_action_just_pressed("ui_slash")):
		exit('attack');
	if(event.is_action_just_pressed("ui_jump")):
		exit('jump');
	pass

func update(delta):
	var input_direction = get_input_direction();
	update_look_direction(input_direction);

	speed = MAX_RUN_SPEED if Input.is_action_pressed("run") else MAX_WALK_SPEED
	var collision_info = move(speed, input_direction)
	if not collision_info:
		return
	if speed == MAX_RUN_SPEED and collision_info.collider.is_in_group("environment"):
		return null

func exit(state):
	host.state = state;
	pass