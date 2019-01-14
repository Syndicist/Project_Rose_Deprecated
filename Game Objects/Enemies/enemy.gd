extends "res://Game Objects/actor.gd"

onready var actionTimer = get_node("ActionTimer");
onready var player = get_parent().get_parent().get_node("Rose");

#range which the enemy attacks
export(float) var arange = 50;
#range which the enemy chases
export(Vector2) var srange = Vector2(160,32);
export(int) var stun_threshold = 10;
###debugging_tools###
var hit_pos;

###background_enemy_data###
var decision;
var wait;

onready var states;
var state;
var stun_damage;
var off_bal;

### Enemy ###
func _ready():
	decision = 0;
	state = 'default';
	wait = 0;
	anim = "idle";
	new_anim = anim;
	currentSprite = get_node("Idle_Sprites");
	hit_pos = Vector2(0,0);
	
	stun_damage = 0;
	
	$animator.play(anim);
	pass

func execute(delta):
	if(stun_damage >= stun_threshold):
		state = 'defstun';
		stun_damage = 0;
	#assumes the enemy is stored in a Node2D
	if(actionTimer.time_left <= 0.1 && state != 'defstun'):
		decision = makeDecision();
	wait = rand_range(.5, 2);
	
	if(hp <= 0):
		Kill();
	
	#switch new animation
	if(new_anim != anim):
		Animate();
	pass

func phys_execute(delta):
	#state machine
	#state = 'default' by default
	states[state].execute(delta);
	
	velocity.x = hspd;
	velocity.y = vspd + fspd;
	velocity = move_and_slide(velocity,floor_normal);
	
	#no gravity acceleration when on floor
	if(is_on_floor()):
		velocity.y = 0
		vspd = 0;
		fspd = 0;
	
	#add gravity
	fspd += gravity * delta;
	
	#cap gravity
	if(fspd > 900):
		fspd = 900;
	if(is_on_ceiling()):
		fspd = 500;
	pass

func makeDecision():
	var dec = randi() % 100 + 1;
	return dec;

func canSeePlayer():
	var space_state = get_world_2d().direct_space_state;
	var result = space_state.intersect_ray(global_position, player.global_position, [self], collision_mask);
	if(!result.empty()):
		#debugging raycasts
		hit_pos = result.position;
		return false;
	elif((abs(player.global_position.x-global_position.x) < srange.x) && (abs(player.global_position.y-global_position.y) < srange.y)):
		hit_pos = player.global_position;
		return true;
	return false;
