extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var currentSprite;
var on_floor;
var anim;
var not_attacking;
var velocity = Vector2();
var run_spd;
var Direction;

func _physics_process(delta):
	currentSprite = get_node("StillSprites");
	on_floor = true;
	new_anim = "Idle";
	not_attacking = true;
	run_spd = 3;
	Direction = "right";
	pass


func _process(delta):
	
	### MOVEMENT AND ACTION ###
	if(on_floor && not_attacking):
		if(Input.is_action_pressed("ui_right")):
			velocity.x = run_spd;
		elif(Input.is_action_pressed("ui_left")):
			velocity.x = -run_spd;
		else:
			velocity.x = 0;
	move_and_slide(velocity);
	
	### ANIMATION ###
	
	var new_anim = "Idle";
	if(on_floor && not_attacking):
		if(velocity.x>0):
			if(Direction != "right"):
				scale.x = scale.x * -1;
				Direction = "right";x1
			currentSprite.visible = false;
			currentSprite = get_node("RunSprites");
			currentSprite.visible = true;
			new_anim = "Run";
		elif(velocity.x<0):
			if(Direction != "left"):
				scale.x = scale.x * -1;
				Direction = "left";
			currentSprite.visible = false;
			currentSprite = get_node("RunSprites");
			currentSprite.visible = true;
			scale.x = scale.x * -1;
			new_anim = "Run";
		else:
			currentSprite.visible = false;
			currentSprite = get_node("StillSprites");
			currentSprite.visible = true;
			new_anim = "Idle";
	elif(on_floor && !not_attacking):
		currentSprite.visible = false;
		currentSprite = get_node("StartSlashSprites");
		currentSprite.visible = true;
		new_anim = "StartSlash";
		## TODO: Switch statement for different attacks and combos
	#elif(!on_floor && not_attacking):
		## TODO: jumping animations
	#elif(!on_floor && !not_attacking):
		## TODO: jump attacks
		
	if(new_anim != anim):
		$animator.stop();
		anim = new_anim;
		$animator.play(anim);
	pass
var new_anim = "idle"