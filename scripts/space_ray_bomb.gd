extends Area2D

@export var speed: float = 300.0
var direction: Vector2
@export var type = "bomb"

@onready var character = get_parent().get_parent()
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var hit_sound = get_parent().get_parent().get_parent().get_node("SoundEffects/EnemyHitSound")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var explode_sound: AudioStreamPlayer2D = $ExplodeSound
@onready var bomb_sound: AudioStreamPlayer2D = $BombSound

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(character.rotation)
	rotation = character.rotation
	bomb_sound.play()

func _process(delta: float) -> void:
	
	if !Global.is_space_ray or Global.dead:
		return
	if Global.space_ray_stop:
		return
	
	if Input.is_action_just_pressed("shoot") and Global.theres_bomb:
		if Global.space_ray_powerup == "big_bomb":
			animation_player.play("big_bomb")
		else:
			animation_player.play("explode")
		sprite_2d.play("explosion")
		explode_sound.play()
		bomb_sound.stop()
		
		
	if sprite_2d.animation != "explosion":
		position += direction * speed * delta
		
	Global.theres_bomb = true
	
	if position.y <= -100 or position.y >= 700 or position.x >= 1200:
		Global.theres_bomb = false
		queue_free()
	


func _on_sprite_2d_animation_finished() -> void:
	Global.theres_bomb = false
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.type == "enemy_rocket" or area.type == "enemy" or area.type == "enemy_meteor" or area.type == "enemy_blaister":
		hit_sound.play()
		explode_sound.play()
		#animation_player.play("explode")
		sprite_2d.play("explosion")


func _on_bomb_sound_finished() -> void:
	bomb_sound.play()
