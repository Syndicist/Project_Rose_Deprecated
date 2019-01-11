extends "res://Game Objects/Enemies/Chase_State_Enemy.gd"

var stp=true;
var rand;
var wait = .25;

func _ready():
	$ChaseTimer.wait_time = .5;
	pass

func execute(delta):
	if(host.player.global_position.x > host.global_position.x):
		if(host.Direction != 1):
			host.scale.x = host.scale.x * -1;
		host.Direction = 1;
	elif(host.player.global_position.x < host.global_position.x):
		if(host.Direction != -1):
			host.scale.x = host.scale.x * -1;
		host.Direction = -1;
	if(host.player.global_position.y > host.global_position.y):
		host.vDirection = 1;
	elif(host.player.global_position.y < host.global_position.y):
		host.vDirection = -1;
	host.changeSprite(host.get_node("Move_Sprites"),"move");
	
	if($ChaseTimer.time_left < 0.1 && stp):
		host.hspd = 0;
		host.vspd = 0;
		rand = rand_range(-host.spd, host.spd);
		stp = false;
		$ChaseTimer.wait_time = wait;
		$ChaseTimer.start();
	elif($ChaseTimer.time_left < 0.1 && !stp):
		host.hspd = host.spd * host.Direction;
		host.vspd = rand;
		stp = true;
		$ChaseTimer.wait_time = wait;
		$ChaseTimer.start();
	
	
	host.get_node("animator").playback_speed = 1;
	
	if((host.global_position.x > host.player.global_position.x && host.global_position.x - host.player.global_position.x < host.arange) || (host.global_position.x < host.player.global_position.x && host.player.global_position.x - host.global_position.x < host.arange)):
		host.state = 'attack';
		host.hspd = 0;
		host.vspd = 0;
		host.velocity.x = 0;
		host.velocity.y = 0;
		stp = true;
	elif(!host.canSeePlayer()):
		host.state = 'default';
		stp = true;
	pass
