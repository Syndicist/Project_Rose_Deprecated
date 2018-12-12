extends Node2D

#node references
onready var host = get_parent().get_parent();
onready var attack = get_parent().get_node("Attack");
onready var move = get_parent().get_node("Move");
onready var hurt = get_parent().get_node("Hurt");