extends Area2D

@export var type = "laser"
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var character = get_parent().get_node("SpaceRayCharacterArea")
@onready var sprite_2d_2: Sprite2D = $Sprite2D2


func _process(delta: float) -> void:
	if !Global.is_space_ray or Global.dead:
		return
	if Global.start_screen or Global.is_angle_dash or Global.is_mecha_flight or Global.marathon:
		return
	#if Global.space_ray_weapon != "laser":
		#queue_free()
	visible = Global.space_ray_weapon == "laser"
	#scale.x = .25
	if Global.laser_enter:
		var length = character.position.distance_to(Global.rocket_position_laser)
		scale.x = length / sprite_2d_2.texture.get_size().x 
		print(scale.x)
		#print("laser running")
	#if !Global.laser_enter:
		#scale.x = 1
