extends "res://Game Objects/Rose/State.gd"

func _process(delta):
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
			host.velocity.x = 0;
	### move triggers ###
	elif(host.is_on_floor()):
		if(Input.is_action_pressed("ui_right")):
			if(host.Direction != 1):
				host.scale.x = host.scale.x * -1;
			host.velocity.x = host.run_spd;
			host.Direction = 1;
			host.changeSprite(host.get_node("Default Movement").get_node("RunSprites"),"Run");
		elif(Input.is_action_pressed("ui_left")):
			if(host.Direction != -1):
				host.scale.x = host.scale.x * -1;
			host.velocity.x = -host.run_spd;
			host.Direction = -1;
			host.changeSprite(host.get_node("Default Movement").get_node("RunSprites"),"Run");
		elif(Input.is_action_pressed("ui_up")):
			null;
			#TODO: look up
		elif(Input.is_action_pressed("ui_down")):
			null;
			#TODO: look down
		else:
			host.velocity.x = 0;
			host.changeSprite(host.get_node("Default Movement").get_node("StillSprites"),"Idle");
		if(Input.is_action_just_pressed("ui_jump")):
			host.vspd += -host.jump_spd;
	
	### moving in the air ###
	#TODO: jump-based special attacks
	elif(!host.is_on_floor()):
		if(Input.is_action_just_released("ui_jump")):
			if(host.fall_spd < host.jump_spd):
				host.fall_spd = 2*host.jump_spd/3;
		if(host.velocity.y>0):
			host.changeSprite(host.get_node("Default Movement").get_node("FallSprites"),"Fall");
		if(host.velocity.y<0):
			host.changeSprite(host.get_node("Default Movement").get_node("JumpSprites"),"Jump");
		if(Input.is_action_pressed("ui_right")):
			if(host.Direction != 1):
				host.scale.x = host.scale.x * -1;
			host.velocity.x = host.run_spd;
			host.Direction = 1;
		elif(Input.is_action_pressed("ui_left")):
			if(host.Direction != -1):
				host.scale.x = host.scale.x * -1;
			host.velocity.x = -host.run_spd;
			host.Direction = -1;
		else:
			host.velocity.x = 0;
	pass