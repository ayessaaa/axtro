extends Area2D

@export var speed: float = 300.0
var direction: Vector2
@export var type = "fireball"

@onready var gun = get_parent().get_parent().get_node("Gun")
@onready var character_animation = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SpaceRayCharacter/SpaceRayCharacterArea/AnimationPlayer")
@onready var hurt_sound = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SpaceRayCharacter/HurtSound")

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(gun.rotation)
	position -= direction * 20
	rotation = gun.rotation

func _process(delta: float) -> void:
	if !Global.is_space_ray or Global.dead:
		return
	if Global.start_screen or Global.is_angle_dash or Global.is_mecha_flight or Global.marathon:
		return
	position -= direction * speed * delta
	

func _on_area_entered(area: Area2D) -> void:
	if area.type == "player":
		if Global.space_ray_hearts > 0:
			Global.space_ray_hearts -= 1
			character_animation.play("hurt")
			hurt_sound.play()
			queue_free()
	if area.type == "bullet":
		print("bullet")
		queue_free()
