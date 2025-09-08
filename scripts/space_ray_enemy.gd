extends Area2D

@export var type = "enemy"

var health = 100
#
#func _on_area_entered(area: Area2D) -> void:
	#print(area.type)
	#if area.type == "laser":
		#print("enter")
#
#func _on_area_exited(area: Area2D) -> void:
	#if area.type == "laser":
		#print("exit")

func _process(delta: float) -> void:
	if !Global.is_space_ray:
		return
	for area in get_overlapping_areas():
		if area.type == "laser":
			health -= 20 *delta
			print(health)
	if health < 0:
		queue_free()
