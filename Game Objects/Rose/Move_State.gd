extends Node2D

#node references
onready var host = get_parent().get_parent();
onready var attack = get_parent().get_node("Attack");

### movement controller vars ###
var run_spd;
var jump_spd;
var velocity;
var gravity;
var gravity_vector;
var air_time;
var floor_normal;
var fall_spd;
var vspd;
var Direction;

func _ready():
	### default movement controller vars ###
	run_spd = 300;
	jump_spd = 500;
	velocity = Vector2(0,0);
	gravity = 1200;
	floor_normal = Vector2(0,-1);
	air_time = 0;
	vspd = 0;
	fall_spd = 0
	#1 is right, -1 is left
	Direction = 1;
	
	pass


################## PHYSICS_FUNCTION ##################
#Processes physical interactions.
func _physics_process(delta):
	
	#count time in air
	air_time += delta;
	
	velocity.y = vspd + fall_spd;
	#move across surfaces
	velocity = host.move_and_slide(velocity, floor_normal);
	
	
	#no gravity acceleration when on floor
	if(host.is_on_floor()):
		air_time = 0;
		velocity.y = 0
		vspd = 0;
		fall_spd = 0;
	
	#add gravity
	if(!attack.dashing):
		fall_spd += gravity * delta;
	#cap gravity
	if(fall_spd > 900):
		fall_spd = 900;
	
	if(host.is_on_ceiling()):
		fall_spd = 500;
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
			if(Direction != 1):
				host.scale.x = host.scale.x * -1;
			velocity.x = run_spd;
			Direction = 1;
			host.changeSprite("RunSprites","Run");
		elif(Input.is_action_pressed("ui_left")):
			if(Direction != -1):
				host.scale.x = host.scale.x * -1;
			velocity.x = -run_spd;
			Direction = -1;
			host.changeSprite("RunSprites","Run");
		elif(Input.is_action_pressed("ui_up")):
			null;
			#look up
		elif(Input.is_action_pressed("ui_down")):
			null;
			#look down
		else:
			velocity.x = 0;
			host.changeSprite("StillSprites","Idle");
		if(Input.is_action_just_pressed("ui_jump")):
			vspd += -jump_spd;
	
	### moving in the air ###
	#TODO: jump-based special attacks
	elif(!host.is_on_floor()):
		if(Input.is_action_just_released("ui_jump")):
			if(fall_spd < jump_spd):
				fall_spd = 2*jump_spd/3;
		if(velocity.y>0):
			host.changeSprite("FallSprites","Fall");
		if(velocity.y<0):
			host.changeSprite("JumpSprites","Jump");
		if(Input.is_action_pressed("ui_right")):
			if(Direction != 1):
				host.scale.x = host.scale.x * -1;
			velocity.x = run_spd;
			Direction = 1;
		elif(Input.is_action_pressed("ui_left")):
			if(Direction != -1):
				host.scale.x = host.scale.x * -1;
			velocity.x = -run_spd;
			Direction = -1;
		else:
			velocity.x = 0;
	pass