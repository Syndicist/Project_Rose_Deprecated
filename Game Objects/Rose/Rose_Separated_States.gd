extends KinematicBody2D

### anim controller vars ###
var currentSprite;
var anim;
var new_anim;

### base movement control ###
var velocity;
var gravity;
var gravity_vector;
var air_time;
var on_wall;
var floor_normal;
var fall_spd;
var vspd;
var on_ceiling;
var on_floor;
var Direction;


### state vars ###
#TODO: hurt_state 
onready var states = {
	'move' : $States/Move,
	'attack' : $States/Attack
}
var state;

### player vars ###
var hp;
var max_hp;
var damage;

################## INITIALIZE_VARS ##################
#Not actually neccessary mostly, but provides an easy
#centrailized location for all default variable values.
func _ready():
	### default subnode controller vars ###
	currentSprite = get_node("StillSprites");
	anim = "Idle";
	new_anim = "Idle";

	### default movement controller vars ###
	velocity = Vector2(0,0);
	gravity = 1200;
	gravity_vector = Vector2(0,gravity);
	floor_normal = Vector2(0,-1);
	air_time = 0;
	on_wall = false;
	vspd = 0;
	fall_spd = 0
	on_ceiling = false;
	on_floor = false;
	Direction = "right";
	
	### default stat vars ###
	state = 'move';
	pass


func _process(delta):
	$Camera2D.current = true;
	pass

################## MAIN_FUNCTION ##################
#Processes physical interactions, switches states,
#and manages timers.
func _physics_process(delta):
	on_wall = is_on_wall();
	on_floor = is_on_floor();
	on_ceiling = is_on_ceiling();
	
	#count time in air
	air_time += delta;
	
	#timer for attacks
	states['attack'].attack_timer -= 1;
	states['attack'].cooldown_timer -= 1;
	
	#add gravity
	if(!states['attack'].dashing):
		fall_spd += gravity_vector.y * delta;
	#cap gravity
	if(fall_spd > 900):
		fall_spd = 900;
	velocity.y = vspd + fall_spd;
	
	#move across surfaces
	velocity = move_and_slide(velocity, floor_normal);
	
	#no gravity acceleration when on floor
	if(is_on_floor()):
		air_time = 0;
		velocity.y = 0
		vspd = 0;
		fall_spd = 0;
	if(is_on_ceiling()):
		fall_spd = 500;
	
	#state machine
	#state = 'move' by default
	states[state].execute(delta);
	
	#switch new animation
	if(new_anim != anim):
		Animate();
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
	currentSprite = get_node(sprite);
	currentSprite.visible = true;
	new_anim = animation;
	pass