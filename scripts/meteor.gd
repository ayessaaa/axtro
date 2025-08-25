extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var type = "meteor"

const LINES = preload("res://scenes/line.tscn")
@onready var lines_container = get_parent().get_node("Lines")

const STAR = preload("res://scenes/star.tscn")
@onready var stars_container = get_parent().get_node("Stars")

var line: Sprite2D

var speed = 2


func _ready() -> void:
	line = LINES.instantiate()
	line.position = Vector2(position.x, position.y-1200)
	line.object = self
	lines_container.add_child(line)

func _process(delta: float) -> void:
		position.x -= speed * delta * 70

func _on_area_entered(area: Area2D) -> void:
	print("enter")
	if line and line.is_inside_tree():
		line.queue_free()
	if area.player:
		print("dead")
		get_tree().reload_current_scene()
		Global.score = 0
	else:
		queue_free()
		var star = STAR.instantiate()
		star.position = position
		stars_container.add_child(star)
	
