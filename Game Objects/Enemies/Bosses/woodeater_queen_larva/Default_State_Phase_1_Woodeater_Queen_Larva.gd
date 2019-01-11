extends Node2D

onready var host = get_parent().get_parent().get_parent();

var movedec = 0;
var halt = false;
var tspd = 0;
var decided = false;

func execute(delta):
	if($MoveTimer.is_stopped()):
		movedec = host.makeDecision();
		decided = true;
	#move towards the player (60%)
	if(1 <= movedec && movedec <= 60):
		host.changeSprite(host.get_node("Move_Sprites"),"move");
		if(host.player.global_position.x > host.global_position.x):
			host.Direction = 1;
		elif(host.player.global_position.x < host.global_position.x):
			host.Direction = -1;
	#move away from the player (20%)
	elif(61 <= movedec && movedec <= 80):
		host.changeSprite(host.get_node("Move_Back_Sprites"),"move_back");
		if(host.player.global_position.x > host.global_position.x):
			host.Direction = -1;
		elif(host.player.global_position.x < host.global_position.x):
			host.Direction = 1;
	
	if(1 <= movedec && movedec <= 40 && decided):
		halt = false;
		decided = false;
		go();
	elif(41 <= movedec && movedec <= 80 && decided):
		decided = false;
		halt = false;
		go();
	elif(decided):
		decided = false;
		halt = true;
		go();
	
	move();
	
	#if the player is close, consider biting
	if((host.global_position.x > host.player.global_position.x && host.global_position.x - host.player.global_position.x < host.arange) || (host.global_position.x < host.player.global_position.x && host.player.global_position.x - host.global_position.x < host.arange)):
		var coin = randi() % 5 + 1;
		if(coin == 1):
			host.actionTimer.stop();
			$MoveTimer.stop();
			host.state = 'bite';
			host.hspd = 0;
	pass

func go():
	$MoveTimer.wait_time = rand_range(.5,2.5);
	$MoveTimer.start();
	if(!halt):
		tspd = rand_range(host.spd/2, host.spd*2);
	else:
		host.changeSprite(host.get_node("Idle_Sprites"),"idle");
		tspd = 0;
	pass

func move():
	if(!halt):
		host.hspd = tspd * host.Direction;
		host.get_node("animator").playback_speed = abs(host.hspd/host.spd);
	else:
		host.hspd = 0;
		host.get_node("animator").playback_speed = 1;
	pass