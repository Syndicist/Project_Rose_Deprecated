extends Area2D

### ATTACK EFFECT PARENT ###
var damagedThis = false;
onready var player = get_parent().get_node("Rose");

var animation;

func _enter_tree():
	#initializes collision handling
	connect("body_entered", self, "on_body_entered");
	
	#automatically generates animation based on a sprite.
	#still have to manually finish the code in the specific attack script.
	animation = Animation.new();
	animation.set_length(.2);
	
	animation.add_track(Animation.TYPE_VALUE);
	animation.track_set_path(0, "Sprite:frame");
	animation.track_insert_key(0,0,0);
	animation.value_track_set_update_mode(0,0);
	animation.track_set_interpolation_type(0,1);
	$animator.add_animation("attack", animation);
	pass