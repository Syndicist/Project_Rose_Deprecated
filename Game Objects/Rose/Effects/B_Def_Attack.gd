extends "res://Game Objects/Rose/Effects/Bash_Effect.gd"

func _ready():
	spd = 300;
	move_player = true;
	pass

func on_area_entered(area):
	var other = .on_area_entered(area);
	if(area.hittable):
		if(other.susceptible == "bash" || other.susceptible == "all"):
			other.hp -= player.damage/4;
	pass