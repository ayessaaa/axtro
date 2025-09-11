extends Area2D

@export var speed: float = 300.0
var direction: Vector2

@onready var gun = get_parent().get_parent().get_node("Gun")

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(gun.rotation)
	position -= direction * 20
	rotation = gun.rotation

func _process(delta: float) -> void:
	if Global.start_screen or Global.is_angle_dash or Global.is_mecha_flight or Global.marathon:
		return
	position -= direction * speed * delta
	
