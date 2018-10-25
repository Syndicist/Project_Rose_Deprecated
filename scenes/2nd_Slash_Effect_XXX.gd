extends KinematicBody2D

var spd = 500;
var velocity = Vector2(spd,0);

func _physics_process(delta):
	var player = get_parent().get_node("Rose");
	if(player.Direction == "left" && player.combo_step == 3):
		velocity.x = -spd;
	move_and_collide(velocity*delta);
	if(!$animator.is_playing()):
		queue_free();
	pass
