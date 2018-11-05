extends Node2D

#parents and siblings
onready var host = get_parent().get_parent();
onready var attack = get_parent().get_node("Attack");

### movement controller vars ###
var run_spd;
var jump_spd;

func _ready():
	run_spd = 300;
	jump_spd = 500;
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
		if(host.on_floor):
			host.velocity.x = 0;
	### move triggers ###
	elif(host.on_floor):
		if(Input.is_action_pressed("ui_right")):
			if(host.Direction != "right"):
				host.scale.x = host.scale.x * -1;
			host.velocity.x = run_spd;
			host.Direction = "right";"."
			host.changeSprite("RunSprites","Run");
		elif(Input.is_action_pressed("ui_left")):
			if(host.Direction != "left"):
				host.scale.x = host.scale.x * -1;
			host.velocity.x = -run_spd;
			host.Direction = "left";
			host.changeSprite("RunSprites","Run");
		else:
			host.velocity.x = 0;
			host.changeSprite("StillSprites","Idle");
		if(Input.is_action_just_pressed("ui_jump")):
			host.vspd += -jump_spd;
	
	### moving in the air ###
	#TODO: jump-based special attacks
	elif(!host.on_floor):
		if(Input.is_action_just_released("ui_jump")):
			if(host.fall_spd < jump_spd):
				host.fall_spd = 2*jump_spd/3;
		if(host.velocity.y>0):
			host.changeSprite("FallSprites","Fall");
		if(host.velocity.y<0):
			host.changeSprite("JumpSprites","Jump");
		if(Input.is_action_pressed("ui_right")):
			if(host.Direction != "right"):
				host.scale.x = host.scale.x * -1;
			host.velocity.x = run_spd;
			host.Direction = "right";
		elif(Input.is_action_pressed("ui_left")):
			if(host.Direction != "left"):
				host.scale.x = host.scale.x * -1;
			host.velocity.x = -run_spd;
			host.Direction = "left";
		else:
			host.velocity.x = 0;
	pass