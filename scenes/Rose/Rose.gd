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
var on_wall;
var dashing;
var vspd;
var hspd;
var fall_spd;

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
var interrupt_time;
var offbalance_time;
var cooldown_timer;

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
	run_spd = 300;
	jump_spd = 500;
	gravity = 1200;
	gravity_vector = Vector2(0,gravity);
	Direction = "right";
	floor_normal = Vector2(0,-1);
	air_time = 0;
	on_wall = false;
	dashing = false;
	vspd = 0;
	hspd = 0;
	fall_spd = 0;
	
	### default stat vars ###
	state = STATE.move_state;

	### default attack vars ###
	first_attack = ATTACK.NIL;
	second_attack = ATTACK.NIL;
	third_attack = ATTACK.NIL;
	combo_step = 0;
	interruptable = false;
	attack_timer = 0;
	interrupt_time = 0;
	offbalance_time = 0;
	cooldown_timer = 0;
	pass


func _process(delta):
	$Camera2D.current = true;
	pass

################## MAIN_FUNCTION ##################
#Processes physical interactions, switches states,
#and manages timers.
func _physics_process(delta):
	on_wall = is_on_wall();
	#count time in air
	air_time += delta;
	
	#add gravity
	fall_spd += gravity_vector.y * delta;
	
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

	#timer for attacks
	attack_timer -= 1;
	cooldown_timer -= 1;
	
	#state machine(state = move_state by default)
	#TODO: hurt_state 
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
	if(is_on_ceiling()):
		fall_spd = jump_spd;
	### attack triggers ###
	#TODO: pierce and bash attack triggers (these need animations first)
	if(Input.is_action_just_pressed("ui_slash") && cooldown_timer <= 0):
		combo_step = 1;
		attack_timer = 75;
		first_attack = ATTACK.slash;
		state = STATE.attack_state;
		if(is_on_floor()):
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
			vspd += -jump_spd;
	
	### moving in the air ###
	#TODO: jump-based special attacks
	elif(!is_on_floor()):
		if(Input.is_action_just_released("ui_jump")):
			if(fall_spd < jump_spd):
				fall_spd = 2*jump_spd/3;
		if(velocity.y>0):
			changeSprite("FallSprites","Fall");
		if(velocity.y<0):
			changeSprite("JumpSprites","Jump");
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
	if(attack_timer <= interrupt_time):
		interruptable = true;
		velocity.x = 0;
		dashing = false;
	else:
		interruptable = false;
		if(dashing):
			velocity.y = 0;
	if(interruptable):
		#reposition Rose.
		#TODO: handle special cases like "jump" to trigger as normal when they are pressed.
		if(Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right") || Input.is_action_just_pressed("ui_jump")):
			combo_step = 0;
		#continue the combo based on input. After so long, Rose falls off balance and is stuck finishing the animation.
		#may need tweaking. Potentially set up a variable that changes based on the attack, so that each attack
		#can have its own interruptable window.
		#TODO: pierce and bash attacks
		elif(combo_step == 2 && attack_timer > offbalance_time):
			if(Input.is_action_just_pressed("ui_slash")):
				second_attack = ATTACK.slash;
				attack_timer = 75;
		elif(combo_step == 3 && attack_timer > offbalance_time):
			if(Input.is_action_just_pressed("ui_slash")):
				third_attack = ATTACK.slash;
				attack_timer = 60;
	
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
		cooldown_timer = 15;
	pass




### COMBOS AND ATTACKS ###
#TODO: Finish all combos (art, animations and code)

### SLASH attacks ###
#initializes and plays the given effect
func makeSlashEffect(effect):
	position.y = position.y - 7;

	effect.position = self.position;
	if(Direction == "left"):
		effect.scale.x = effect.scale.x * -1;
		velocity.x = -effect.spd;
	else:
		velocity.x = effect.spd;
	
	get_parent().add_child(effect);
	effect.get_node("animator").play("slash");
	pass
	
func firstSlash():
	changeSprite("FirstSlashSprites","1stSlash");
	if(anim == "1stSlash" && $FirstSlashSprites.frame == 2 && combo_step == 1):
		var effect = preload("res://scenes/Rose/1st_Slash_Effect.tscn").instance();
		makeSlashEffect(effect);
		combo_step += 1;
		interrupt_time = 35
		offbalance_time = 15
		dashing = true;
	pass
func secondSlash():
	match(first_attack):
		#The slash attack that happens when the first attack is a slash
		ATTACK.slash:
			changeSprite("SecondSlashSpritesXXX","2ndSlashXXX");
			if(anim == "2ndSlashXXX" && $SecondSlashSpritesXXX.frame == 2 && combo_step == 2):
				var effect = preload("res://scenes/Rose/2nd_Slash_Effect_XXX.tscn").instance();
				makeSlashEffect(effect);
				combo_step += 1;
				interrupt_time = 35;
				offbalance_time = 15
				dashing = true;
		#The slash attack that happens when the first attack is a pierce
		ATTACK.pierce:
			null;
		#The slash attack that happens when the first attack is a bash
		ATTACK.bash:
			null;
		ATTACK.NIL:
			null;
	pass
func thirdSlash():
	#XXX COMBO
	if(first_attack == ATTACK.slash && second_attack == ATTACK.slash):
		changeSprite("ThirdSlashSpritesXXX","3rdSlashXXX");
		if(anim == "3rdSlashXXX" && $ThirdSlashSpritesXXX.frame == 1 && combo_step == 3):
			var effect = preload("res://scenes/Rose/3rd_Slash_Effect_XXX.tscn").instance();
			makeSlashEffect(effect);
			combo_step += 1;
			interrupt_time = 35;
			offbalance_time = 15
			dashing = true;
	pass

### PIERCE attacks ###
#TODO: this thing
#Called until player unlocks true Pierce attacks.
#Does no damage, but pushes enemies back.
func defaultPierce():
	pass
#TODO: everything else
func firstPierce():
	pass
func secondPierce():
	pass
func thirdPierce():
	pass

### BASH attacks ###
#TODO: this thing
#Called until player unlocks true Bash attacks.
#Does no damage, but stuns the first enemy struck.
#Stunned enemies deal no contact damage.
func defaultBash():
	pass
#TODO: everything else
func firstBash():
	pass
func secondBash():
	pass
func thirdBash():
	pass