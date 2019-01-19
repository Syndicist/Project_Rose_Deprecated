extends "res://Game Objects/actor.gd"

onready var attack = get_node("States").get_node("Attack");

#platform forgiveness
var min_air_time;

#enemy detection
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

################## INITIALIZE_VARS ##################
#Not actually neccessary mostly, but provides an easy
#centrailized location for all default variable values.
func _ready():
	$fadeanim.play("fadeanim");
	
	max_hp = 3;
	damage = 10;
	spd = 250;
	jspd = 500;
	gravity = 1200;
	### default subnode controller vars ###
	currentSprite = get_node("Sprites").get_node("StillSprites");
	anim = "Idle";
	new_anim = "Idle";
	
	min_air_time = 0.1;
	
	### default state vars ###
	state = 'move';
	
	$animator.play(anim);
	pass;

#Processes player variables, like hp, damage, and speed.
func execute(delta):
	#state machine
	#state = 'move' by default
	states[state].execute(delta);
	
	if(hp<=0):
		Kill();
	
	#switch new animation
	if(new_anim != anim):
		Animate();
	
	$Camera2D.current = true;
	#detect enemy hitboxes
	hitboxLoop()
	pass;

func Kill():
	get_tree().change_scene("res://scenes/GameOver/GameOver.tscn")
	pass;

#Processes physical interactions.
func phys_execute(delta):
	#print(attack.start);
	#count time in air
	air_time += delta;
	
	velocity.y = vspd + fspd;
	
	#move across surfaces
	velocity = move_and_slide(velocity, floor_normal);
	
	#no gravity acceleration when on floor
	if(is_on_floor()):
		air_time = 0;
		velocity.y = 0
		vspd = 0;
		fspd = 0;
	
	#add gravity
	if(!attack.dashing):
		fspd += gravity * delta;
	
	#cap gravity
	if(fspd > 900):
		fspd = 900;
	
	if(is_on_ceiling()):
		fspd = 500;
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

#kick up dirt
func _on_RunSprites_frame_changed():
	if(currentSprite.frame == 2):
		$kickup.restart();
		$kickup.emitting = true;
	if(currentSprite.frame == 6):
		$kickup2.restart();
		$kickup2.emitting = true;
	pass;
