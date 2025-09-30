extends Area2D

@export var type = "enemy_rocket"

@onready var character_animation = get_parent().get_parent().get_node("SpaceRayCharacter/SpaceRayCharacterArea/AnimationPlayer")
@onready var hurt_sound = get_parent().get_parent().get_node("SpaceRayCharacter/HurtSound")
@onready var progress_bar: ProgressBar = $Sprite2D/ProgressBar
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprite_animation: AnimationPlayer = $AnimationPlayer

var speed = 0
var health = 100

func _ready() -> void:
	speed = randf_range(4, 7)

func _process(delta: float) -> void:
	visible = Global.is_space_ray
	if !Global.is_space_ray or Global.dead:
		return
	if health < 0:
		queue_free()
	if health < 100:
		progress_bar.value = health
		progress_bar.visible = true
	else:
		progress_bar.visible = false
		
	if Global.laser_enter:
		Global.rocket_position_laser = position
		#print("schanging stuffs")
	
		
	position.x -= speed


func _on_area_entered(area: Area2D) -> void:
	if area.type == "player":
		if Global.space_ray_hearts > 0:
			Global.space_ray_hearts -= 1
			character_animation.play("hurt")
			hurt_sound.play()
			sprite_animation.play("hurt")
	if area.type == "bullet" or area.type == "red_bullet":
		sprite_animation.play("hurt")
		Global.space_ray_score += 2
	if area.type == "laser" and Global.space_ray_weapon == "laser":
		#Global.laser_enter = true
		#Global.rocket_position_laser = position
		health -= 10
	if area.type == "bomb":
		sprite_animation.play("hurt")
		Global.space_ray_score += 2


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
