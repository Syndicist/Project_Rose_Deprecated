extends Area2D

var sight;

onready var host = get_parent();

func _ready():
	connect("area_entered", self, "on_area_entered");
	connect("area_exited", self, "on_area_exited");
	pass

func on_area_entered(area):
	print("CHASE");
	if(host.state == 'attack'):
		return;
	var other = area.get_parent();
	if(other.tag == "player"):
		host.target = other;
		host.state = 'chase';
	pass

func on_area_exited(area):
	print("STOP CHASING");
	if(host.state == 'attack'):
		return;
	var other = area.get_parent();
	if(other.tag == "player"):
		host.target = null;
		host.state = 'default';
	pass