extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var character = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SpaceRayCharacter")

func _process(delta: float) -> void:
	if character:
		var target_angle = (character.global_position - global_position).angle()
		rotation = lerp_angle(rotation, target_angle+deg_to_rad(180), 5 * delta)
 
