extends StaticBody2D

var hp = 3;
var tag = "immovable";
var type = "obstacle";

func _process(delta):
	if(hp <= 0):
		#TODO: destroy animation
		queue_free();
	pass