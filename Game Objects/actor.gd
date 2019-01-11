extends KinematicBody2D

###actor_data###
export(int) var max_hp = 1;
export(int) var damage = 1;
export(float) var spd = 50;
export(float) var jspd = 75;
export(float) var gravity = 250;
export(String) var tag = "actor";
var hp;

### anim controller vars ###
var currentSprite;
var anim;
var new_anim;

### movement controller vars ###
var run_spd;
var jump_spd;
var velocity;
var gravity_vector;
var air_time;
var floor_normal;
var vspd;
var fspd;
var hspd;
var Direction;

func _ready():
	hp = max_hp;
	
	### default movement controller vars ###
	#1 = right, -1 = left
	Direction = 1;
	velocity = Vector2(0,0);
	floor_normal = Vector2(0,-1);
	air_time = 0;
	hspd = 0;
	vspd = 0;
	fspd = 0;
	pass;

func _process(delta):
	execute(delta);
	pass;

func _physics_process(delta):
	phys_execute(delta);
	pass;

func execute(delta):
	pass;

func phys_execute(delta):
	pass;

func Kill():
	#TODO: death anims and effects
	queue_free();

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