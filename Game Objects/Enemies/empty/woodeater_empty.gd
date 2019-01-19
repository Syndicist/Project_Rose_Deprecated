extends KinematicBody2D

var irand;

func _ready():
	$animator.play("move");
	$ActionTimer.wait_time = rand_range(.5,2);
	$ActionTimer.start();
	pass

func _process(delta):
	
	pass;


func _on_ActionTimer_timeout():
	$ActionTimer.wait_time = rand_range(.5,2);
	$ActionTimer.start();
	$Move_Sprites.visible = false;
	$Attack_Sprites.visible = true;
	$animator.play("attack");
	pass;


func _on_animator_animation_finished(anim_name):
	if(anim_name == "attack"):
		$Move_Sprites.visible = true;
		$Attack_Sprites.visible = false;
		$animator.play("move");
	pass;
