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
var spd = 0;
var displacement = 0;
onready var pos = player.position;
var booped = false;
var type = "bash";

func _process(delta):
	if(player.state != 'attack'):
		queue_free();
	pass;

func on_area_entered(area):
	if(!(.on_area_entered(area))):
		return null;
	var other = area.get_parent();
	if(area.hittable):
		if(area.vulnerable == "bash" || area.vulnerable == "all" ):
			other.stun_damage += player.damage;
			if(other.off_bal):
				other.stun_damage += player.damage;
			null
	return other;

func on_body_entered(body):
	if(!booped && move_player):
		player.vspd = -spd;
		player.fspd = 0;
		$Sprite.visible = true;
		booped = true;
	pass;