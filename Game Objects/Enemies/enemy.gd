extends KinematicBody2D

onready var attack = get_node("States").get_node("Default");
onready var move = get_node("States").get_node("Attack");
onready var hurt = get_node("States").get_node("Chase");
onready var actionTimer = get_node("ActionTimer");

var velocity;
var move_spd;
var spd;
var gravity;
var Direction;
var floor_normal;
var hp;
var damage;
var tag;
var susceptible;
var decision;
var jspd;
var vspd;
var fspd;
var wait;
var new_anim;
var anim;
var currentSprite;
var hspd;
var target;

onready var states = {
	'default' : $States/Default,
	'attack' : $States/Attack,
	'chase' : $States/Chase
}
var state;

### Enemy ###
func _ready():
	target = null;
	decision = 0;
	tag = "enemy";
	state = 'default';
	hp = 1;
	wait = 0;
	damage = 1;
	velocity = Vector2(0,0);
	move_spd = 50;
	spd = move_spd;
	vspd = 0;
	fspd = 0;
	jspd = 75;
	gravity = 250;
	#1 = right, -1 = left
	Direction = 1;
	floor_normal = Vector2(0,-1);
	susceptible = "slash"
	anim = "idle";
	new_anim = anim;
	currentSprite = get_node("Idle_Sprites");
	hspd = 0;
	pass

### Kill ###
func _process(delta):
	if(actionTimer.time_left <= 0.1):
		makeDecision();
	wait = rand_range(.5, 2);
	#state machine
	#state = 'default' by default
	states[state].execute(delta);
	
	if(hp <= 0):
		queue_free();
	
	#switch new animation
	if(new_anim != anim):
		Animate();
	pass

### Default Behavior ###
func _physics_process(delta):
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
	decision = randi() % 100 + 1;
	pass

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
