extends RayCast2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _draw():
	draw_line(position,cast_to,Color(1,1,1));
	pass