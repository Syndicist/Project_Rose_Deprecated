extends "res://Game Objects/Rose/Move.gd"

func _process(delta):
	if(host.state == 'move'):
		this_state = true;
	if(host.state != 'move'):
		this_state = false;
		velocity = Vector2(0,0);
		vspd = 0;
		fall_spd = 0;
	pass

################## MOVE_PLAYER ##################
#Allows the player to move and jump, as well as trigger attacks.
#This is the default and primary state.
func execute(delta):
	### attack triggers ###
	#TODO: pierce and bash attack triggers (these need animations first)
	if(Input.is_action_just_pressed("ui_slash") && attack.cooldown_timer <= 0):
		attack.combo_step = 1;
		attack.attack_timer = 75;
		attack.first_attack = attack.ATTACK.slash;
		host.state = 'attack';
		if(host.is_on_floor()):
			velocity.x = 0;
	### move triggers ###
	elif(host.is_on_floor()):
		if(Input.is_action_pressed("ui_right")):
			if(host.Direction != 1):
				host.scale.x = host.scale.x * -1;
			velocity.x = run_spd;
			host.Direction = 1;
			host.changeSprite(host.get_node("Default Movement").get_node("RunSprites"),"Run");
		elif(Input.is_action_pressed("ui_left")):
			if(host.Direction != -1):
				host.scale.x = host.scale.x * -1;
			velocity.x = -run_spd;
			host.Direction = -1;
			host.changeSprite(host.get_node("Default Movement").get_node("RunSprites"),"Run");
		elif(Input.is_action_pressed("ui_up")):
			null;
			#look up
		elif(Input.is_action_pressed("ui_down")):
			null;
			#look down
		else:
			velocity.x = 0;
			host.changeSprite(host.get_node("Default Movement").get_node("StillSprites"),"Idle");
		if(Input.is_action_just_pressed("ui_jump")):
			vspd += -jump_spd;
	
	### moving in the air ###
	#TODO: jump-based special attacks
	elif(!host.is_on_floor()):
		if(Input.is_action_just_released("ui_jump")):
			if(fall_spd < jump_spd):
				fall_spd = 2*jump_spd/3;
		if(velocity.y>0):
			host.changeSprite(host.get_node("Default Movement").get_node("FallSprites"),"Fall");
		if(velocity.y<0):
			host.changeSprite(host.get_node("Default Movement").get_node("JumpSprites"),"Jump");
		if(Input.is_action_pressed("ui_right")):
			if(host.Direction != 1):
				host.scale.x = host.scale.x * -1;
			velocity.x = run_spd;
			host.Direction = 1;
		elif(Input.is_action_pressed("ui_left")):
			if(host.Direction != -1):
				host.scale.x = host.scale.x * -1;
			velocity.x = -run_spd;
			host.Direction = -1;
		else:
			velocity.x = 0;
	pass