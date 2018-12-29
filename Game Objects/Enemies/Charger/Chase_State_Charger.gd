extends "res://Game Objects/Enemies/Chase_State_Enemy.gd"

var charging = false;

func execute(delta):
	if(!charging):
		if(host.player.position.x > host.position.x):
			if(host.Direction != 1):
				host.scale.x = host.scale.x * -1;
			host.Direction = 1;
		elif(host.player.position.x < host.position.x):
			if(host.Direction != -1):
				host.scale.x = host.scale.x * -1;
			host.Direction = -1;
		charging = true;
	
	host.changeSprite(host.get_node("Charge_Sprites"),"charge");
	host.hspd = host.spd*4 * host.Direction;
	host.get_node("animator").playback_speed = 1;
	
	if(host.get_node("charge_cast").is_colliding()):
		host.state = 'attack';
		host.hspd = 0;
		host.velocity.x = 0;
		charging = false;
	pass