extends "res://Game Objects/Enemies/Enemy_State.gd"

var stunned = false;

func execute(delta):
	if(!stunned):
		$StunTimer.wait_time = 3;
		$StunTimer.start();
		stunned = true;
		host.hspd = 0;
		host.vspd = 0;
		host.changeSprite(host.get_node("Stun_Sprites"), 'stun');
	pass;



func _on_StunTimer_timeout():
	host.state = 'default';
	stunned = false;
	pass;
