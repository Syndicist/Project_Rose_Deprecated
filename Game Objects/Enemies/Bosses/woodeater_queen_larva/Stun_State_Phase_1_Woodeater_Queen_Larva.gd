extends Node2D

onready var host = get_parent().get_parent().get_parent();

var knockback_x;
var knockback_y;
var started;

func _ready():
	knockback_x = -200;
	knockback_y = -250;
	started = false;
	pass;

################## HURT_PLAYER ##################
#Puts the player in a state where they are unable to move until this
#state passes. goes to the move state when it's over.
#This state persists as long as the player's hurt timer is still 
#ticking and the player is not on the floor.
#TODO: give the player the ability to break out?
func execute(delta):
	if(host.is_on_floor() && !started):
		host.velocity.x = 0;
		host.velocity.y = 0;
		host.vspd = 0;
		host.changeSprite(host.get_node("Twitch_Sprites"),"twitch");
		$StunTimer.wait_time = 5;
		$StunTimer.start();
		started = true;
	elif(!started):
		host.changeSprite(host.get_node("Stun_Sprites"),"stun");
		host.velocity.x = knockback_x * host.Direction;
		host.vspd = knockback_y;
	pass

func _on_StunTimer_timeout():
	started = false;
	host.state = 'default';
	pass;
