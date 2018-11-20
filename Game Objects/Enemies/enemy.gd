extends KinematicBody2D

var velocity;
var move_spd;
var spd;
var gravity;
var Direction;
var floor_normal;
var hp;
var damage;
var tag;
var susceptible;

### Enemy ###
func _ready():
	tag = "enemy";
	hp = 1;
	damage = 1;
	velocity = Vector2(0,0);
	move_spd = 50;
	spd = move_spd;
	gravity = 250;
	#1 = right, -1 = left
	Direction = 1;
	floor_normal = Vector2(0,-1);
	susceptible = "slash"
	pass

### Kill ###
func _process(delta):
	if(hp <= 0):
		queue_free();
	pass

### Default Behavior ###
func _physics_process(delta):
	velocity.x = spd;
	velocity.y = gravity;
	
	move_and_slide(velocity,floor_normal);
	
	if(is_on_floor()):
		spd = move_spd * Direction;
	else:
		spd = move_spd * Direction / 3;
	if($forward_cast.is_colliding()):
		if(Direction == 1):
			Direction = -1;
		else:
			Direction = 1;
		scale.x = scale.x * -1;
	pass
