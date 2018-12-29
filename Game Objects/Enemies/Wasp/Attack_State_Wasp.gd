extends "res://Game Objects/Enemies/Attack_State_Enemy.gd"

func _ready():
	started = false;
	attacking = false;
	charge_key_frame = 0;
	pass

func execute(delta):
	if(!started):
		started = true;
		host.changeSprite(host.get_node("Attack_Sprites"),"attack");
		host.get_node("animator").playback_speed = .5
		effect = preload("res://Game Objects/Enemies/Wasp/WaspAttackEffect.tscn").instance();
		host.add_child(effect);
		$AttackTimer.wait_time = .25;
		$AttackTimer.start();
	if(started && !attacking && host.get_node("Attack_Sprites").frame == charge_key_frame):
		host.hspd = 3 * host.spd * host.Direction;
		host.vspd = 3 * host.spd * host.vDirection;
		attacking = true;
		host.get_node("animator").playback_speed = 1;
		effect.col.disabled = false;
	#TODO: Make a timer or something, this doesn't trigger properly
	if(started && attacking && (host.get_node("Attack_Sprites").frame == host.get_node("Attack_Sprites").hframes-1) && $AttackTimer.time_left < 0.1):
		effect.queue_free();
		if(host.canSeePlayer()):
			host.state = 'chase';
		else:
			host.state = 'default';
		host.hspd = 0;
		host.velocity.x = 0;
		started = false;
		attacking = false;
		effect = null;
	pass