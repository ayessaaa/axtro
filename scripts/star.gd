extends Area2D


@onready var score: Label = get_node("/root/Game/ScoreNode/Score")
@export var type = "star"
@onready var coin_sound = get_parent().get_node("CoinSound")

func _on_area_entered(area: Area2D) -> void:
	if area.player:
		coin_sound.play()
		queue_free()
		if Global.double_points:
			Global.score += 2
			Global.meteor_speed += .5
		else:
			Global.score += 1
			Global.meteor_speed += .25
		score.text = "SCORE: "+ str(Global.score)
		score.show()
		
		if Global.spawn_interval > 0.5:
			Global.spawn_interval -= .1
