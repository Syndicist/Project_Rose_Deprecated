extends Node2D

onready var host = get_parent().get_parent();

var halt = false;

func execute(delta):
	if(1 <= host.decision && host.decision <= 40 && host.actionTimer.time_left <= 0.1):
		halt = false;
		if(host.Direction != -1):
			host.scale.x = host.scale.x * -1;
		host.Direction = -1;
		move(host.Direction);
	elif(41 <= host.decision && host.decision <= 80 && host.actionTimer.time_left <= 0.1):
		halt = false;
		if(host.Direction != 1):
			host.scale.x = host.scale.x * -1;
		host.Direction = 1;
		move(host.Direction);
	elif(host.actionTimer.time_left <= 0.1):
		halt = true;
		move(host.Direction);
	
	if(host.get_node("forward_cast").is_colliding()):
		var jump = randi() % 2 + 1
		if(host.fspd >=0):
			if(host.jspd < 0 && jump == 1):
				host.vspd = host.jspd;
			elif(host.jspd < 0 && jump == 2):
				host.Direction = host.Direction * -1
				host.scale.x = host.scale.x * -1;
			elif(host.jspd == 0):
				host.Direction = host.Direction * -1
				host.scale.x = host.scale.x * -1;
	pass

func move(dir):
	if(!halt):
		host.actionTimer.wait_time = host.wait;
		host.actionTimer.start();
		host.changeSprite(host.get_node("Move_Sprites"),"move");
		host.hspd = rand_range(20, host.spd*2) * host.Direction;
		host.get_node("animator").playback_speed = abs(host.hspd/host.spd);
	else:
		host.actionTimer.wait_time = host.wait+1;
		host.actionTimer.start();
		host.changeSprite(host.get_node("Idle_Sprites"),"idle");
		host.hspd = 0;
		host.get_node("animator").playback_speed = 1;
	pass