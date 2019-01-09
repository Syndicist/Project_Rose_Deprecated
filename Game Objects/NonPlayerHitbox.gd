extends Area2D

var hittable = false;
export(String, "slash", "bash", "pierce", "all", "none") var susceptible;
export(String, "slash", "bash", "pierce", "all", "none") var vulnerable;

var hit1 = null;
var hit2 = null;
var hit3 = null;
var hits = [hit1, hit2, hit3];
var hitIndex = 0;

func set_hit(area):
	hitIndex += 1;
	if(hitIndex >=3):
		hitIndex = 0;
	hits[hitIndex] = area;