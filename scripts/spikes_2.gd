extends Area2D
@export var type = "spikes"

@onready var gameover_screen = get_parent().get_parent().get_parent().get_node("GameoverBg")
@onready var death_sound = get_parent().get_parent().get_parent().get_node("DeathSound")
@onready var bg_music = get_parent().get_parent().get_parent().get_node("AngleDashBg")

func _process(delta: float) -> void:
	self.visible = Global.is_angle_dash
	if Global.dead:
		return
	if Global.angle_dash_animation_finished:
		position.x -= delta * Global.spike_speed
		

func _on_area_entered(area: Area2D) -> void:
	if Global.is_angle_dash:
		if area.player:
			print("ded")
			Global.dead = true
			death_sound.play()
			bg_music.stop()
			gameover_screen.play_animation("default")
		#Global.controls_tutorial = false
		#gameover_screen.play_animation("default")
