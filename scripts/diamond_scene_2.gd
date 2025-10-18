extends Area2D
@onready var angle_dash_star: Area2D = $angle_dash_star
@onready var angle_dash_star_2: Area2D = $angle_dash_star2
@onready var angle_dash_star_3: Area2D = $angle_dash_star3
@onready var angle_dash_star_4: Area2D = $angle_dash_star4

@onready var stars_array = [angle_dash_star, angle_dash_star_2, angle_dash_star_3, angle_dash_star_4]

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
	if position.x < -1000:
		queue_free()
