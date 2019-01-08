extends Node2D

var skin;
var skin_prev;

func _ready():
	skin = "Rose_Cute_Skin/";
	skin_prev = skin;
	pass;

func _process(delta):
	if(Input.is_action_just_pressed("ui_page_up")):
		if(skin == "Rose_Serious_Skin/"):
			skin = "Rose_Cute_Skin/";
		else:
			skin = "Rose_Serious_Skin/";
	if(skin != skin_prev):
		match(skin):
			"Rose_Serious_Skin/":
				$StillSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Serious_Skin/Rose_Idle.png"));
				$RunSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Serious_Skin/Rose_Run.png"));
				$JumpSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Serious_Skin/Rose_Jump.png"));
				$FallSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Serious_Skin/Rose_Fall.png"));
				#TODO: hurt
				$JumpToFallSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Serious_Skin/Rose_Jump_To_Fall.png"));
				$XAttackSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Serious_Skin/Rose_X_Attack.png"));
				$XXAttackSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Serious_Skin/Rose_XX_Attack.png"));
				$XXXAttackSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Serious_Skin/Rose_XXX_Attack.png"));
				$BDefaultSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Serious_Skin/Rose_B_Def_Attack.png"));
			"Rose_Cute_Skin/":
				$StillSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Cute_Skin/Rose_Idle.png"));
				$RunSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Cute_Skin/Rose_Run.png"));
				$JumpSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Cute_Skin/Rose_Jump.png"));
				$FallSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Cute_Skin/Rose_Fall.png"));
				#TODO: hurt
				$JumpToFallSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Cute_Skin/Rose_Jump_To_Fall.png"));
				$XAttackSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Cute_Skin/Rose_X_Attack.png"));
				$XXAttackSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Cute_Skin/Rose_XX_Attack.png"));
				$XXXAttackSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Cute_Skin/Rose_XXX_Attack.png"));
				$BDefaultSprites.set_texture(preload("res://sprites/Rose Sprites/Rose_Cute_Skin/Rose_B_Def_Attack.png"));
		skin_prev = skin;
	pass
