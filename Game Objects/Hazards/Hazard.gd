extends Area2D

onready var host = get_parent();

func _ready():
	connect("area_entered", self, "on_area_entered");
	pass

func on_area_entered(area):
	#if(("sight" in area)):
	#	return;
	var object = area.get_parent();

	if(object.tag == "enemy"):
		object.Kill();
	pass
