extends Area2D

@export var speed: float = 300.0
var direction: Vector2
@export var type = "bomb"

@onready var character = get_parent().get_parent()
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(character.rotation)
	rotation = character.rotation

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("shoot") and Global.theres_bomb:
		sprite_2d.play("explosion")
		
		
	if sprite_2d.animation != "explosion":
		position += direction * speed * delta
		
	Global.theres_bomb = true
	


func _on_sprite_2d_animation_finished() -> void:
	Global.theres_bomb = false
	queue_free()
