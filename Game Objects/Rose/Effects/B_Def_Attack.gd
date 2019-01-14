extends "res://Game Objects/Rose/Effects/Bash_Effect.gd"

func _ready():
	spd = 300;
	move_player = true;
	pass

func on_area_entered(area):
	var other = .on_area_entered(area);
	if(other != null):
		if(area.hittable):
			if(area.susceptible == "bash" || area.susceptible == "all"):
				other.hp -= player.damage/10;
	pass