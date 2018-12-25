extends Node2D

onready var host = get_parent().get_parent();



func execute(delta):
	if(host.target == null):
		host.state = 'default';
		return;
	if(host.target.position.x > host.position.x):
		if(host.Direction != 1):
			host.scale.x = host.scale.x * -1;
		host.Direction = 1;
	elif(host.target.position.x < host.position.x):
		if(host.Direction != -1):
			host.scale.x = host.scale.x * -1;
		host.Direction = -1;
	host.changeSprite(host.get_node("Move_Sprites"),"move");
	host.hspd = host.spd * host.Direction;
	host.get_node("animator").playback_speed = 1;
	
	if((host.position.x > host.target.position.x && host.position.x - host.target.position.x < 50) || (host.position.x < host.target.position.x && host.target.position.x - host.position.x < 50)):
		print("ATTACK");
		host.state = 'attack';
		host.hspd = 0;
		host.velocity.x = 0;
	pass
