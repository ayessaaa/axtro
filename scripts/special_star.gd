extends Area2D

@onready var score: Label = get_node("/root/Game/Score")
@export var type = "star"
@onready var powerup_sound = get_parent().get_node("PowerupSound")

func _on_area_entered(area: Area2D) -> void:
	if area.player:
		powerup_sound.play()
		queue_free()
