extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var type = "meteor"
@export var asteroid_meteor_fall = false

const LINES = preload("res://scenes/line.tscn")
@onready var lines_container = get_parent().get_node("Lines")

const SPECIAL_STAR = preload("res://scenes/special_star.tscn")
@onready var stars_container = get_parent().get_node("Stars")

var line: Sprite2D

@onready var death_sound = get_parent().get_node("DeathSound")

const GRAVITY = 800

@onready var gameover_screen = get_parent().get_parent().get_node("GameoverBg")

var random_speed = randf_range(1, 1.3)

func _ready() -> void:
	line = LINES.instantiate()
	line.position = Vector2(position.x, position.y-1200)
	line.object = self
	lines_container.add_child(line)

func _physics_process(delta: float) -> void:
	if Global.dead:
		
		if Input.is_action_pressed("shoot"):
			Global.dead = false
			Global.score = 0
			Global.meteor_speed = 2
			Global.spawn_interval = 2
			get_tree().reload_current_scene()
			
		return
	#speed += 1 * delta
	if asteroid_meteor_fall:
		velocity.y += GRAVITY * delta
		move_and_slide()
		rotate(0.2*delta*50)
		if position.y > 1000:
			queue_free()
	else:
		position.x -= Global.meteor_speed * delta * 70 * random_speed
		
func _on_asteroid_area_2d_area_entered(area: Area2D) -> void:
	print("enter")
	if area.player:
		print("dead")
		#get_tree().reload_current_scene()
		Global.dead = true
		death_sound.play()
		Global.controls_tutorial = false
		gameover_screen.play_animation("default")
		#DarkBg.transition()
		#get_tree().paused = true
		#Global.score = 0
	else:
		if !asteroid_meteor_fall:
			var special_star = SPECIAL_STAR.instantiate()
			special_star.position = position
			stars_container.add_child(special_star)
		asteroid_meteor_fall = true
		
	if line and line.is_inside_tree():
		line.queue_free()
