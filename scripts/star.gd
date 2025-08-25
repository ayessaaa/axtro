extends Area2D

@onready var score: Label = get_node("/root/Game/Score")
@export var type = "star"
@onready var coin_sound = get_parent().get_node("CoinSound")

func _on_area_entered(area: Area2D) -> void:
	if area.player:
		coin_sound.play()
		queue_free()
		Global.score += 1
		score.text = "SCORE: "+ str(Global.score)
		score.show()
