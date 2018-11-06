extends Node2D

#parent
onready var host = get_parent().get_parent();
onready var move = get_parent().get_node("Move");

### attack vars ###
enum ATTACK{
slash,
pierce,
bash,
NIL
}
var first_attack;
var second_attack;
var third_attack;
var combo_step;
var interruptable;
var attack_timer;
var interrupt_time;
var offbalance_time;
var cooldown_timer;
var dashing;

func _ready():
	### default attack vars ###
	first_attack = ATTACK.NIL;
	second_attack = ATTACK.NIL;
	third_attack = ATTACK.NIL;
	combo_step = 0;
	interruptable = false;
	attack_timer = 0;
	interrupt_time = 0;
	offbalance_time = 0;
	cooldown_timer = 0;
	dashing = false;
	pass

func _process(delta):
	if(host.state != 'attack'):
		dashing = false;
	pass

################## ATTACK_HANDLING ##################
#Checks for given attack inputs and triggers them 
#sequentially. 
func execute(delta):
	#Attack animations should not ever be interuptable when they're first triggered.
	interruptable = false;
	#finds what attack to do first based on input.
	match(first_attack):
		ATTACK.slash:
			firstSlash();
		ATTACK.pierce:
			firstPierce();
		ATTACK.bash:
			firstBash();
		ATTACK.NIL:
			null;
	#finds what attack to do second based on input.
	match(second_attack):
		ATTACK.slash:
			secondSlash();
		ATTACK.pierce:
			secondPierce();
		ATTACK.bash:
			secondBash();
		ATTACK.NIL:
			null;
	#finds what attack to do third based on input.
	match(third_attack):
		ATTACK.slash:
			thirdSlash();
		ATTACK.pierce:
			thirdPierce();
		ATTACK.bash:
			thirdBash();
		ATTACK.NIL:
			null;
	
	#after 35 ticks, the animation can be cancled to do the next combo or reposition Rose.
	#may need tweaking. Potentially set up a variable that changes based on the attack, so that each attack
	#can have its own interruptable window.
	if(attack_timer <= interrupt_time):
		interruptable = true;
		host.velocity.x = 0;
		dashing = false;
	else:
		interruptable = false;
		if(dashing):
			host.velocity.y = 0;
			#host.fall_spd = 0;
	if(interruptable):
		#reposition Rose.
		#TODO: handle special cases like "jump" to trigger as normal when they are pressed.
		if(Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right") || Input.is_action_just_pressed("ui_jump")):
			combo_step = 0;
		#continue the combo based on input. After so long, Rose falls off balance and is stuck finishing the animation.
		#may need tweaking. Potentially set up a variable that changes based on the attack, so that each attack
		#can have its own interruptable window.
		#TODO: pierce and bash attacks
		elif(combo_step == 2 && attack_timer > offbalance_time):
			if(Input.is_action_just_pressed("ui_slash")):
				second_attack = ATTACK.slash;
				attack_timer = 75;
		elif(combo_step == 3 && attack_timer > offbalance_time):
			if(Input.is_action_just_pressed("ui_slash")):
				third_attack = ATTACK.slash;
				attack_timer = 60;
	
	#the combo is finished
	if(attack_timer <= 0):
		combo_step = 0;
	if(combo_step == 0):
		first_attack = ATTACK.NIL;
		second_attack = ATTACK.NIL;
		third_attack = ATTACK.NIL;
		host.currentSprite.visible = false;
		host.state = 'move';
		cooldown_timer = 15;
	pass




### COMBOS AND ATTACKS ###
#TODO: Finish all combos (art, animations and code)

### SLASH attacks ###
#initializes and plays the given effect
func makeSlashEffect(effect):
	host.position.y = host.position.y - 5;
	effect.position = host.position;
	if(host.Direction == "left"):
		effect.scale.x = effect.scale.x * -1;
	host.get_parent().add_child(effect);
	pass
	
func firstSlash():
	host.changeSprite("FirstSlashSprites","1stSlash");
	if(host.anim == "1stSlash" && host.get_node('FirstSlashSprites').frame == 2 && combo_step == 1):
		var effect = preload("res://Game Objects/Rose/1st_Slash_Effect.tscn").instance();
		makeSlashEffect(effect);
		combo_step += 1;
		interrupt_time = 35;
		offbalance_time = 15;
		dashing = true;
	pass
func secondSlash():
	match(first_attack):
		#The slash attack that happens when the first attack is a slash
		ATTACK.slash:
			host.changeSprite("SecondSlashSpritesXXX","2ndSlashXXX");
			if(host.anim == "2ndSlashXXX" && host.get_node('SecondSlashSpritesXXX').frame == 2 && combo_step == 2):
				var effect = preload("res://Game Objects/Rose/2nd_Slash_Effect_XXX.tscn").instance();
				makeSlashEffect(effect);
				combo_step += 1;
				interrupt_time = 35;
				offbalance_time = 15
				dashing = true;
		#The slash attack that happens when the first attack is a pierce
		ATTACK.pierce:
			null;
		#The slash attack that happens when the first attack is a bash
		ATTACK.bash:
			null;
		ATTACK.NIL:
			null;
	pass
func thirdSlash():
	#XXX COMBO
	if(first_attack == ATTACK.slash && second_attack == ATTACK.slash):
		host.changeSprite("ThirdSlashSpritesXXX","3rdSlashXXX");
		if(host.anim == "3rdSlashXXX" && host.get_node('ThirdSlashSpritesXXX').frame == 1 && combo_step == 3):
			var effect = preload("res://Game Objects/Rose/3rd_Slash_Effect_XXX.tscn").instance();
			makeSlashEffect(effect);
			combo_step += 1;
			interrupt_time = 35;
			offbalance_time = 15
			dashing = true;
	pass

### PIERCE attacks ###
func makePierceEffect(effect):
	"""
	position.y = position.y - 7;
	effect.position = self.position;
	if(Direction == "left"):
		effect.scale.x = effect.scale.x * -1;
	get_parent().add_child(effect);
	#effect.get_node("animator").play("slash");"""
	pass
#TODO: this thing
#Called until player unlocks true Pierce attacks.
#Does no damage, but pushes enemies back.
func defaultPierce():
	host.changeSprite("DefaultPierceSprites","DefaultPierce");
	if(host.anim == "DefaultPierce" && host.get_node('DefaultPierceSprites').frame == 2):
		var effect = preload("res://Game Objects/Rose/Default_Pierce_Effect.tscn").instance();
		makePierceEffect(effect);
		combo_step = 4;
		interrupt_time = 35
		offbalance_time = 15
		dashing = false;
		#TODO: Make root logic
	pass
#TODO: everything else
func firstPierce():
	pass
func secondPierce():
	pass
func thirdPierce():
	pass

### BASH attacks ###
func makeBashEffect(effect):
	"""
	position.y = position.y - 7;
	effect.position = self.position;
	if(Direction == "left"):
		effect.scale.x = effect.scale.x * -1;
	get_parent().add_child(effect);
	#effect.get_node("animator").play("slash");"""
	pass
#TODO: this thing
#Called until player unlocks true Bash attacks.
#Does no damage, but stuns the first enemy struck.
#Stunned enemies deal no contact damage.
func defaultBash():
	host.changeSprite("DefaultBashSprites","DefaultBash");
	if(host.anim == "DefaultBash" && host.get_node('DefaultBashSprites').frame == 2):
		var effect = preload("res://Game Objects/Rose/Default_Bash_Effect.tscn").instance();
		makeBashEffect(effect);
		combo_step = 4;
		interrupt_time = 35
		offbalance_time = 15
		dashing = false;
		#TODO: Make Knockback logic
	pass
#TODO: everything else
func firstBash():
	pass
func secondBash():
	pass
func thirdBash():
	pass
