extends Area2D

### ATTACK EFFECT PARENT ###
onready var host = get_parent();
onready var col = get_node("CollisionShape2D");

func _ready():
	$AttackTimer.wait_time = 1.5;
	$AttackTimer.start();
	pass

func _process(delta):
	if($AttackTimer.time_left <= 0):
		queue_free();
	pass