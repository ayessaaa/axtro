extends Area2D

@export var speed: float = 300.0
var direction: Vector2

@onready var gun = get_parent().get_parent().get_node("Gun")

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(gun.rotation)
	position -= direction * 20
	rotation = gun.rotation

func _process(delta: float) -> void:
	position -= direction * speed * delta
	
