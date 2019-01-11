extends "res://Game Objects/Rose/State.gd"

func goToAttack():
	attack.combo_step = 1;
	attack.start = true;
	host.state = 'attack';
	pass

################## MOVE_PLAYER ##################
#Allows the player to move and jump, as well as trigger attacks.
#This is the default and primary state.
func execute(delta):
	### attack triggers ###
	#TODO: pierce and bash attack triggers (these need animations first)
	if(attack.get_node("CooldownTimer").is_stopped() && host.on_floor()):
		if(Input.is_action_just_pressed("ui_slash")):
			attack.first_attack = attack.ATTACK.slash;
			host.velocity.x = 0;
			goToAttack();
		if(Input.is_action_just_pressed("ui_bash") && !attack.defBashed):
			attack.first_attack = attack.ATTACK.bash;
			goToAttack();
		"""
		if(Input.is_action_just_pressed("ui_pierce")):
			attack.combo_step = 1;
			attack.attack_timer = 75;
			attack.first_attack = attack.ATTACK.pierce;
			host.state = 'attack';
			host.velocity.x = 0;
		"""
	elif(attack.get_node("CooldownTimer").is_stopped() && !host.on_floor()):
		if(Input.is_action_just_pressed("ui_slash")):
			attack.first_attack = attack.ATTACK.slash;
			goToAttack();
		if(Input.is_action_just_pressed("ui_bash") && !attack.defBashed):
			attack.first_attack = attack.ATTACK.bash;
			goToAttack();
		null
	### move triggers ###
	if(host.on_floor() && host.state == 'move'):
		if(Input.is_action_pressed("ui_right")):
			if(host.Direction != 1):
				host.scale.x = host.scale.x * -1;
			host.velocity.x = host.spd;
			host.Direction = 1;
			host.changeSprite(host.get_node("Sprites").get_node("RunSprites"),"Run");
		elif(Input.is_action_pressed("ui_left")):
			if(host.Direction != -1):
				host.scale.x = host.scale.x * -1;
			host.velocity.x = -host.spd;
			host.Direction = -1;
			host.changeSprite(host.get_node("Sprites").get_node("RunSprites"),"Run");
		#elif(Input.is_action_pressed("ui_up")):
		#	null;
			#TODO: look up
		#elif(Input.is_action_pressed("ui_down")):
		#	null;
			#TODO: look down
		else:
			host.velocity.x = 0;
			host.changeSprite(host.get_node("Sprites").get_node("StillSprites"),"Idle");
		if(Input.is_action_just_pressed("ui_jump") && !Input.is_action_pressed("ui_down")):
			attack.dashing = false;
			host.vspd += -host.jspd;
	
	### moving in the air ###
	#TODO: jump-based special attacks
	elif(!host.on_floor()):
		if(Input.is_action_just_released("ui_jump")):
			if(host.fspd < host.jspd - 100):
				host.fspd = 2*host.jspd/3;
		if(host.velocity.y>0 && (host.fspd > abs(host.jspd) + 100 || host.fspd < host.jspd && host.velocity.y > 100)):
			host.changeSprite(host.get_node("Sprites").get_node("FallSprites"),"Fall");
		elif(host.velocity.y>0):
			host.changeSprite(host.get_node("Sprites").get_node("JumpToFallSprites"),host.anim);
			host.get_node("Sprites").get_node("JumpToFallSprites").frame = 1;
		if(host.velocity.y<0 && host.fspd < abs(host.jspd) - 100):
			host.changeSprite(host.get_node("Sprites").get_node("JumpSprites"),"Jump");
		elif(host.velocity.y<0):
			host.changeSprite(host.get_node("Sprites").get_node("JumpToFallSprites"),host.anim);
			host.get_node("Sprites").get_node("JumpToFallSprites").frame = 0;
		if(Input.is_action_pressed("ui_right")):
			if(host.Direction != 1):
				host.scale.x = host.scale.x * -1;
			host.velocity.x = host.spd;
			host.Direction = 1;
		elif(Input.is_action_pressed("ui_left")):
			if(host.Direction != -1):
				host.scale.x = host.scale.x * -1;
			host.velocity.x = -host.spd;
			host.Direction = -1;
		else:
			host.velocity.x = 0;
	pass