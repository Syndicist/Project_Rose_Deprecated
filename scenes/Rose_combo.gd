extends KinematicBody2D

### subnode controller vars ###
var currentSprite;
var anim;
var new_anim;

### movement controller vars ###
var not_attacking;
var on_floor;
var velocity;
var run_spd;
var jump_spd;
var gravity;
var gravity_vector;
var Direction;
var floor_normal;
var turn_speed;
var air_time;
var prev_velocity;

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
var timer;

#initialize variables
func _ready():
	### default subnode controller vars ###
	currentSprite = get_node("StillSprites");
	anim = "Idle";
	new_anim = "Idle";

	### default movement controller vars ###
	not_attacking = true;
	on_floor = false;
	velocity = Vector2(0,0);
	run_spd = 250;
	jump_spd = 480;
	gravity = 900;
	gravity_vector = Vector2(0,gravity);
	Direction = "right";
	floor_normal = Vector2(0,-1);
	turn_speed = 10;
	air_time = 0;
	prev_velocity = Vector2(0,0);

	### default stat vars ###
	state = STATE.move_state;

	### default attack vars ###
	first_attack = ATTACK.NIL;
	second_attack = ATTACK.NIL;
	third_attack = ATTACK.NIL;
	combo_step = 0;
	interruptable = false;
	timer = 0;
	pass


func _physics_process(delta):
	#count time in air
	air_time += delta;
	
	velocity += gravity_vector * delta;
	move_and_slide(velocity, floor_normal);
	if(is_on_floor()):
		air_time = 0;
		velocity.y = 0;
	
	timer-= 1
	
	match(state):
		STATE.attack_state:
			AttackState();
		STATE.move_state:
			MoveState(delta);
	
	pass

### Player Attack Combos ###
func AttackState():
	#animation canceling
	interruptable = false;
	#finds what attack to do first based on input
	match(first_attack):
		ATTACK.slash:
			firstSlash();
		ATTACK.pierce:
			null;
		ATTACK.bash:
			null;
		ATTACK.NIL:
			null;
	#finds what attack to do second based on input
	match(second_attack):
		ATTACK.slash:
			secondSlash();
		ATTACK.pierce:
			null;
		ATTACK.bash:
			null;
		ATTACK.NIL:
			null;
	#after 35 ticks, the animation can be cancled to do the next combo or reposition
	if(timer <= 35):
		interruptable = true;
	else:
		interruptable = false;
	if(interruptable):
		#reposition Rose, TODO: handle special cases like "jump"
		if(Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right") || Input.is_action_just_pressed("ui_jump")):
			combo_step = 0;
		#continue the combo. After so long, Rose falls off balance and is stuck finishing the animation.
		elif(combo_step == 1 && timer > 25):
			if(Input.is_action_just_pressed("ui_slash")):
				second_attack = ATTACK.slash;
				timer = 75;
	#the combo is finished
	if(timer <= 0):
		combo_step = 0;
	if(new_anim != anim):
		Animate();
	#THIS CAUSES EFFECT TO FLIP WHEN INTERRUPTED, NEEDS REVISION
	if($StartSlashSprites.frame == 2 && combo_step == 0):
		first_attack = ATTACK.NIL;
		second_attack = ATTACK.NIL;
		third_attack = ATTACK.NIL;
		currentSprite.visible = false;
		state = STATE.move_state;
	pass

### Move the player ###
func MoveState(delta):
	### attack triggers ###
	if(is_on_floor() && Input.is_action_just_pressed("ui_slash")):
		timer = 75;
		first_attack = ATTACK.slash;
		state = STATE.attack_state;
		velocity.x = 0;
	#TODO: pierce and bash attacks, jump attacks
	### move triggers ###
	elif(is_on_floor()):
		prev_velocity = velocity;
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

	### check animation ###
	if(new_anim != anim):
		Animate();
	pass

#Animates a new animation
func Animate():
	$animator.stop();
	anim = new_anim;
	$animator.play(anim);
	pass

#changes the sprite node
func changeSprite(sprite, animation):
	currentSprite.visible = false;
	currentSprite = get_node(sprite);
	currentSprite.visible = true;
	new_anim = animation;
	pass

### SLASH combos ###
func firstSlash():
	changeSprite("StartSlashSprites","StartSlash");
	if(anim == "StartSlash" && $StartSlashSprites.frame == 2 && combo_step == 0):
		var effect = preload("res://scenes/StartSlashEffect.tscn").instance();
		effect.position = Vector2(0,0);
		effect.add_collision_exception_with(self);
		self.add_child(effect);
		effect.get_node("animator").play("slash");
		combo_step += 1;
	pass
func secondSlash():
	changeSprite("MidSlashSprites","MidSlash");
	if(anim == "MidSlash" && $MidSlashSprites.frame == 2 && combo_step == 1):
		var effect = preload("res://scenes/StartSlashEffect.tscn").instance();
		effect.position = Vector2(0,0);
		effect.add_collision_exception_with(self);
		self.add_child(effect);
		effect.get_node("animator").play("slash");
		combo_step += 1;
	pass