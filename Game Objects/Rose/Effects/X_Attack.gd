extends "res://Game Objects/Rose/Effects/Slash_Effect.gd"

func _ready():
	spd = 300;
	move_player = false;
	pass

func _process(delta):
	if(player.currentSprite.frame >= 21):
		attackstate.start = false;
		attackstate.get_node("InterruptTimer").wait_time = .5;
		attackstate.get_node("InterruptTimer").start();
		queue_free();
	pass

func on_area_entered(area):
	var other = .on_area_entered(area);
	if(area.hittable):
		if(other.susceptible == "slash" || other.susceptible == "all"):
			other.hp -= player.damage/2;
	pass