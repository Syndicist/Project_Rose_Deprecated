extends "res://Game Objects/Enemies/enemy.gd"

var vDirection;
var vdecision;
onready var actionTimerTwo = get_node("ActionTimerTwo");

### Enemy ###
func _ready():
	._ready();
	vdecision = 0;
	#1 = down, -1 = up
	vDirection = 1;
	pass

### Kill ###
func _process(delta):
	if(actionTimer.time_left <= 0.1):
		decision = makeDecision();
		vdecision = makeDecision();
	wait = rand_range(.1, .35);
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
	pass
