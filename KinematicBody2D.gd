extends KinematicBody2D

func _ready():
	velocity = Vector2(0,0);
	pass

func _process(delta):
	$KinematicBody2D.move_and_slide(velocity);
	if(!$KinematicBody2D/AnimationPlayer.is_playing()):
		queue_free();
	pass
