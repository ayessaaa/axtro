extends Area2D

@onready var gameover_screen = get_parent().get_parent().get_parent().get_parent().get_node("GameoverBg")
@onready var death_sound = get_parent().get_parent().get_parent().get_parent().get_node("DeathSound")
@onready var bg_music = get_parent().get_parent().get_parent().get_parent().get_node("AngleDashBg")

func _process(delta: float) -> void:
	if position.x < -200:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if Global.is_angle_dash:
		if area.player:
			Global.dead = true
			death_sound.play()
			bg_music.stop()
			gameover_screen.play_animation("default")


func _on_diamond_outer_area_purple_area_entered(area: Area2D) -> void:
	if Global.is_angle_dash:
		if area.player:
			print("brush")
