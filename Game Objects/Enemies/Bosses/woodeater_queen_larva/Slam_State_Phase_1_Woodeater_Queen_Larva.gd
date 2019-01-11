extends Node2D

onready var host = get_parent().get_parent().get_parent();
onready var timer = get_node("AttackTimer");
onready var pos = host.position;
onready var effect = null;
var peaked;
var displacementy;
var falling;
var started;
var over;
var attack_key_frame;
var impact;
var rising;
var recov;
var in_air

func _ready():
	peaked = false;
	displacementy = 0;
	falling = false;
	started = false;
	peaked = false;
	over = false;
	rising = false;
	attack_key_frame = 1;
	impact = false;
	recov = false;
	in_air = false;
	pass;

func execute(delta):
	#jump
	if(!started):
		host.get_node("animator").playback_speed = 1;
		host.changeSprite(host.get_node("Jump_Sprites"),"jump");
		started = true;
		if(host.player.global_position.x > host.global_position.x):
			host.flipped = false;
			host.Direction = 1;
		elif(host.player.global_position.x < host.global_position.x):
			host.flipped = true;
			host.Direction = -1;
	if(started && host.currentSprite == host.get_node("Jump_Sprites") && !host.get_node("animator").is_playing()):
		rising = true;
	#move up to slam
	if(rising && !falling):
		host.changeSprite(host.get_node("Rise_Sprites"),"rise");
		#peaked?
		if(host.position.y > pos.y):
			displacementy += host.position.y - pos.y;
			pos.y = host.position.y;
		elif(host.position.y < pos.y):
			displacementy += pos.y - host.position.y;
			pos.y = host.position.y;
		if(abs(displacementy) >= 250):
			peaked = true;
		
		#over player?
		if(host.global_position.x >= host.player.global_position.x - 5 && host.global_position.x <= host.player.global_position.x + 5):
			over = true;
		
		if(!peaked):
			host.vspd = -host.spd*10;
		else:
			host.vspd = 0;
		if(!over):
			host.hspd = host.spd*3*host.Direction;
		else:
			host.hspd = 0;
		if(peaked && over):
			
			in_air = true;
			rising = false;
	#hold in air for a bit
	if(in_air && timer.is_stopped()):
		host.changeSprite(host.get_node("Air_Sprites"),"in_air");
		timer.wait_time = .5;
		timer.start();
		in_air = false;
	#slam
	if(falling && !impact):
		host.changeSprite(host.get_node("Fall_Sprites"),"fall");
		host.vspd = host.spd*30; 
		if(host.is_on_floor()):
			impact = true;
			host.vspd = 0;
			falling = false;
	#shockwave
	if(impact):
		host.changeSprite(host.get_node("Shock_Sprites"),"shock");
		impact = false;
	elif(host.currentSprite == host.get_node("Shock_Sprites") && !host.get_node("animator").is_playing()):
		recov = true;
	#recovery
	if(recov):
		host.changeSprite(host.get_node("Recov_Sprites"),"recov");
		recov = false;
	elif(host.currentSprite == host.get_node("Recov_Sprites") && !host.get_node("animator").is_playing()):
		host.state = 'default';
		peaked = false;
		displacementy = 0;
		falling = false;
		started = false;
		peaked = false;
		over = false;
		rising = false;
		attack_key_frame = 1;
		impact = false;
		recov = false;
		in_air = false;
		pos = host.position;
	
	pass;

func _on_AttackTimer_timeout():
	falling = true;
	pass;
