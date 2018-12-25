extends "res://Game Objects/Rose/Effects/Slash_Effect.gd"

func _ready():
	spd = -600;
	
	animation.set_length(.12);
	animation.track_insert_key(0,0.5,2);
	$animator.play("attack");
	pass