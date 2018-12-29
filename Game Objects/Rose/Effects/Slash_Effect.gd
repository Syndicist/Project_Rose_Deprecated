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
var ispd = spd;
var bounced = false;
var displacement = 0;
onready var pos = player.position;

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
	
	
	if(player.is_on_wall()):
		player.velocity.x = 0;
	elif(!player.is_on_wall()):
		player.velocity.x = spd * player.Direction;
	
	if(player.state != 'attack'):
		queue_free();
	pass

func on_area_entered(area):
	var object = area.get_parent();
	if(object.tag == "movable"):
		if(object.type == "blowable"):
			object.velocity.x = 200 * player.Direction;
	
	elif(object.susceptible == "slash"):
		print("!!!");
		if(!damagedThis):
			object.hp -= 1;
			damagedThis = true;
	pass