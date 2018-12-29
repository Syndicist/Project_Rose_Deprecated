extends "res://Game Objects/Enemies/Default_State_Enemy.gd"

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
	
	if(host.canSeePlayer()):
		host.state = 'chase';
	
	#TODO: create timer so they dont immediately turn towards the wall again.
	if(host.get_node("jump_cast_feet").is_colliding() || !host.get_node("jump_cast_head").is_colliding()):
		host.Direction = host.Direction * -1
		host.scale.x = host.scale.x * -1;
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