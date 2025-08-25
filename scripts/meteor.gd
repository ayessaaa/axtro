extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var type = "meteor"

const LINES = preload("res://scenes/line.tscn")
@onready var lines_container = get_parent().get_node("Lines")

const STAR = preload("res://scenes/star.tscn")
@onready var stars_container = get_parent().get_node("Stars")

var line: Sprite2D

var speed = 2
var meteor_fall = false

const GRAVITY = 800

@onready var gameover_screen = get_parent().get_parent().get_node("GameoverBg")

func _ready() -> void:
	line = LINES.instantiate()
	line.position = Vector2(position.x, position.y-1200)
	line.object = self
	lines_container.add_child(line)

func _physics_process(delta: float) -> void:
	if Global.dead and gameover_screen.position.y < 150:
			gameover_screen.position.y += 150 * delta 
			return
	elif Global.dead:
		if Input.is_action_pressed("shoot"):
			Global.dead = false
			Global.score = 0
			get_tree().reload_current_scene()
			
		return
	#speed += 1 * delta
	if meteor_fall:
		velocity.y += GRAVITY * delta
		move_and_slide()
		if position.y > 1000:
			queue_free()
	else:
		position.x -= speed * delta * 70
		
	
		



func _on_meteor_area_2d_area_entered(area: Area2D) -> void:
	print("enter")
	if area.player:
		print("dead")
		#get_tree().reload_current_scene()
		Global.dead = true
		#DarkBg.transition()
		#get_tree().paused = true
		#Global.score = 0
	else:
		meteor_fall = true
		var star = STAR.instantiate()
		star.position = position
		stars_container.add_child(star)
		
	if line and line.is_inside_tree():
		line.queue_free()
	
	
		
	
