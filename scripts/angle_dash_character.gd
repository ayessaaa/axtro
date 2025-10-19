extends Area2D

@export var player = true

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var trail_segment_scene: PackedScene
var current_segment: Node = null

@onready var gameover_screen = get_parent().get_parent().get_node("GameoverBg")
@onready var death_sound = get_parent().get_parent().get_node("DeathSound")
@onready var bg_music = get_parent().get_parent().get_node("AngleDashBg")
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

func _ready() -> void:
	_start_new_segment()

func _process(delta: float) -> void:
	if Global.start_screen or !Global.is_angle_dash:
		return
	self.visible = Global.is_angle_dash
	if Global.dead:
		return
	if Global.angle_dash_animation_finished:
		if Input.is_action_just_pressed("shoot"):
			if Global.angle_dash_challenge_name == "RECKLESS DASHER":
				Global.angle_dash_challenge_progress += 1
			if Global.direction == 0:
				Global.direction = 1
			else:
				Global.direction *= -1
			sprite_2d.rotation_degrees = 80 if Global.direction > 0 else 0
			collision_polygon_2d.rotation_degrees = 80 if Global.direction > 0 else 0
			_start_new_segment()
		
		if position.y < 0 or position.y > 648:
			Global.dead = true
			death_sound.play()
			bg_music.stop()
			gameover_screen.play_animation("default")

		position.y += Global.direction * Global.angle_dash_speed * delta

		if current_segment:
			current_segment.extend_to(global_position, delta)

func _start_new_segment() -> void:
	var seg = trail_segment_scene.instantiate()
	get_parent().add_child(seg)

	if current_segment:
		seg.start(current_segment.end_pos, Global.direction)
	else:
		seg.start(global_position, Global.direction)
	current_segment = seg
