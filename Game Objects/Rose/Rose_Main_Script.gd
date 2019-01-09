extends KinematicBody2D

### physics vars ###
var Direction;

### anim controller vars ###
var currentSprite;
var anim;
var new_anim;

onready var attack = get_node("States").get_node("Attack");
onready var move = get_node("States").get_node("Move");
onready var hurt = get_node("States").get_node("Hurt");

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
var min_air_time = 0.1;
var targettableHitboxes = [];
var itemTrace = [];

### state vars ###
#TODO: hurt_state
onready var states = {
	'move' : $States/Move,
	'attack' : $States/Attack,
	'hurt' : $States/Hurt
}
var state;

### player vars ###
var hp;
var max_hp;
var damage;
var tag;

################## INITIALIZE_VARS ##################
#Not actually neccessary mostly, but provides an easy
#centrailized location for all default variable values.
func _ready():
	max_hp = 3;
	hp = max_hp;
	damage = 10;
	tag = "player";
	
	### default subnode controller vars ###
	currentSprite = get_node("Sprites").get_node("StillSprites");
	anim = "Idle";
	new_anim = "Idle";
	
	### default state vars ###
	state = 'move';
	Direction = 1;
	
	### default movement controller vars ###
	run_spd = 250;
	jump_spd = 500;
	velocity = Vector2(0,0);
	gravity = 1200;
	floor_normal = Vector2(0,-1);
	air_time = 0;
	vspd = 0;
	fall_spd = 0;
	$animator.play(anim);
	pass;

"""
#for debugging raycasts
func _draw():
	for item in targettableHitboxes:
		draw_line(Vector2(0,0),Vector2((item.global_position.x - global_position.x)*Direction, item.global_position.y - global_position.y),Color(0,0,1));
	pass;
"""

################## PROCESS_FUNCTION ##################
#Processes player variables, like hp, damage, and speed.
func _process(delta):
#	update();
	#state machine
	#state = 'move' by default
	states[state].execute(delta);
	
	#TODO: handle_input methods for each state
	
	if(hp<=0):
		print("you technically just died right now");
		hp = 3;
		#TODO: go to game over
	
	#switch new animation
	if(new_anim != anim):
		Animate();
	
	$Camera2D.current = true;
	
	hitboxLoop()
	pass;

################## PHYSICS_FUNCTION ##################
#Processes physical interactions.
func _physics_process(delta):
	#count time in air
	air_time += delta;
	
	velocity.y = vspd + fall_spd;
	
	#move across surfaces
	velocity = move_and_slide(velocity, floor_normal);
	
	#no gravity acceleration when on floor
	if(is_on_floor()):
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
	
	if(is_on_ceiling()):
		fall_spd = 500;
	pass;

################## ANIMATE_NEW_ANIMATION ##################
#Stops the current animation on whatever frame it's on and
#switches it to a new animation, and immediately plays that
#animation.
func Animate():
	$animator.stop();
	anim = new_anim;
	$animator.play(anim);
	pass;

################## CHANGE_SPRITE ##################
#Makes the current sprite invisible, switches the
#sprite to the given sprite, and sets the new sprite
#to visible. Sets the new animation to the given
#animation.
func changeSprite(sprite, animation):
	currentSprite.visible = false;
	currentSprite = sprite
	currentSprite.visible = true;
	new_anim = animation;
	pass;

func on_floor():
	return ($floor_cast.is_colliding() || $floor_cast2.is_colliding() || $floor_cast3.is_colliding());


func _on_DetectHitboxArea_area_entered(area):
	if(!targettableHitboxes.has(area)):
		targettableHitboxes.push_back(area);
	pass;
func _on_DetectHitboxArea_area_exited(area):
	if(targettableHitboxes.has(area)):
		targettableHitboxes.erase(area);
	pass;

func hitboxLoop():
	var space_state = get_world_2d().direct_space_state;
	for item in targettableHitboxes:
		var slash = nextRay(self,item,11,space_state);
		var bash = nextRay(self,item,12,space_state);
		var pierce = nextRay(self,item,13,space_state);
		if(slash || bash || pierce):
			item.hittable = true;
		else:
			item.hittable = false;
	pass;

func nextRay(origin,dest,col_layer,spc):
	if(!itemTrace.has(origin)):
		itemTrace.push_back(origin);
	var result = spc.intersect_ray(origin.global_position, dest.global_position, itemTrace, $RayCastCollision.collision_mask);
	if(result.empty()):
		itemTrace.clear();
		return true;
	elif(result.collider.get_collision_layer_bit(col_layer)):
		if(result.collider != dest):
			return nextRay(result.collider,dest,col_layer,spc);
		else:
			itemTrace.clear();
			return true;
	else:
		itemTrace.clear();
		return false;