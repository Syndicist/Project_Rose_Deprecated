extends StaticBody2D

onready var player = get_tree().get_root().find_node("Rose", true, false);

func _physics_process(delta):
	if(Input.is_action_pressed("ui_down") && (!player.is_on_floor() || Input.is_action_just_pressed("ui_jump"))):
		set_collision_mask_bit(1,false);
	else:
		set_collision_mask_bit(1,true);
	pass