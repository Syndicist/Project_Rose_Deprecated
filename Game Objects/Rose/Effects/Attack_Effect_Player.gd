 extends Area2D

### ATTACK EFFECT PARENT ###
onready var player = get_parent().get_node("Rose");
onready var attackstate = player.get_node("States").get_node("Attack");

var Direction = 1;

func _enter_tree():
	#initializes collision handling
	connect("area_entered", self, "on_area_entered");
	connect("body_entered", self, "on_body_entered");
	pass

func _process(delta):
	position = player.position;
	if(Direction != player.Direction):
		scale.x = scale.x * -1;
		Direction = player.Direction;
	pass

func _physics_process(delta):
	if(player.currentSprite.frame >= player.currentSprite.hframes-1):
		attackstate.start = false;
		attackstate.get_node("InterruptTimer").wait_time = .5;
		attackstate.get_node("InterruptTimer").start();
		queue_free();

func on_area_entered(area):
	pass;

func on_body_entered(body):
	pass;