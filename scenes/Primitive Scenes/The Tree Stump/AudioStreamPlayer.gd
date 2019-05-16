extends AudioStreamPlayer

func _process(delta):
	pass;

func _on_AudioStreamPlayer_finished():
	play();
	pass
