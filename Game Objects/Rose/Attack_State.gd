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
var dashing;
var distance_traversable;
var start;
var aerial_attack
var bash_unlock;
var pierce_unlock;
var defBashed;
var effectMade;
var currentFrame;

func _ready():
	### default attack vars ###
	first_attack = ATTACK.NIL;
	second_attack = ATTACK.NIL;
	third_attack = ATTACK.NIL;
	combo_step = 0;
	dashing = false;
	$InterruptTimer.one_shot = true;
	$CooldownTimer.one_shot = true;
	start = false;
	distance_traversable = 96;
	aerial_attack = false;
	bash_unlock = false;
	pierce_unlock = false;
	defBashed = false;
	effectMade = false;
	currentFrame = 0;
	pass

func _process(delta):
	if(host.state != 'attack'):
		dashing = false;
		first_attack = ATTACK.NIL;
		second_attack = ATTACK.NIL;
		third_attack = ATTACK.NIL;
		start = false;
		currentFrame = 0;
	pass

func _physics_process(delta):
	if(host.on_floor()):
		defBashed = false;
		effectMade = false;
	pass

################## ATTACK_HANDLING ##################
#Checks for given attack inputs and triggers them 
#sequentially. 
func execute(delta):
	#Attack animations should not ever be interuptable when they're first triggered.
	#finds what attack to do first based on input.
	if(!effectMade):
		match(first_attack):
			ATTACK.slash:
				firstSlash();
			ATTACK.pierce:
				firstPierce();
			ATTACK.bash:
				if(bash_unlock):
					firstBash();
				else:
					defaultBash();
			ATTACK.NIL:
				null;
		#finds what attack to do second based on input.
		match(second_attack):
			ATTACK.slash:
				secondSlash();
			ATTACK.pierce:
				secondPierce();
			ATTACK.bash:
				if(bash_unlock):
					secondBash();
				else:
					defaultBash();
			ATTACK.NIL:
				null;
		#finds what attack to do third based on input.
		match(third_attack):
			ATTACK.slash:
				thirdSlash();
			ATTACK.pierce:
				thirdPierce();
			ATTACK.bash:
				if(bash_unlock):
					thirdBash();
				else:
					defaultBash();
			ATTACK.NIL:
				null;
	
	if(!$InterruptTimer.is_stopped()):
		effectMade = false;
		dashing = false;
		#reposition Rose.
		if(Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right") || Input.is_action_just_pressed("ui_jump")):
			combo_step = 0;
			start = false;
		#continue the combo based on input. After so long, Rose falls off balance and is stuck finishing the animation.
		#may need tweaking. Potentially set up a variable that changes based on the attack, so that each attack
		#can have its own interruptable window.
		#TODO: pierce and bash attacks
		elif((Input.is_action_just_pressed("ui_slash") || 
		(Input.is_action_just_pressed("ui_pierce") && pierce_unlock) || 
		Input.is_action_just_pressed("ui_bash")) && 
		combo_step < 4):
			$InterruptTimer.stop();
			start = true;
			if(!host.on_floor()):
				aerial_attack = true;
			if(combo_step == 2):
				if(Input.is_action_just_pressed("ui_slash")):
					second_attack = ATTACK.slash;
				elif(Input.is_action_just_pressed("ui_pierce")):
					second_attack = ATTACK.pierce;
				elif(Input.is_action_just_pressed("ui_bash")):
					second_attack = ATTACK.bash;
			elif(combo_step == 3):
				if(Input.is_action_just_pressed("ui_slash")):
					third_attack = ATTACK.slash;
				elif(Input.is_action_just_pressed("ui_pierce")):
					third_attack = ATTACK.pierce;
				elif(Input.is_action_just_pressed("ui_bash")):
					third_attack = ATTACK.bash;
	
	#the combo is finished
	if(!start && $InterruptTimer.is_stopped()):
		combo_step = 0;
	if(combo_step == 0):
		host.currentSprite.visible = false;
		host.state = 'move';
		$CooldownTimer.wait_time = .35;
		$CooldownTimer.start();
	pass

### COMBOS AND ATTACKS ###
#TODO: Finish all combos (art, animations and code)

func makeEffect(effect):
	effect.position = host.position;
	host.get_parent().add_child(effect);
	host.fspd = host.jspd;
	effectMade = true;
	pass

### SLASH attacks ###
#initializes and plays the given effect
func makeSlashEffect(effect):
	makeEffect(effect);
	dashing = true;
	pass

var charged = false;

#The first attack is a slash
func firstSlash():
	host.changeSprite(host.get_node("Sprites").get_node("XAttackSprites"),"XAttack");
	pass;

#The second attack is a slash
func secondSlash():
	if(!aerial_attack):
		#The particular slash attack that happens depending on the first attack
		match(first_attack):
			ATTACK.slash:
				host.changeSprite(host.get_node("Sprites").get_node("XXAttackSprites"),"XXAttack");
			#TODO
			ATTACK.pierce:
				null;
			#TODO
			ATTACK.bash:
				null;
			ATTACK.NIL:
				null;
	else:
		#TODO: actually make this right
		start = false; #TODO: delete this
		#The particular slash attack that happens when the player is in the air depending on the first attack
		match(first_attack):
			ATTACK.slash:
				null
			ATTACK.pierce:
				null;
			ATTACK.bash:
				null;
			ATTACK.NIL:
				null;
	pass

#The third attack is a slash
func thirdSlash():
	if(!aerial_attack):
		#The particular slash attack that happens depending on the first attack
		#XXX COMBO
		if(first_attack == ATTACK.slash && second_attack == ATTACK.slash):
			host.changeSprite(host.get_node("Sprites").get_node("XXXAttackSprites"),"XXXAttack");
		#BYX COMBO
		if(first_attack == ATTACK.bash && second_attack == ATTACK.pierce):
			null
	else:
		#The particular slash attack that happens when the player is in the air depending on the first attack
		null
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
#TODO: everything else
func firstPierce():
	pass
func secondPierce():
	pass
func thirdPierce():
	pass

### BASH attacks ###
func makeBashEffect(effect):
	makeEffect(effect);
	pass
#Called until player unlocks true Bash attacks.
#Does no damage, but stuns the first enemy struck.
#Stunned enemies deal no contact damage.
func defaultBash():
	host.changeSprite(host.get_node("Sprites").get_node("BDefaultSprites"),"BDefAttack");
	
	pass
#TODO: everything else
func firstBash():
	pass
func secondBash():
	pass
func thirdBash():
	pass


func _frame_changed():
	if(host.state == 'attack'):
		#First Attack In Combo
		match(combo_step):
			1:
				#X
				if(host.anim == "XAttack"):
					if(host.currentSprite.frame == 11 && !charged):
						var effect = preload("res://Game Objects/Rose/Effects/XAttackDash.tscn").instance();
						makeSlashEffect(effect);
						charged = true;
					if(host.currentSprite.frame == 18 && charged):
						var effect = preload("res://Game Objects/Rose/Effects/XAttack.tscn").instance();
						makeSlashEffect(effect);
						charged = false;
						combo_step += 1;
				#B
				if(host.anim == "BDefAttack"):
					if(host.get_node("Sprites").get_node("BDefaultSprites").frame == 2):
						var effect = preload("res://Game Objects/Rose/Effects/BDefAttack.tscn").instance();
						makeBashEffect(effect);
						combo_step = 4;
						defBashed = true;
				pass;
			2:
				#XX
				if(host.anim == "XXAttack"):
					if(host.get_node("Sprites").get_node('XXAttackSprites').frame == 3 && combo_step == 2):
						var effect = preload("res://Game Objects/Rose/Effects/XXAttack.tscn").instance();
						makeSlashEffect(effect);
				pass;
			3:
				if(host.anim == "XXXAttack"):
					if(host.get_node("Sprites").get_node('XXXAttackSprites').frame == 4 && combo_step == 3):
						var effect = preload("res://Game Objects/Rose/Effects/XXXAttack.tscn").instance();
						makeSlashEffect(effect);
				pass;
			_:
				pass;
	pass;
