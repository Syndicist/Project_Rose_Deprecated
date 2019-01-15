extends Node2D


func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/Final Scenes/Forest_Finished.tscn")
	pass;


func _on_AudioStreamPlayer_finished():
	play();
	pass;
