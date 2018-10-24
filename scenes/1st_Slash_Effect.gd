extends KinematicBody2D

var velocity = Vector2(0,0);

func _physics_process(delta):
	move_and_collide(velocity*delta);
	if(!$animator.is_playing()):
		queue_free();
	pass
