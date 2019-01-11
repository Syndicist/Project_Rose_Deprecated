extends "res://Game Objects/Enemies/enemy.gd"

func _ready():
	states = {
	'default' : $States/Default,
	'attack' : $States/Attack,
	'chase' : $States/Chase,
	'defstun' : $States/DefaultStun
	}
	pass;
