extends KinematicBody2D

var velocity;
var move_spd;
var spd;
var gravity;
var Direction;
var floor_normal;
var air_time;
var on_wall;

func _ready():
	velocity = Vector2(0,0);
	move_spd = 100;
	spd = move_spd;
	gravity = 250;
	Direction = "right";
	floor_normal = Vector2(0,-1);
	air_time = 0;
	on_wall = false;
	pass

func _physics_process(delta):
	
	velocity.x = spd;
	velocity.y = gravity;
	
	move_and_slide(velocity,floor_normal);
	if(is_on_floor()):
		if(Direction == "right"):
			spd = move_spd;
		else:
			spd = -move_spd;
	else:
		spd = move_spd / 3;
	if($forward_cast.is_colliding()):
		if(Direction == "right"):
			Direction = "left";
		else:
			Direction = "right";
		scale.x = scale.x * -1;
	pass
