extends Area2D

onready var host = get_parent();

func _ready():
	connect("area_entered", self, "on_area_entered");
	pass

func on_area_entered(area):
	if(("sight" in area)):
		return;
	var object = area.get_parent();
	print("!!!");
	if(host.state != 'hurt'):
		host.velocity.x = 0;
		host.velocity.y = 0;
		host.states['hurt'].hurt_timer = 7;
		host.state = 'hurt';
		host.hp -= object.damage;
		if(object.position.x >= host.position.x):
			if(host.Direction != 1):
				host.scale.x = host.scale.x * -1;
			host.Direction = 1;
		else:
			if(host.Direction != -1):
				host.scale.x = host.scale.x * -1;
			host.Direction = -1;
	pass
