extends Area2D

onready var host = get_parent();

func _ready():
	connect("area_entered", self, "on_area_entered");
	pass

func on_area_entered(area):
	var object = area.get_parent();
	if(object.tag == "enemy" || object.tag == "enemy attack" && host.state != 'hurt'):
		host.states['move'].velocity.x = 0;
		host.states['move'].velocity.y = 0;
		host.states['hurt'].hurt_timer = 25;
		host.state = 'hurt';
		host.hp -= object.damage;
		if(object.position.x >= host.position.x):
			if(host.states['move'].Direction != 1):
				host.scale.x = host.scale.x * -1;
			host.states['move'].Direction = 1;
		else:
			if(host.states['move'].Direction != -1):
				host.scale.x = host.scale.x * -1;
			host.states['move'].Direction = -1;
	pass
