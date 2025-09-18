extends Area2D

@export var speed: float = 400.0
var direction: Vector2
@export var type = "bullet"

@onready var character = get_parent().get_parent()
@onready var hit_sound = get_parent().get_parent().get_parent().get_node("SoundEffects/EnemyHitSound")
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(character.rotation)
	rotation = character.rotation

func _process(delta: float) -> void:
	position += direction * speed * delta
	


func _on_sprite_2d_animation_finished() -> void:
	sprite_2d.play("loop")


func _on_area_entered(area: Area2D) -> void:
	if area.type == "enemy_rocket":
		hit_sound.play()
		queue_free()
	
	#queue_free()
