extends "res://Game Objects/Rose/Attack_Effect.gd"


### SLASH ATTACK TEMPLATE ###
#need to initialize spd here because the engine reads this area BEFORE _ready
#AND the code in the rest of the current frame's code, but reads _ready AFTER 
#the rest of the current frame's code.
#This means _ready can't solely be used even if called here or by a higher-level
#script. But, without spd initialized at all, _process has no spd to reference.
#this makes virtually no difference, since spd is re-initialized in each higher-
#level script's _ready function anyways. This is just needed for the code to run
#at all.
var spd = 600;
var ispd = spd;

func _process(delta):
	self.position = player.position;
	
	if(player.on_wall):
		player.velocity.x = 0;
	elif(!player.on_wall):
		player.velocity.x = spd * player.Direction;
	
	if(player.state != 'attack'):
		queue_free();
	
	if(!$animator.is_playing()):
		player.velocity.x = 0;
		queue_free();
	pass

func on_area_entered(area):
	var object = area.get_parent();
	if(object.tag == "interactable"):
		if(object.type == "blowable"):
			object.velocity.x = 200 * player.Direction;
			
	elif(object.susceptible == "slash"):
		if(!damagedThis):
			object.hp -= 1;
			damagedThis = true;
	#Bounce off object
	else:
		spd = spd * -1;
	pass

func on_body_entered(object):
	#Bounce off object
	if(object.susceptible == "none"):
		spd = spd * -1;
	pass