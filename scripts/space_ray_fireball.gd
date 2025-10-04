extends Area2D

@export var speed: float = 300.0
var direction: Vector2
@export var type = "fireball"

@onready var gun = get_parent().get_parent().get_node("Gun")
@onready var character_animation = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SpaceRayCharacter/SpaceRayCharacterArea/AnimationPlayer")
@onready var space_ray_animation = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("AnimationPlayer")
@onready var corner_laser = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Powerup/CornerLaser")
@onready var corner_laser_2 = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Powerup/CornerLaser2")
@onready var hurt_sound = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SpaceRayCharacter/HurtSound")

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(gun.rotation)
	position -= direction * 20
	rotation = gun.rotation

func _process(delta: float) -> void:
	if !Global.is_space_ray or Global.dead:
		return
	if Global.space_ray_stop:
		return
	position -= direction * speed * delta
	
	if position.x < -100 or position.y >700 or position.y < -100:
		queue_free()
	

func _on_area_entered(area: Area2D) -> void:
	if area.type == "player":
		if Global.space_ray_powerup == "invisible":
			return
		if Global.space_ray_hearts > 0:
			Global.space_ray_hearts -= 1
			corner_laser.play("red")
			corner_laser_2.play("red")
			space_ray_animation.play("player_hurt")
			character_animation.play("hurt")
			hurt_sound.play()
			queue_free()
	if area.type == "bullet" or area.type == "bomb":
		queue_free()
