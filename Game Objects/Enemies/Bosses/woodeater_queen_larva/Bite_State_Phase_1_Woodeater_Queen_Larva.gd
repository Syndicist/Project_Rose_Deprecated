extends Node2D

onready var host = get_parent().get_parent().get_parent();
onready var timer = get_node("AttackTimer");
var attacking;
var started;
var attack_key_frame = 1;
onready var effect = null;

func _ready():
	started = false;
	attacking = false;
	pass;

func execute(delta):
	if(!started):
		if(host.global_position.x < host.player.global_position.x):
			host.flipped = false;
			host.Direction = 1;
		elif(host.global_position.x > host.player.global_position.x):
			host.flipped = true;
			host.Direction = -1;
		host.changeSprite(host.get_node("Bite_Sprites"),"bite");
		started = true;
	if(!attacking && started && host.get_node("Bite_Sprites").frame == attack_key_frame):
		host.hspd = host.spd*3*host.Direction;
		attacking = true;
		effect = preload("res://Game Objects/Enemies/Bosses/woodeater_queen_larva/woodeater_queen_larva_bite1_effect.tscn").instance();
		host.add_child(effect);
		timer.wait_time = .8;
		timer.start();
	if(attacking && started && host.currentSprite == host.get_node("Bite_Sprites") && host.get_node("Bite_Sprites").frame  == host.get_node("Bite_Sprites").hframes-1):
		host.hspd = 0;
	if(host.currentSprite == host.get_node("Recov_Sprites") && !host.get_node("animator").is_playing()):
		host.actionTimer.wait_time = 1;
		host.actionTimer.start();
		host.state = 'default';
		started = false;
		attacking = false;
	pass;

func _on_AttackTimer_timeout():
	if(attacking):
		effect.queue_free();
		host.hspd = 0;
		host.velocity.x = 0;
		attacking = false;
		effect = null;
		host.changeSprite(host.get_node("Recov_Sprites"),"recov");
	pass;
