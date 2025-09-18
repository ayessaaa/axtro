extends Area2D

@export var speed: float = 400.0
var direction: Vector2
@export var type = "bullet"

@onready var character = get_parent().get_parent()
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(character.rotation)
	rotation = character.rotation

func _process(delta: float) -> void:
	position += direction * speed * delta
	


func _on_sprite_2d_animation_finished() -> void:
	sprite_2d.play("loop")
