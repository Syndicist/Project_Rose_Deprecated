extends "res://Game Objects/Enemies/Enemy_State.gd"

var stunned = false;

func execute(delta):
	if(!stunned):
		$StunTimer.wait_time = 3;
		$StunTimer.start();
		stunned = true;
		host.hspd = 0;
		host.vspd = 0;
	if($StunTimer.time_left < 0.1):
		host.state = 'default';
		stunned = false;
	pass