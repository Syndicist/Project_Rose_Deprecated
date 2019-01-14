extends "res://Game Objects/Rose/Effects/Slash_Effect.gd"

func _ready():
	spd = 300;
	move_player = false;
	pass

func on_area_entered(area):
	var other = .on_area_entered(area);
	if(other != null):
		if(area.hittable):
			if(area.susceptible == "slash" || area.susceptible == "all"):
				other.hp -= player.damage/2;
	pass