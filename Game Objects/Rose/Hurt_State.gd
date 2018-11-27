extends "res://Game Objects/Rose/Move.gd"

### hurt spd vars ###
var knockback_x;
var knockback_y;

var hurt_timer;

func _ready():
	knockback_x = -200;
	knockback_y = -250;
	hurt_timer = 0;
	pass

func _process(delta):
	if(host.state == 'hurt'):
		this_state = true;
	if(host.state != 'hurt'):
		this_state = false;
		velocity = Vector2(0,0);
		vspd = 0;
		fall_spd = 0;
	pass

func _physics_process(delta):
	._physics_process(delta);
	hurt_timer -= 1;
	pass

################## HURT_PLAYER ##################
#Puts the player in a state where they are unable to move until this
#state passes. goes to the move state when it's over.
#This state persists as long as the player's hurt timer is still 
#ticking and the player is not on the floor.
#TODO: give the player the ability to break out?
func execute(delta):
	velocity.x = knockback_x * host.Direction;
	vspd = knockback_y;
	host.changeSprite("HurtSprites","Hurt");
	
	if(hurt_timer <= 0 && host.on_floor):
		velocity.x = 0;
		velocity.y = 0;
		vspd = 0;
		host.state = 'move';
	pass