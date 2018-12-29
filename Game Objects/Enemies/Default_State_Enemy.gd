extends Node2D

onready var host = get_parent().get_parent();

var halt = false;
var tspd = 0;

func execute(delta):
	if(1 <= host.decision && host.decision <= 40 && host.actionTimer.time_left <= 0.1):
		halt = false;
		if(host.Direction != -1):
			host.scale.x = host.scale.x * -1;
		host.Direction = -1;
		go();
	elif(41 <= host.decision && host.decision <= 80 && host.actionTimer.time_left <= 0.1):
		halt = false;
		if(host.Direction != 1):
			host.scale.x = host.scale.x * -1;
		host.Direction = 1;
		go();
	elif(host.actionTimer.time_left <= 0.1):
		halt = true;
		go();
	
	move();
	
	#TODO: create timer so they dont immediately turn towards the wall again.
	if(host.get_node("jump_cast_feet").is_colliding()):
		var jump = randi() % 2 + 1
		if(host.fspd >=0):
			if(!host.get_node("jump_cast_head").is_colliding() && jump == 1 && host.jspd > 0):
				host.vspd = -host.jspd;
			else:
				host.Direction = host.Direction * -1
				host.scale.x = host.scale.x * -1;
	
	if(host.canSeePlayer()):
		host.state = 'chase';
	pass

func go():
	if(!halt):
		host.actionTimer.wait_time = host.wait;
		host.actionTimer.start();
		host.changeSprite(host.get_node("Move_Sprites"),"move");
		tspd = rand_range(20, host.spd*2);
	else:
		host.actionTimer.wait_time = host.wait+1;
		host.actionTimer.start();
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