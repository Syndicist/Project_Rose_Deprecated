extends KinematicBody2D

### physics vars ###
var on_wall;
var on_floor;
var on_ceiling;

### anim controller vars ###
var currentSprite;
var anim;
var new_anim;

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

################## INITIALIZE_VARS ##################
#Not actually neccessary mostly, but provides an easy
#centrailized location for all default variable values.
func _ready():
	hp = 3;
	
	### default subnode controller vars ###
	currentSprite = get_node("StillSprites");
	anim = "Idle";
	new_anim = "Idle";
	
	### default stat vars ###
	state = 'move';
	pass

################## PROCESS_FUNCTION ##################
#Processes player variables, like hp, damage, and speed.
func _process(delta):
	
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
	pass
	
func _physics_process(delta):
	on_wall = is_on_wall();
	on_floor = is_on_floor();
	on_ceiling = is_on_ceiling();
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