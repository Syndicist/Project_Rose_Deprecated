extends Area2D

onready var host = get_parent();

func _ready():
	connect("area_entered", self, "on_area_entered");
	pass

func on_area_entered(area):
	var object = area.get_parent();
	if(object.tag == "enemy" || object.tag == "enemy attack"):
		host.states['hurt'].hurt_timer = 25;
		host.state = 'hurt';
		host.hp -= object.damage;
		if(object.position.x >= host.position.x):
			if(host.Direction != "right"):
				host.scale.x = host.scale.x * -1;
			host.Direction = "right";
		else:
			if(host.Direction != "left"):
				host.scale.x = host.scale.x * -1;
			host.Direction = "left";
	pass
