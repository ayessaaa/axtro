extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var speed = 2

func _process(delta: float) -> void:
	if position.x <= -150:
		position.x = 1500
	else:
		position.x -= speed

func _on_area_entered(area: Area2D) -> void:
	print("dead")
	get_tree().reload_current_scene()

	
