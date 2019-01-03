extends StaticBody2D

export(int) var hp = 3;
var tag = "immovable";
var type = "obstacle";
var hittable = false;
export(String, "slash", "bash", "pierce") var susceptible;

func _process(delta):
	if(hp <= 0):
		#TODO: destroy animation
		queue_free();
	pass