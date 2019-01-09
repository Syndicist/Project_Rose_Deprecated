extends "res://Game Objects/Rose/Effects/Slash_Effect.gd"

func _ready():
	spd = 600;
	move_player = true;
	pass

func _process(delta):
	if(player.currentSprite.frame >= 17):
		queue_free();
	pass

func on_area_entered(area):
	var other = .on_area_entered(area);
	print(area.hittable);
	if(other != null):
		if(area.hittable):
			if(area.susceptible == "slash" || area.susceptible == "all"):
				other.hp -= player.damage/4;
	pass