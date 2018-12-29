extends "res://Game Objects/Enemies/Default_State_Enemy.gd"

var vhalt = false;

func execute(delta):
	#move left
	if(1 <= host.decision && host.decision <= 40 && host.actionTimer.time_left <= 0.1):
		halt = false;
		if(host.Direction != -1):
			host.scale.x = host.scale.x * -1;
		host.Direction = -1;
		move();
	#move right
	elif(41 <= host.decision && host.decision <= 80 && host.actionTimer.time_left <= 0.1):
		halt = false;
		if(host.Direction != 1):
			host.scale.x = host.scale.x * -1;
		host.Direction = 1;
		move();
	#still
	elif(host.actionTimer.time_left <= 0.1):
		halt = true;
		move();
	
	#move up
	if(1 <= host.vdecision && host.vdecision <= 40 && host.actionTimerTwo.time_left <= 0.1):
		vhalt = false;
		host.vDirection = -1;
		vmove();
	#move down
	elif(41 <= host.vdecision && host.vdecision <= 80 && host.actionTimerTwo.time_left <= 0.1):
		vhalt = false;
		host.vDirection = 1;
		vmove();
	#still
	elif(host.actionTimerTwo.time_left <= 0.1):
		vhalt = true;
		vmove();
	
	
	if(host.canSeePlayer()):
		host.state = 'chase';
	#TODO: let wasp turn maybe?
	"""
	if(host.get_node("forward_cast").is_colliding()):
		host.Direction = host.Direction * -1
		host.scale.x = host.scale.x * -1;"""
	pass

func vmove():
	if(!halt):
		host.actionTimerTwo.wait_time = host.wait;
		host.actionTimerTwo.start();
		host.changeSprite(host.get_node("Move_Sprites"),"move");
		host.vspd = rand_range(20, host.spd*2) * host.vDirection;
		host.get_node("animator").playback_speed = abs(host.vspd/host.spd);
	else:
		host.actionTimerTwo.wait_time = host.wait+1;
		host.actionTimerTwo.start();
		host.changeSprite(host.get_node("Idle_Sprites"),"idle");
		host.vspd = 0;
		host.get_node("animator").playback_speed = 1;
	pass