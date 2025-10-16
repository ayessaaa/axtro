extends Area2D


@onready var sprite_2d: Sprite2D = $Sprite2D

var texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = load("res://assets/IMG_1556.PNG")
	sprite_2d.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Global.marathon and !Global.is_mecha_flight:
		return
	if Global.dead or Global.is_space_ray or Global.mecha_flight_tutorial:
		return
	#if Global.free_regular_mode_objects or Global.start_screen:
		#return
	#print("returningggg")
	
	if position.x <= -150:
		position.x = 1700
		if randi_range(0,2) > 1:
			texture = load("res://assets/IMG_1648.PNG")
			sprite_2d.texture = texture
	else:
		position.x -= Global.object_speed * delta * 60
