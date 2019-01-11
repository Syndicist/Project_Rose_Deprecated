extends Area2D

onready var host = get_parent();
onready var attack = get_parent().get_node("States").get_node("Attack");
func _ready():
	connect("area_entered", self, "on_area_entered");
	pass

func on_area_entered(area):
	var other = area.get_parent();
	if(attack.dashing && area.get_collision_layer_bit(14)):
		return;
	if(host.state != 'hurt'):
		host.velocity.x = 0;
		host.velocity.y = 0;
		host.states['hurt'].hurt_timer = 7;
		host.state = 'hurt';
		host.hp -= other.damage;
		if(other.global_position.x >= host.global_position.x):
			if(host.Direction != 1):
				host.scale.x = host.scale.x * -1;
			host.Direction = 1;
		else:
			if(host.Direction != -1):
				host.scale.x = host.scale.x * -1;
			host.Direction = -1;
	pass
