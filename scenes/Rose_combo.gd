extends KinematicBody2D

### subnode controller vars ###
var currentSprite;
var anim;
var new_anim;

### movement controller vars ###
var on_floor;
var velocity;
var run_spd;
var jump_spd;
var gravity;
var gravity_vector;
var Direction;
var floor_normal;
var air_time;

### state vars ###
enum STATE{
move_state,
attack_state
}
var state;

### attack vars ###
enum ATTACK{
slash,
pierce,
bash,
NIL
}
var first_attack;
var second_attack;
var third_attack;
var combo_step;
var interruptable;
var attack_timer;

################## INITIALIZE_VARS ##################
#Not actually neccessary mostly, but provides an easy
#centrailized location for all default variable values.
func _ready():
	### default subnode controller vars ###
	currentSprite = get_node("StillSprites");
	anim = "Idle";
	new_anim = "Idle";

	### default movement controller vars ###
	on_floor = false;
	velocity = Vector2(0,0);
	run_spd = 250;
	jump_spd = 480;
	gravity = 900;
	gravity_vector = Vector2(0,gravity);
	Direction = "right";
	floor_normal = Vector2(0,-1);
	air_time = 0;

	### default stat vars ###
	state = STATE.move_state;

	### default attack vars ###
	first_attack = ATTACK.NIL;
	second_attack = ATTACK.NIL;
	third_attack = ATTACK.NIL;
	combo_step = 0;
	interruptable = false;
	attack_timer = 0;
	pass

################## MAIN_FUNCTION ##################
#Processes physical interactions, switches states,
#and manages timers.
func _physics_process(delta):
	#count time in air
	air_time += delta;
	
	#add gravity
	velocity += gravity_vector * delta;
	
	#move across surfaces
	move_and_slide(velocity, floor_normal);
	
	#no gravity acceleration when on floor
	if(is_on_floor()):
		air_time = 0;
		velocity.y = 0;
	
	#timer for attacks
	attack_timer-= 1
	
	#state machine(state = move_state by default)
	#TODO: hurt_state, debuffed states, buffed states, 
	match(state):
		STATE.attack_state:
			AttackState();
		STATE.move_state:
			MoveState(delta);
	
	pass

################## MOVE_PLAYER ##################
#Allows the player to move and jump, as well as trigger attacks.
#This is the default and primary state.
func MoveState(delta):
	### attack triggers ###
	#TODO: pierce and bash attack triggers (these need animations first)
	if(is_on_floor() && Input.is_action_just_pressed("ui_slash")):
		combo_step = 1;
		attack_timer = 75;
		first_attack = ATTACK.slash;
		state = STATE.attack_state;
		velocity.x = 0;
	### move triggers ###
	elif(is_on_floor()):
		if(Input.is_action_pressed("ui_right")):
			if(Direction != "right"):
				scale.x = scale.x * -1;
			velocity.x = run_spd;
			Direction = "right";
			changeSprite("RunSprites","Run");
		elif(Input.is_action_pressed("ui_left")):
			if(Direction != "left"):
				scale.x = scale.x * -1;
			velocity.x = -run_spd;
			Direction = "left";
			changeSprite("RunSprites","Run");
		else:
			velocity.x = 0;
			changeSprite("StillSprites","Idle");
		if(Input.is_action_just_pressed("ui_jump")):
			velocity.y = -jump_spd;
			#TODO: change to jump sprite and animation
	
	### moving in the air ###
	#TODO: jump-based special attacks and mid-air combos
	elif(!is_on_floor()):
		if(Input.is_action_pressed("ui_right")):
			if(Direction != "right"):
				scale.x = scale.x * -1;
			velocity.x = run_spd;
			Direction = "right";
		elif(Input.is_action_pressed("ui_left")):
			if(Direction != "left"):
				scale.x = scale.x * -1;
			velocity.x = -run_spd;
			Direction = "left";
		else:
			velocity.x = 0;
	
	### update animation ###
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

################## ATTACK_HANDLING ##################
#Checks for given attack inputs and triggers them 
#sequentially. 
func AttackState():
	#Attack animations should not ever be interuptable when they're first triggered.
	interruptable = false;
	#finds what attack to do first based on input.
	match(first_attack):
		ATTACK.slash:
			firstSlash();
		ATTACK.pierce:
			firstPierce();
		ATTACK.bash:
			firstBash();
		ATTACK.NIL:
			null;
	#finds what attack to do second based on input.
	match(second_attack):
		ATTACK.slash:
			secondSlash();
		ATTACK.pierce:
			secondPierce();
		ATTACK.bash:
			secondBash();
		ATTACK.NIL:
			null;
	#finds what attack to do third based on input.
	match(third_attack):
		ATTACK.slash:
			thirdSlash();
		ATTACK.pierce:
			thirdPierce();
		ATTACK.bash:
			thirdBash();
		ATTACK.NIL:
			null;
	
	#after 35 ticks, the animation can be cancled to do the next combo or reposition Rose.
	#may need tweaking. Potentially set up a variable that changes based on the attack, so that each attack
	#can have its own interruptable window.
	if(attack_timer <= 35):
		interruptable = true;
		velocity.x = 0;
	else:
		interruptable = false;
	if(interruptable):
		#reposition Rose.
		#TODO: handle special cases like "jump" to trigger as normal when they are pressed.
		if(Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right") || Input.is_action_just_pressed("ui_jump")):
			combo_step = 0;
		#continue the combo based on input. After so long, Rose falls off balance and is stuck finishing the animation.
		#may need tweaking. Potentially set up a variable that changes based on the attack, so that each attack
		#can have its own interruptable window.
		#TODO: pierce and bash attacks
		elif(combo_step == 2 && attack_timer > 25):
			if(Input.is_action_just_pressed("ui_slash")):
				second_attack = ATTACK.slash;
				attack_timer = 75;
		elif(combo_step == 3 && attack_timer > 25):
			if(Input.is_action_just_pressed("ui_slash")):
				third_attack = ATTACK.slash;
				attack_timer = 75;
	
	#the combo is finished
	if(attack_timer <= 0):
		combo_step = 0;
	#switch animation
	if(new_anim != anim):
		Animate();
	if(combo_step == 0):
		first_attack = ATTACK.NIL;
		second_attack = ATTACK.NIL;
		third_attack = ATTACK.NIL;
		currentSprite.visible = false;
		state = STATE.move_state;
	pass




### COMBOS AND ATTACKS ###
#TODO: implement combo checking
#TODO: special attacks based on combos
#TODO: unique sprite animations for second and third attack.
#TODO: also, animations for everything else

### SLASH attacks ###
func firstSlash():
	changeSprite("FirstSlashSprites","1stSlash");
	if(anim == "1stSlash" && $FirstSlashSprites.frame == 2 && combo_step == 1):
		var effect = preload("res://scenes/1st_Slash_Effect.tscn").instance();
		effect.position = self.position;
		if(Direction == "left"):
			effect.scale.x = effect.scale.x * -1;
			effect.velocity.x = -500
			velocity.x = -500;
		else:
			effect.velocity.x = 500;
			velocity.x = 500;
		effect.add_collision_exception_with(self);
		get_parent().add_child(effect);
		effect.get_node("animator").play("slash");
		combo_step += 1;
	pass
func secondSlash():
	changeSprite("SecondSlashSpritesXXX","2ndSlashXXX");
	if(anim == "2ndSlashXXX" && $SecondSlashSpritesXXX.frame == 2 && combo_step == 2):
		#TODO: unique effect sprite
		#var effect = preload("res://scenes/StartSlashEffect.tscn").instance();
		#effect.position = self.position;
		#if(Direction == "left"):
		#	effect.scale.x = effect.scale.x * -1;
		#effect.add_collision_exception_with(self);
		#get_parent().add_child(effect);
		#effect.get_node("animator").play("slash");
		combo_step += 1;
	pass
func thirdSlash():
	changeSprite("ThirdSlashSpritesXXX","3rdSlashXXX");
	if(anim == "3rdSlashXXX" && $ThirdSlashSpritesXXX.frame == 1 && combo_step == 3):
		#TODO: unique effect sprite
		#var effect = preload("res://scenes/StartSlashEffect.tscn").instance();
		#effect.position = self.position;
		#if(Direction == "left"):
		#	effect.scale.x = effect.scale.x * -1;
		#effect.add_collision_exception_with(self);
		#get_parent().add_child(effect);
		#effect.get_node("animator").play("slash");
		combo_step += 1;
	pass

### PIERCE attacks ###
#Called until player unlocks true Pierce attacks.
#Does no damage, but pushes enemies back.
func defaultPierce():
	pass
func firstPierce():
	pass
func secondPierce():
	pass
func thirdPierce():
	pass

### BASH attacks ###
#Called until player unlocks true Bash attacks.
#Does no damage, but stuns the first enemy struck.
#Stunned enemies deal no contact damage.
func defaultBash():
	pass
func firstBash():
	pass
func secondBash():
	pass
func thirdBash():
	pass