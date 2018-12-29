 extends Area2D

### ATTACK EFFECT PARENT ###
var damagedThis = false;
onready var player = get_parent().get_node("Rose");
onready var attackstate = player.get_node("States").get_node("Attack");

func _enter_tree():
	#initializes collision handling
	connect("area_entered", self, "on_area_entered");
	
	pass