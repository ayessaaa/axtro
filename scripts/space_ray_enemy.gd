extends Area2D

@export var type = "enemy"
@onready var enemy: AnimatedSprite2D = $Enemy
@onready var laser_beam: AudioStreamPlayer2D = $LaserBeam
@onready var gun: Area2D = $Gun

@onready var character = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SpaceRayCharacter")

var health = 100
#
func _on_area_entered(area: Area2D) -> void:
	print(area.type)
	if area.type == "laser":
		laser_beam.play()

func _on_area_exited(area: Area2D) -> void:
	if area.type == "laser":
		laser_beam.stop()
		

func _process(delta: float) -> void:
		
	if !Global.is_space_ray:
		return
	for area in get_overlapping_areas():
		if area.type == "laser":
			health -= 10 *delta
			enemy.play("hurt")
		else:
			enemy.play("default")
			
	if len(get_overlapping_areas()) <= 0:
		enemy.play("default")
			#print(health)
	if health < 0:
		queue_free()
