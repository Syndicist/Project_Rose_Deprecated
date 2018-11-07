extends Node2D

#parents and siblings
onready var host = get_parent().get_parent();
onready var offender;

### hurt spd vars ###
var knockback_x;
var knockback_y;

var hurt_timer;

func _ready():
	knockback_x = -200;
	knockback_y = -250;
	hurt_timer = 0;
	pass

################## MOVE_PLAYER ##################
#Allows the player to move and jump, as well as trigger attacks.
#This is the default and primary state.
func execute(delta):
	host.set_collision_mask_bit(3,false);
	host.set_collision_mask_bit(4,false);
	
	host.velocity.x = knockback_x * host.Direction;
	host.vspd = knockback_y;
	host.changeSprite("HurtSprites","Hurt");
	
	if(hurt_timer <= 0):
		host.velocity.x = 0;
		host.velocity.y = 0;
		host.vspd = 0;
		host.state = 'move';
		host.set_collision_mask_bit(3,true);
		host.set_collision_mask_bit(4,true);
	pass