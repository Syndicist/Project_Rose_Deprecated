extends KinematicBody2D

onready var actionTimer = get_node("ActionTimer");
onready var player = get_parent().get_parent().get_node("Rose");

###enemy_game_data###
export(int) var hp = 1;
export(int) var damage = 1;
#range which the enemy attacks
export(float) var arange = 50;
#range which the enemy chases
export(Vector2) var srange = Vector2(160,32);
export(float) var spd = 50;
export(float) var jspd = 75;
export(float) var gravity = 250;

###debugging_tools###
var hit_pos;

###background_enemy_data###
var decision;
var vspd;
var fspd;
var wait;
var new_anim;
var anim;
var currentSprite;
var hspd;
var velocity;
var Direction;
var floor_normal;
var tag;

onready var states = {
	'default' : $States/Default,
	'attack' : $States/Attack,
	'chase' : $States/Chase,
	'defstun' : $States/DefaultStun
}
var state;

### Enemy ###
func _ready():
	decision = 0;
	tag = "enemy";
	state = 'default';
	wait = 0;
	velocity = Vector2(0,0);
	vspd = 0;
	fspd = 0;
	#1 = right, -1 = left
	Direction = 1;
	floor_normal = Vector2(0,-1);
	anim = "idle";
	new_anim = anim;
	currentSprite = get_node("Idle_Sprites");
	hspd = 0;
	hit_pos = Vector2(0,0);
	pass

#for debugging raycasts
#func _draw():
#	draw_line(Vector2(0,0),Vector2((hit_pos.x - global_position.x)*Direction, hit_pos.y - global_position.y),Color(1,1,1));
#	pass

func _process(delta):
#	update();
	execute(delta);
	pass

func execute(delta):
	#assumes the enemy is stored in a Node2D
	if(actionTimer.time_left <= 0.1):
		decision = makeDecision();
	wait = rand_range(.5, 2);
	
	if(hp <= 0):
		Kill();
	
	#switch new animation
	if(new_anim != anim):
		Animate();
	pass

### Default Behavior ###
func _physics_process(delta):
	physExecute(delta);
	pass

func physExecute(delta):
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

func Animate():
	$animator.stop();
	anim = new_anim;
	$animator.play(anim);
	pass

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

func Kill():
	#TODO: death anims and effects
	queue_free();

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
