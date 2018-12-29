extends "res://Game Objects/Rose/State.gd"

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
var distance_traversable;
var effect

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
	distance_traversable = 96;
	effect = null;
	pass

func _process(delta):
	if(host.state != 'attack'):
		dashing = false;
		first_attack = ATTACK.NIL;
		second_attack = ATTACK.NIL;
		third_attack = ATTACK.NIL;
	pass

func _physics_process(delta):
	attack_timer -= 1;
	cooldown_timer -= 1;
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
	else:
		interruptable = false;
	if(interruptable):
		if(effect != null):
			effect.queue_free();
			effect = null;
		#reposition Rose.
		if(!host.on_floor()):
			combo_step = 0;
		elif(Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right") || Input.is_action_just_pressed("ui_jump")):
			combo_step = 0;
		#continue the combo based on input. After so long, Rose falls off balance and is stuck finishing the animation.
		#may need tweaking. Potentially set up a variable that changes based on the attack, so that each attack
		#can have its own interruptable window.
		#TODO: pierce and bash attacks
		elif(combo_step == 2):
			if(Input.is_action_just_pressed("ui_slash")):
				second_attack = ATTACK.slash;
				attack_timer = 75;
			#elif(Input.is_action_just_pressed("ui_pierce")):
			#	second_attack = Attack.pierce;
		elif(combo_step == 3):
			if(Input.is_action_just_pressed("ui_slash")):
				third_attack = ATTACK.slash;
				attack_timer = 60;
	
	#the combo is finished
	if(attack_timer <= 0):
		combo_step = 0;
	if(combo_step == 0):
		host.currentSprite.visible = false;
		host.state = 'move';
		cooldown_timer = 15;
	pass




### COMBOS AND ATTACKS ###
#TODO: Finish all combos (art, animations and code)

### SLASH attacks ###
#initializes and plays the given effect
func makeSlashEffect():
	effect.position = host.position;
	effect.scale.x = effect.scale.x * host.Direction;
	host.get_parent().add_child(effect);
	host.fall_spd = host.jump_spd;
	pass
	
func firstSlash():
	host.changeSprite(host.get_node("X Attacks").get_node("XAttackSprites"),"XAttack");
	if(host.anim == "XAttack" && host.get_node("X Attacks").get_node('XAttackSprites').frame == 3 && combo_step == 1):
		effect = preload("res://Game Objects/Rose/Effects/XAttack.tscn").instance();
		makeSlashEffect();
		combo_step += 1;
		interrupt_time = 35;
		dashing = true;
	pass
func secondSlash():
	match(first_attack):
		#The slash attack that happens when the first attack is a slash
		ATTACK.slash:
			host.changeSprite(host.get_node("X Attacks").get_node("XXAttackSprites"),"XXAttack");
			if(host.anim == "XXAttack" && host.get_node("X Attacks").get_node('XXAttackSprites').frame == 3 && combo_step == 2):
				effect = preload("res://Game Objects/Rose/Effects/XXAttack.tscn").instance();
				makeSlashEffect();
				combo_step += 1;
				interrupt_time = 35;
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
		host.changeSprite(host.get_node("X Attacks").get_node("XXXAttackSprites"),"XXXAttack");
		if(host.anim == "XXXAttack" && host.get_node("X Attacks").get_node('XXXAttackSprites').frame == 4 && combo_step == 3):
			effect = preload("res://Game Objects/Rose/Effects/XXXAttack.tscn").instance();
			makeSlashEffect();
			combo_step += 1;
			interrupt_time = 35;
			offbalance_time = 15
			dashing = true;
	#BYX COMBO
	if(first_attack == ATTACK.bash && second_attack == ATTACK.pierce):
		null
		#TODO: make this combo
	pass

### PIERCE attacks ###
func makePierceEffect(effect):
	"""
	position.y = position.y - 7;
	effect.position = self.position;
	effect.scale.x = effect.scale.x * Direction;
	get_parent().add_child(effect);
	#effect.get_node("animator").play("slash");"""
	pass
#TODO: this thing
#Called until player unlocks true Pierce attacks.
#Does no damage, but pushes enemies back.
func defaultPierce():
	host.changeSprite("DefaultPierceSprites","DefaultPierce");
	if(host.anim == "DefaultPierce" && host.get_node('DefaultPierceSprites').frame == 4):
		effect = preload("res://Game Objects/Rose/Effects/Default_Pierce_Effect.tscn").instance();
		makePierceEffect();
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
	effect.scale.x = effect.scale.x * Direction;
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
		effect = ("res://Game Objects/Rose/Effects/Default_Bash_Effect.tscn").instance();
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
