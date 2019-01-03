extends "res://Game Objects/Enemies/Default_State_Enemy.gd"

var vhalt = false;

func execute(delta):
	#move left
	if(1 <= host.decision && host.decision <= 45 && host.actionTimer.time_left <= 0.1):
		halt = false;
		if(host.Direction != -1):
			host.scale.x = host.scale.x * -1;
		host.Direction = -1;
		move();
	#move right
	elif(46 <= host.decision && host.decision <= 90 && host.actionTimer.time_left <= 0.1):
		halt = false;
		if(host.Direction != 1):
			host.scale.x = host.scale.x * -1;
		host.Direction = 1;
		move();
	#still
	elif(host.actionTimer.time_left <= 0.1):
		halt = true;
		move();
	
	#still
	if((host.actionTimer.time_left <= 0.1) || halt):
		vhalt = true;
		vmove();
	#move up
	elif(1 <= host.vdecision && host.vdecision <= 45 && host.actionTimerTwo.time_left <= 0.1):
		vhalt = false;
		host.vDirection = -1;
		vmove();
	#move down
	elif(46 <= host.vdecision && host.vdecision <= 90 && host.actionTimerTwo.time_left <= 0.1):
		vhalt = false;
		host.vDirection = 1;
		vmove();

	
	if(host.canSeePlayer()):
		host.state = 'chase';
	#TODO: let wasp turn maybe?
	"""
	if(host.get_node("forward_cast").is_colliding()):
		host.Direction = host.Direction * -1
		host.scale.x = host.scale.x * -1;"""
	pass

func move():
	if(!halt):
		host.actionTimer.wait_time = host.wait;
		host.actionTimer.start();
		host.changeSprite(host.get_node("Move_Sprites"),"move");
		host.hspd = rand_range(host.spd, host.spd*2) * host.Direction;
		host.get_node("animator").playback_speed = abs(host.hspd/host.spd);
	else:
		host.actionTimer.wait_time = host.wait + .5;
		host.actionTimer.start();
		host.changeSprite(host.get_node("Idle_Sprites"),"idle");
		host.hspd = 0;
		host.get_node("animator").playback_speed = 1;
	pass

func vmove():
	if(!vhalt):
		host.actionTimerTwo.wait_time = host.wait;
		host.actionTimerTwo.start();
		host.changeSprite(host.get_node("Move_Sprites"),"move");
		host.vspd = rand_range(host.spd, host.spd*2) * host.vDirection;
		host.get_node("animator").playback_speed = abs(host.vspd/host.spd);
	else:
		host.actionTimerTwo.wait_time = host.wait + .5;
		host.actionTimerTwo.start();
		host.changeSprite(host.get_node("Idle_Sprites"),"idle");
		host.vspd = 0;
		host.get_node("animator").playback_speed = 1;
	pass