extends "res://Game Objects/Enemies/enemy.gd"

#handles states and phases
#3 phases
	#1: can bite, charge, and slam, moves fairly slowly and predictably
	#2: gains burrow, is a bit faster. spits acid out and in burrow, can do burrow charge
	#3: bite combo, moves even faster, burrow bite, acid laser in and out of burrow


onready var phases = {
	'1' : "PhaseOneStates",
	'2' : "PhaseTwoStates",
	'3' : "PhaseThreeStates"
}
var phase;

onready var burrowed = {
	true : "BurrowedSuperState",
	false : "UnburrowedSuperState"
}
var is_burrowed;
var burrow_moves;

var flipped = false;
var active = false;

### Enemy ###
func _ready():
	states = {
	'default' : "Default",
	'slam' : "Slam",
	'bite' : "Bite",
	'charge' : "Charge",
	'stun' : "Stun",
	'transition' : "Transition",
	'shoot' : "Shoot",
	'beam' : "Beam"
	}
	state = 'default';
	phase = '1';
	is_burrowed = false;
	burrow_moves = 0;
	anim = "idle";
	new_anim = anim;
	currentSprite = get_node("Idle_Sprites");
	actionTimer.wait_time = rand_range(2,4);
	actionTimer.start();
	pass

func execute(delta):
	if(hp <= 0):
		Kill();
	
	#switch new animation
	if(new_anim != anim):
		Animate();
	pass

func phys_execute(delta):
	if(active):
		#phase switcher
		if(float(hp)/float(max_hp) <= .75):
			phase = '2';
		if(float(hp)/float(max_hp) <= .45):
			phase = '3';
		
		if(player.global_position.x > global_position.x && state == 'default'):
			flipped = false;
			Direction = 1;
		elif(player.global_position.x < global_position.x && state == 'default'):
			flipped = true;
			Direction = -1;
		currentSprite.flip_h = flipped;
		
		#state machine
		get_node(phases[phase]).get_node(burrowed[is_burrowed]).get_node(states[state]).execute(delta);
		
		velocity.x = hspd;
		velocity.y = vspd + fspd;
		velocity = move_and_slide(velocity,floor_normal);
		
		#no gravity acceleration when on floor
		if(is_on_floor() || state == 'slam'):
			velocity.y = 0
			vspd = 0;
			fspd = 0;
	
		#add gravity
		if(state != 'slam'):
			fspd += gravity * delta;
	
		#cap gravity
		if(fspd > 900):
			fspd = 900;
		if(is_on_ceiling()):
			fspd = 500;
	pass

#Do new action
func _on_ActionTimer_timeout():
	decision = makeDecision();
	actionTimer.wait_time = 3;
	#move a bit (10%)
	if(decision >= 1 && decision <= 10):
		actionTimer.wait_time = rand_range(2,4);
		actionTimer.start();
		state = 'default';
	#burrow or slam (15%)
	elif(decision >= 11 && decision <= 25):
		#burrow
		if(phase != '1'):
			burrow_moves = randi() % 4 + 2;
			state = 'transition';
		else:
			state = 'slam';
	#slam (10%)
	elif(decision >= 26 && decision <= 35):
		state = 'slam';
	#bite(20%)
	elif(decision >= 36 && decision <= 55):
		state = 'bite';
	#charge(15%)
	elif(decision >= 56 && decision <= 70):
		null;
		#state = 'charge';
	#shoot or bite(20%)
	elif(decision >= 71 && decision <= 90):
		if(phase != '1'):
			state = 'shoot';
		else:
			state = 'bite';
	#beam or move(10%)
	elif(decision >= 91 && decision <= 100):
		if(phase >= '3'):
			state = 'beam';
		else:
			actionTimer.wait_time = rand_range(2,4);
			actionTimer.start();
			state = 'default';
	pass;


func _on_rotted_bark4_tree_exited():
	active = true;
	actionTimer.wait_time = rand_range(2,4);
	actionTimer.start();
	pass
