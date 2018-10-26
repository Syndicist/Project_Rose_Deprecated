extends KinematicBody2D

var spd = 500;
var velocity = Vector2(spd,0);

func _physics_process(delta):
	var player = get_parent().get_node("Rose");
	if(player.on_wall):
		spd = 0;
		velocity.x = 0;
	elif(!player.on_wall):
		if(player.Direction == "left" && player.combo_step == 2):
			velocity.x = -spd;
		move_and_collide(velocity*delta);
	
	if(!$animator.is_playing()):
		queue_free();
	pass
