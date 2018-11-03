extends "res://Game Objects/Rose/Slash_Effect.gd"

func _ready():
	spd = 1050;
	
	animation.track_insert_key(0,0.19,12);
	$animator.play("attack");
	pass