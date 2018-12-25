extends Node2D


onready var host = get_parent().get_parent();
var started;
var attacking;
var charge_key_frame = 3;
onready var effect = null;

func _ready():
	started = false;
	attacking = false;
	pass

func execute(delta):
	if(!started):
		started = true;
		host.changeSprite(host.get_node("Attack_Sprites"),"attack");
		host.get_node("animator").playback_speed = .5
		effect = preload("res://Game Objects/Enemies/Woodeater/WoodeaterAttackEffect.tscn").instance();
		host.add_child(effect);
	if(started && !attacking && host.get_node("Attack_Sprites").frame == charge_key_frame):
		host.hspd = 3 * host.spd * host.Direction;
		attacking = true;
		host.get_node("animator").playback_speed = 1;
		host.vspd -= host.jspd;
		effect.col.disabled = false;
	if(started && attacking && (host.get_node("Attack_Sprites").frame == host.get_node("Attack_Sprites").hframes-1) && host.is_on_floor()):
		effect.queue_free();
		if(host.target != null):
			host.state = 'chase';
		else:
			host.state = 'default';
		host.hspd = 0;
		host.velocity.x = 0;
		started = false;
		attacking = false;
		effect = null;
	pass