extends AudioStreamPlayer

func _process(delta):
	print(Engine.get_frames_per_second());
	pass;

func _on_AudioStreamPlayer_finished():
	play();
	pass
