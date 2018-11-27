extends Node2D

#node references
onready var host = get_parent().get_parent();
onready var attack = get_parent().get_node("Attack");
onready var move = get_parent().get_node("Move");
onready var hurt = get_parent().get_node("Hurt");

var this_state;

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

func _ready():
	### default movement controller vars ###
	run_spd = 300;
	jump_spd = 500;
	velocity = Vector2(0,0);
	gravity = 1200;
	floor_normal = Vector2(0,-1);
	air_time = 0;
	vspd = 0;
	fall_spd = 0;
	this_state = false;
	pass

################## PHYSICS_FUNCTION ##################
#Processes physical interactions.
func _physics_process(delta):
	if(this_state):
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
		fall_spd += gravity * delta;
		
		#cap gravity
		if(fall_spd > 900):
			fall_spd = 900;
		
		if(host.is_on_ceiling()):
			fall_spd = 500;
	pass

