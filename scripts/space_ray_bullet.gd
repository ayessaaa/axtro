extends Area2D

@export var speed: float = 400.0
var direction: Vector2
@export var type = "bullet"

@onready var character = get_parent().get_parent()
@onready var hit_sound = get_parent().get_parent().get_parent().get_node("SoundEffects/EnemyHitSound")
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D



func _ready() -> void:
	pass
	#direction = Vector2.RIGHT.rotated(character.rotation)
	#rotation = character.rotation

func _process(delta: float) -> void:
	if Global.space_ray_stop or !Global.is_space_ray:
		return
	position += direction * speed * delta
	
	if position.y <= -100 or position.y >= 700 or position.x >= 1200:
		queue_free()
	


func _on_sprite_2d_animation_finished() -> void:
	sprite_2d.play("loop")


func _on_area_entered(area: Area2D) -> void:
	if area.type == "enemy_rocket" or area.type == "enemy" or area.type == "enemy_blaister":
		hit_sound.play()
		queue_free()
	if area.type == "enemy_meteor":
		hit_sound.volume_db = -5
		hit_sound.play()
	if area.type == "fireball":
		sprite_2d.play("red_loop")
		type = "red_bullet"
	
	#queue_free()
