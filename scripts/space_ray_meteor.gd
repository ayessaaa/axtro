extends Area2D

@export var type = "enemy_meteor"

@onready var character_animation = get_parent().get_parent().get_node("SpaceRayCharacter/SpaceRayCharacterArea/AnimationPlayer")

var x_speed 
var y_speed

func _ready() -> void:
	x_speed = randf_range(2.5, 5)
	y_speed = randf_range(0.5, 1.5)

func _process(delta: float) -> void:
	visible = Global.is_space_ray
	if !Global.is_space_ray or Global.dead:
		return
	position.y += y_speed
	position.x -= x_speed


func _on_area_entered(area: Area2D) -> void:
	if area.type == "player":
		if Global.space_ray_hearts > 0:
			Global.space_ray_hearts -= 1
			character_animation.play("hurt")
			queue_free()
		
