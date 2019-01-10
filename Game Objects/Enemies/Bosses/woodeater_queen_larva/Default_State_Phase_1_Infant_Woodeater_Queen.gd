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
	if(1 <= movedec && movedec <= 40 && decided):
		halt = false;
		host.Direction = -1;
		decided = false;
		go();
	elif(41 <= movedec && movedec <= 80 && decided):
		decided = false;
		halt = false;
		host.Direction = 1;
		go();
	elif(decided):
		decided = false;
		halt = true;
		go();
	
	move();
	
	
	if((host.global_position.x > host.player.global_position.x && host.global_position.x - host.player.global_position.x < host.arange) || (host.global_position.x < host.player.global_position.x && host.player.global_position.x - host.global_position.x < host.arange)):
		var coin = randi() % 2 + 1;
		if(coin == 1):
			host.actionTimer.paused = true;
			$MoveTimer.stop();
			host.state = 'bite';
			host.hspd = 0;
	pass

func go():
	$MoveTimer.wait_time = rand_range(.5,2.5);
	$MoveTimer.start();
	if(!halt):
		host.changeSprite(host.get_node("Move_Sprites"),"move");
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