extends Node

@onready var bg_music: AudioStreamPlayer2D = $BgMusic
@onready var angle_dash_bg: AudioStreamPlayer2D = $AngleDashBg
@onready var new_mode_sound: AudioStreamPlayer2D = $NewModeSound

@onready var controls: Area2D = $Controls
@onready var shield: Sprite2D = $Powerups/Shield
@onready var double_point_icon: Area2D = $Powerups/DoublePointIcon
@onready var magnet_icon: Area2D = $Powerups/MagnetIcon
@onready var magnet_icon_sprite: Sprite2D = $Powerups/MagnetIcon/Sprite2D
@onready var unli_bullet_icon: Area2D = $Powerups/UnliBulletIcon
@onready var unli_bullet_icon_sprite: Sprite2D = $Powerups/UnliBulletIcon/Sprite2D

@onready var angle_dash: Node = $AngleDash
@onready var progress_area_animation = $ProgressArea/AnimationPlayer
@onready var score: Label = $ScoreNode/Score
@onready var score_sprite_2d: Sprite2D = $ScoreNode/Sprite2D

var timer = 5
var double_points_timer = 0

func _ready() -> void:
	if Global.is_angle_dash:
		angle_dash_bg.play()
		progress_area_animation.play("fade_in_angle_dash")
		
	else:
		bg_music.play()
		progress_area_animation.play("fade_in")
	magnet_icon_sprite.texture = load("res://assets/IMG_1676.PNG")
	unli_bullet_icon_sprite.texture = load("res://assets/IMG_1677.PNG")

func _process(delta: float) -> void:
	
	score.visible = !Global.start_screen
	score_sprite_2d.visible = !Global.start_screen
	
	if Global.dead:
		if Global.is_angle_dash:
			pass
		else:
			if Input.is_action_pressed("enter"):
					Global.dead = false
					Global.score = 0
					Global.next_mode_score = 0
					Global.meteor_speed = 4.0
					Global.spawn_interval = 1.5
					Global.shield = false
					Global.double_points = false
					Global.magnet = false
					Global.unli_bullet = false
					Global.shoot_left = 3
					get_tree().reload_current_scene()
				

				
	if Global.is_angle_dash and Global.meteor_speed > 0:
		Global.meteor_speed = 0
		Global.spawn_interval = 0
		Global.object_speed = 0
		Global.speed = 0
		Global.shield = false
		Global.double_points = false
		Global.magnet = false
		Global.unli_bullet = false
		bg_music.stop()
		angle_dash_bg.play()
		new_mode_sound.play()
			
			
	if Global.controls_tutorial and !Global.start_screen:
		if timer > 7.8:
			Global.controls_tutorial = false
		timer += delta
	else:
		controls.visible = false
	shield.visible = Global.shield
	double_point_icon.visible = Global.double_points
	magnet_icon.visible = Global.magnet
	unli_bullet_icon.visible = Global.unli_bullet
	
	if Input.is_action_just_pressed("esc") and !Global.start_screen:
		Global.start_screen = true
		Global.is_angle_dash = false
		get_tree().reload_current_scene()
	
	#if Global.controls_tutorial:
		#if timer > 7.8:
			#Global.controls_tutorial = false
		#timer += delta
	#else:
		#controls.visible = false
		


func _on_bg_music_finished() -> void:
	bg_music.play()
	
