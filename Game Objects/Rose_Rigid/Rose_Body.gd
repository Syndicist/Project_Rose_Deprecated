extends RigidBody2D

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
	mode = RigidBody2D.MODE_CHARACTER;
	friction = .5;
	### default subnode controller vars ###
	currentSprite = get_node("Movement_Sprites").get_node("Idle_Sprites");
	anim = "idle";
	new_anim = "idle";
	
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
	pass

################## PHYSICS_FUNCTION ##################
#Processes physical interactions.
func _physics_process(delta):
	if(Input.is_action_pressed("ui_right")):
		add_force(Vector2(0,0),Vector2(50,0));
		
	pass

################## ANIMATE_NEW_ANIMATION ##################
#Stops the current animation on whatever frame it's on and
#switches it to a new animation, and immediately plays that
#animation.
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
	pass