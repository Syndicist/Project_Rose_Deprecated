extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var currentSprite;
var Direction;
var on_floor;
var anim;
var not_attacking;

func _ready():
	currentSprite = get_node("StillSprites");
	Direction = "RIGHT";
	on_floor = true;
	new_anim = "Idle";
	not_attacking = true;
	pass


func _process(delta):
	
	### MOVEMENT AND ACTION ###
	if(on_floor && not_attacking):
		if(Input.is_action_pressed("ui_right")):
			move_local_x();
	
	### ANIMATION ###
	
	var new_anim = "Idle";
	if(on_floor && not_attacking):
		if(Input.is_action_pressed("ui_right")):
			Direction = "RIGHT";
			currentSprite.visible = false;
			currentSprite = get_node("RunSprites");
			currentSprite.visible = true;
			currentSprite.scale.x = 1;
			new_anim = "Run";
		elif(Input.is_action_pressed("ui_left")):
			Direction = "LEFT";
			currentSprite.visible = false;
			currentSprite = get_node("RunSprites");
			currentSprite.visible = true;
			currentSprite.scale.x = -1;
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
		anim = new_anim;
		$animator.play(anim);
	pass
var new_anim = "idle"