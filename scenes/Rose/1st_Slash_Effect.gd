extends KinematicBody2D

var spd = 600;
var in_spd = spd;
var velocity = Vector2(spd,0);
var damagedThis = false;
onready var player = get_parent().get_node("Rose");

func _physics_process(delta):
	if(player.on_wall):
		spd = 0;
		velocity.x = 0;
	elif(!player.on_wall):
		spd = in_spd;
		if(player.Direction == "left"):
			velocity.x = -spd;
			player.velocity.x = -spd;
		else:
			velocity.x = spd;
			player.velocity.x = spd;
	
	var collision_event = move_and_collide(velocity*delta);
	if(collision_event):
		handle(collision_event.collider);
		
	if(!$animator.is_playing()):
		player.velocity.x = 0;
		queue_free();
	pass

func handle(object):
	object.add_collision_exception_with(self);
	print(object.hp);
	if(!damagedThis):
		object.hp -= 1;
		damagedThis = true;
	self.position = player.position;
	object.remove_collision_exception_with(self);
	pass
