extends StaticBody2D

func _process(delta):
	if(!$animator.is_playing()):
		queue_free();
	pass
