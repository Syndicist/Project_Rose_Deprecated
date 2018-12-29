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
		effect = preload("res://Game Objects/Enemies/Charger/ChargerAttackEffect.tscn").instance();
		host.add_child(effect);
		$AttackTimer.wait_time = .5;
		$AttackTimer.start();
	if(started && !attacking && host.get_node("Attack_Sprites").frame == charge_key_frame && $AttackTimer.time_left < 0.1):
		host.hspd = 5 * host.spd * host.Direction;
		attacking = true;
		host.get_node("animator").playback_speed = 1;
		effect.col.disabled = false;
		$AttackTimer.wait_time = .5;
		$AttackTimer.start();
	if(started && attacking && (host.get_node("Attack_Sprites").frame == host.get_node("Attack_Sprites").hframes-1) && $AttackTimer.time_left < 0.1):
		effect.queue_free();
		if(host.get_node("jump_cast_feet").is_colliding()):
			host.state = 'defstun';
		elif(host.canSeePlayer()):
			host.state = 'chase';
		else:
			host.state = 'default';
		host.hspd = 0;
		host.velocity.x = 0;
		started = false;
		attacking = false;
		effect = null;
	pass