extends "res://Game Objects/Rose/Effects/Slash_Effect.gd"

func _ready():
	spd = 900;
	
	animation.set_length(.15);
	animation.track_insert_key(0,0.14,12);
	$animator.play("attack");
	pass