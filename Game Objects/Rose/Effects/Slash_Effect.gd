extends "res://Game Objects/Rose/Effects/Attack_Effect_Player.gd"


### SLASH ATTACK TEMPLATE ###
#need to initialize spd here because the engine reads this area BEFORE _ready
#AND the code in the rest of the current frame's code, but reads _ready AFTER 
#the rest of the current frame's code.
#This means _ready can't solely be used even if called here or by a higher-level
#script. But, without spd initialized at all, _process has no spd to reference.
#this makes virtually no difference, since spd is re-initialized in each higher-
#level script's _ready function anyways. This is just needed for the code to run
#at all.
var spd = 1200;
var displacement = 0;
onready var pos = player.position;
var type = "slash";

func _process(delta):
	self.position = player.position;
	if(player.position.x > pos.x):
		displacement += player.position.x - pos.x;
		pos.x = player.position.x;
	elif(player.position.x < pos.x):
		displacement += pos.x - player.position.x;
		pos.x = player.position.x;
	if(abs(displacement) > attackstate.distance_traversable):
		spd = 0;
		attackstate.dashing = false;
	
	
	player.velocity.x = spd * player.Direction;
	
	if(player.state != 'attack'):
		queue_free();
	pass

func on_area_entered(area):
	var other = area.get_parent();
	if(!("hittable" in area)):
		if(other.tag == "movable"):
			if(other.type == "blowable"):
				other.velocity.x = 200 * player.Direction;
	elif(area.hittable):
		if(other.susceptible == "slash" || other.susceptible == "all"):
			other.hp -= 1;
	pass