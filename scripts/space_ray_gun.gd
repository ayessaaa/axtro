extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var character = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SpaceRayCharacter")

func _process(delta: float) -> void:
	if !Global.is_space_ray:
		return
	if Global.start_screen or Global.is_angle_dash or Global.is_mecha_flight or Global.marathon:
		return
	if character:
		var target_angle = (character.global_position - global_position).angle()
		rotation = lerp_angle(rotation, target_angle+deg_to_rad(180), 5 * delta)
 
