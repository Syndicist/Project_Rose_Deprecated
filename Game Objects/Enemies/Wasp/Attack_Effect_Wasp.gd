extends Area2D

### ATTACK EFFECT PARENT ###
onready var host = get_parent();
onready var col = get_node("CollisionShape2D");
onready var spr  = get_node("Sprite");

func _ready():
	$AttackTimer.wait_time = 1.5;
	$AttackTimer.start();
	pass

func _process(delta):
	if($AttackTimer.time_left <= .5):
		spr.visible = false;
	if($AttackTimer.time_left <= 0):
		queue_free();
	if(spr.frame < spr.hframes - 1):
		spr.frame = host.get_node("Attack_Sprites").frame;
	pass