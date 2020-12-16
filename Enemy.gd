extends KinematicBody2D

var curHp = 5
var maxHp = 5
var moveSpeed = 150
var xpToGive = 30
var damage = 1
var attackRate = 1.0
var attackDist = 50
var chaseDist = 400

onready var timer = $Timer
onready var target = get_node("/root/MainScene/Player")

func _physics_process(delta):
	var dist = position.distance_to(target.position)
	if dist > attackDist and dist < chaseDist:
		var vel = (target.position - position).normalized()
		
		move_and_slide(vel * moveSpeed)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = attackRate
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if position.distance_to(target.position) <= attackDist:
		target.take_damage(damage)
		

func take_damage(dmgToTake):
	curHp -= dmgToTake
	if curHp <= 0:
		die()
		
func die():
	target.give_xp(xpToGive)
	queue_free()
