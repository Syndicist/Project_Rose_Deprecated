extends "res://Game Objects/Rose/Slash_Effect.gd"

func _ready():
	spd = 600;
	
	animation.track_insert_key(0,0.19,10);
	$animator.play("attack");
	pass