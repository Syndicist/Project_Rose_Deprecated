extends KinematicBody2D

var susceptible = 'slash';
var hp = 0;
var tag = "interactable";
var type = "blowable";
var velocity = Vector2(0,0);
var normal = Vector2(0,-1);
var slowdown = 5;

func _physics_process(delta):
	if(velocity.x > 0):
		velocity.x -= slowdown;
	if(velocity.x < 0):
		velocity.x += slowdown;
	move_and_slide(velocity,normal);
	pass