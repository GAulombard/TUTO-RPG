extends Control

onready var LevelText  = get_node("BG/LevelBG/LevelText")
onready var healthBar = get_node("BG/HealthBar")
onready var xpBar = get_node("BG/XpBar")
onready var goldText = get_node("GoldText")


func _ready():
	pass # Replace with function body.


func update_level_text(level):
	LevelText.text = str(level)

func update_health_bar(curHp, maxHp):
	
	healthBar.value = (100 / maxHp) * curHp

func update_xp_bar(curXp, xpToNextLevel):
	xpBar.value = (100 / xpToNextLevel) * curXp

func update_gold_text(gold):
	goldText.text = "gold: " + str(gold)





















