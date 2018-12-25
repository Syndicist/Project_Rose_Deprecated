extends Node2D

### player vars ###
var hp;
var max_hp;
var damage;

func ready():
	max_hp = 5;
	hp = max_hp;
	damage = 1;
	pass