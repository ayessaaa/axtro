extends Area2D

@export var type = "sr_star"

func _process(delta: float) -> void:
	#position.x -= 2
	visible = Global.is_space_ray
	if !Global.is_space_ray or Global.dead:
		return
	if Global.space_ray_stop:
		return
	position.y += 1.5


func _on_area_entered(area: Area2D) -> void:
	if area.type == "player":
		print("player caught star")
		queue_free()
