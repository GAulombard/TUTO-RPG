extends KinematicBody2D

var curHP = 10
var maxHP = 10
var moveSpeed = 250
var damage = 1

var gold = 0
var curLevel = 0
var curXP = 0
var xpToNextLevel = 50
var xpToLevelIncreaseRate = 1.2

var interactDist = 70
var vel = Vector2()
var facingDir = Vector2()

onready var rayCast  = $RayCast2D
onready var anim = $AnimatedSprite
onready var ui = get_node("/root/MainScene/CanvasLayer/GUI")

func _physics_process(delta):
	
	vel = Vector2()
	
	if Input.is_action_pressed("move_up"):
		vel.y -= 1
		facingDir = Vector2(0, -1)
	if Input.is_action_pressed("move_down"):
		vel.y += 1
		facingDir = Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		vel.x -= 1
		facingDir = Vector2(-1, 0)
	if Input.is_action_pressed("move_right"):
		vel.x += 1
		facingDir = Vector2(1, 0)
	vel = vel.normalized() #normalized to prevent faster  diagonal movement
	move_and_slide(vel * moveSpeed, Vector2.ZERO)
	manage_animation()

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		try_interact()

# Called when the node enters the scene tree for the first time.
func _ready():
	ui.update_level_text(curLevel)
	ui.update_health_bar(curHP,maxHP)
	ui.update_xp_bar(curXP,xpToNextLevel)
	ui.update_gold_text(gold)

func play_animation(anim_name):
	if anim.animation != anim_name:
		anim.play(anim_name)

func manage_animation():
	if vel.x > 0:
		play_animation("moveRight")
	elif vel.x < 0:
		play_animation("moveLeft")
	elif vel.y < 0:
		play_animation("moveUp")
	elif vel.y > 0:
		play_animation("moveDown")
	elif facingDir.x == 1:
		play_animation("idleRight")
	elif facingDir.x == -1:
		play_animation("idleLeft")
	elif facingDir.y == 1:
		play_animation("idleDown")
	elif facingDir.y == -1:
		play_animation("idleUp")

func give_gold(amount):
	gold += amount
	ui.update_gold_text(gold)
	
func give_xp(amount):
	curXP += amount
	if curXP >= xpToNextLevel:
		level_up()
	ui.update_xp_bar(curXP,xpToNextLevel)

func level_up():
	
	var overFlowXP = curXP - xpToNextLevel
	
	xpToNextLevel *= xpToLevelIncreaseRate
	curXP = overFlowXP
	curLevel += 1
	ui.update_xp_bar(curXP,xpToNextLevel)
	ui.update_level_text(curLevel)

func take_damage(dmgToTake):
	curHP -= dmgToTake
	if curHP <= 0:
		die()
	ui.update_health_bar(curHP,maxHP)

func die():
	get_tree().reload_current_scene()

func try_interact():
	
	rayCast.cast_to = facingDir *interactDist
	
	if rayCast.is_colliding():
		if rayCast.get_collider() is KinematicBody2D:
			rayCast.get_collider().take_damage(damage)
		elif rayCast.get_collider().has_method("on_interact"):
			rayCast.get_collider().on_interact(self)























