extends Node2D

#node references
onready var host = get_parent().get_parent();
onready var move = get_parent().get_node("Move");

### hurt spd vars ###
var knockback_x;
var knockback_y;

var hurt_timer;

func _ready():
	knockback_x = -200;
	knockback_y = -250;
	hurt_timer = 0;
	pass

func _physics_process(delta):
	hurt_timer -= 1;
	pass

################## MOVE_PLAYER ##################
#Allows the player to move and jump, as well as trigger attacks.
#This is the default and primary state.
func execute(delta):
	
	move.velocity.x = knockback_x * move.Direction;
	move.vspd = knockback_y;
	host.changeSprite("HurtSprites","Hurt");
	
	if(hurt_timer <= 0):
		move.velocity.x = 0;
		move.velocity.y = 0;
		move.vspd = 0;
		host.state = 'move';
	pass