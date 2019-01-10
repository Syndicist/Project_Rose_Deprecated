extends "res://Game Objects/actor.gd"

func _process(delta):
	execute(delta);

func _physics_process(delta):
	phys_execute(delta);

func execute(delta):
	pass

func phys_execute(delta):
	pass