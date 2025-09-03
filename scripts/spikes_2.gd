extends Area2D
@export var type = "spikes"

@onready var gameover_screen = get_parent().get_parent().get_parent().get_node("GameoverBg")
@onready var death_sound = get_parent().get_parent().get_parent().get_node("DeathSound")
@onready var bg_music = get_parent().get_parent().get_parent().get_node("AngleDashBg")
@onready var angle_dash_star_1: Area2D = $angle_dash_star1
@onready var angle_dash_star_2: Area2D = $angle_dash_star2
@onready var angle_dash_star_3: Area2D = $angle_dash_star3
@onready var angle_dash_star_4: Area2D = $angle_dash_star4
@onready var angle_dash_star_5: Area2D = $angle_dash_star5
@onready var angle_dash_star_6: Area2D = $angle_dash_star6

@onready var stars_array = [angle_dash_star_1, angle_dash_star_2, angle_dash_star_3, angle_dash_star_4, angle_dash_star_5, angle_dash_star_6]

func _ready() -> void:
	var random_int = randi_range(0, len(stars_array)-1)
	var selected_star = stars_array[random_int]
	for star in stars_array:
		star.visible = false
		if star == selected_star:
			star.visible = true

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
