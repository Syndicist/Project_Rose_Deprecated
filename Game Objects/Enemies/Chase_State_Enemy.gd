extends Node2D

onready var host = get_parent().get_parent();

func execute(delta):
	if(host.player.global_position.x > host.global_position.x):
		if(host.Direction != 1):
			host.scale.x = host.scale.x * -1;
		host.Direction = 1;
	elif(host.player.global_position.x < host.global_position.x):
		if(host.Direction != -1):
			host.scale.x = host.scale.x * -1;
		host.Direction = -1;
	host.changeSprite(host.get_node("Move_Sprites"),"move");
	host.hspd = host.spd * host.Direction;
	host.get_node("animator").playback_speed = 1;
	
	if((host.global_position.x > host.player.global_position.x && host.global_position.x - host.player.global_position.x < host.arange) || (host.global_position.x < host.player.global_position.x && host.player.global_position.x - host.global_position.x < host.arange)):
		host.state = 'attack';
		host.hspd = 0;
		host.velocity.x = 0;
	elif(!host.canSeePlayer()):
		host.state = 'default';
	pass