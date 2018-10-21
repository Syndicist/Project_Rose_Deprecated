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
bash
}
var first_attack;
var combo_step;

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
	first_attack = ATTACK.slash;
	combo_step = 0;
	
	pass

func _physics_process(delta):
	#count time in air
	air_time += delta;
	
	velocity += gravity_vector * delta;
	move_and_slide(velocity, floor_normal);
	if(is_on_floor()):
		air_time = 0;
		velocity.y = 0;
	
	match(state):
		STATE.attack_state:
			AttackState();
		STATE.move_state:
			MoveState(delta);
	
	pass

### Player Attack Combos ###
func AttackState():
	match(first_attack):
		ATTACK.slash:
			if(anim == "StartSlash" && $StartSlashSprites.frame == 2 && combo_step == 0):
				print("!!!");
				var effect = preload("res://scenes/StartSlashEffect.tscn").instance();
				effect.position = Vector2(0,0);
				effect.add_collision_exception_with(self);
				self.add_child(effect);
				effect.get_node("animator").play("slash");
				combo_step += 1;
			changeSprite("StartSlashSprites","StartSlash")
	if(new_anim != anim):
		Animate();
	if(!$animator.is_playing()):
		currentSprite.visible = false;
		state = STATE.move_state;
		combo_step = 0;
	pass

### Move the player ###
func MoveState(delta):
	### attack triggers ###
	if(is_on_floor() && Input.is_action_just_pressed("ui_slash")):
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

