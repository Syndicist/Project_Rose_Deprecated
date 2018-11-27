extends Node

onready var host = get_parent().get_parent();
onready var attack = get_parent().get_node("Attack");
onready var move = get_parent().get_node("Move");
onready var hurt = get_parent().get_node("Hurt");

func enter():
	pass

func handleInput(event):
	pass

func update(delta):
	pass

func exit(state):
	pass