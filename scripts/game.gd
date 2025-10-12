extends Node

@onready var bg_music: AudioStreamPlayer2D = $BgMusic
@onready var angle_dash_bg: AudioStreamPlayer2D = $AngleDashBg
@onready var space_ray_bg: AudioStreamPlayer2D = $SpaceRayMusic
@onready var new_mode_sound: AudioStreamPlayer2D = $NewModeSound
@onready var selected_sound: AudioStreamPlayer2D = $SelectedSound
@onready var ocean_rhythm_music: AudioStreamPlayer2D = $OceanRhythmMusic

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

@onready var heart_1: AnimatedSprite2D = $Hearts/Sprite2D
@onready var heart_2: AnimatedSprite2D = $Hearts/Sprite2D2
@onready var bullet_cooldown_area: Area2D = $BulletCooldown/BulletCooldownArea
@onready var bullet_cooldown_area_2: Area2D = $BulletCooldown/BulletCooldownArea2
@onready var bullet_cooldown_area_3: Area2D = $BulletCooldown/BulletCooldownArea3


@onready var player1_bullet_cooldown_area: Area2D = $TwoPlayers/Player1/BulletCooldownArea
@onready var player1_bullet_cooldown_area_2: Area2D = $TwoPlayers/Player1/BulletCooldownArea2
@onready var player1_bullet_cooldown_area_3: Area2D = $TwoPlayers/Player1/BulletCooldownArea3
@onready var player1_heart_1: AnimatedSprite2D = $TwoPlayers/Player1/Heart
@onready var player1_heart_2: AnimatedSprite2D = $TwoPlayers/Player1/Heart2
@onready var player1_progress_bar: ProgressBar = $TwoPlayers/Player1/ProgressBar
@onready var player1_sprite_2d: Sprite2D = $TwoPlayers/Player1/Sprite2D
@onready var player2_bullet_cooldown_area: Area2D = $TwoPlayers/Player2/BulletCooldownArea
@onready var player2_bullet_cooldown_area_2: Area2D = $TwoPlayers/Player2/BulletCooldownArea2
@onready var player2_bullet_cooldown_area_3: Area2D = $TwoPlayers/Player2/BulletCooldownArea3
@onready var player2_heart_1: AnimatedSprite2D = $TwoPlayers/Player2/Heart
@onready var player2_heart_2: AnimatedSprite2D = $TwoPlayers/Player2/Heart2
@onready var player2_progress_bar: ProgressBar = $TwoPlayers/Player2/ProgressBar
@onready var player2_sprite_2d: Sprite2D = $TwoPlayers/Player2/Sprite2D

@onready var player1_score_sprite: Sprite2D = $TwoPlayers/Player1/ScoreSprite
@onready var player1_score: Label = $TwoPlayers/Player1/Score
@onready var player2_score_sprite: Sprite2D = $TwoPlayers/Player2/ScoreSprite
@onready var player2_score: Label = $TwoPlayers/Player2/Score
@onready var bg_1: ProgressBar = $TwoPlayers/Player1/Powerups/Bg1
@onready var bg_2: ProgressBar = $TwoPlayers/Player2/Powerups/Bg2
@onready var shield1: Sprite2D = $TwoPlayers/Player1/Powerups/Shield
@onready var shield2: Sprite2D = $TwoPlayers/Player2/Powerups/Shield

const METEOR = preload("res://scenes/meteor.tscn")
const SMALL_METEOR = preload("res://scenes/small_meteor.tscn")
const ASTEROID = preload("res://scenes/asteroid.tscn")
@onready var meteors_container = get_node("Meteors")

var screen_size
var meteor_timer = 0.0

var timer = 5
var double_points_timer = 0
#@onready var unli_bullet_icon_animation: Area2D = $TwoPlayers/Player1/Powerups/UnliBulletIcon/AnimationPlayer

func _ready() -> void:
	if Global.is_angle_dash:
		if Global.marathon:
			angle_dash_bg.play()
		progress_area_animation.play("fade_in_angle_dash")
	elif Global.is_space_ray:
		space_ray_bg.play()
	else:
		bg_music.play()
		progress_area_animation.play("fade_in")
	magnet_icon_sprite.texture = load("res://assets/IMG_1676.PNG")
	unli_bullet_icon_sprite.texture = load("res://assets/IMG_1677.PNG")
	
	#unli_bullet_icon_animation.play("default")
	
	screen_size = Vector2(1100, 600)
	spawn_asteroid(Vector2(1200, randf_range(50, screen_size[1]-100)))
	spawn_small_meteor(Vector2(1500, randf_range(50, screen_size[1]-100)))
	spawn_meteor(Vector2(1800, randf_range(50, screen_size[1]-100)))
	spawn_small_meteor(Vector2(2000, randf_range(50, screen_size[1]-100)))

func _process(delta: float) -> void:
	score.visible = !Global.start_screen
	score_sprite_2d.visible = !Global.start_screen
	
	score.visible = (Global.mecha_flight_player == 1)
	score_sprite_2d.visible = (Global.mecha_flight_player == 1)
	heart_1.visible = (Global.mecha_flight_player == 1)
	heart_2.visible = (Global.mecha_flight_player == 1)
	bullet_cooldown_area.visible = (Global.mecha_flight_player == 1)
	bullet_cooldown_area_2.visible = (Global.mecha_flight_player == 1)
	bullet_cooldown_area_3.visible = (Global.mecha_flight_player == 1)
	player1_bullet_cooldown_area.visible = !(Global.mecha_flight_player == 1)
	player1_bullet_cooldown_area_2.visible = !(Global.mecha_flight_player == 1)
	player1_bullet_cooldown_area_3.visible = !(Global.mecha_flight_player == 1)
	player1_heart_1.visible = !(Global.mecha_flight_player == 1)
	player1_heart_2.visible = !(Global.mecha_flight_player == 1)
	player2_bullet_cooldown_area.visible = !(Global.mecha_flight_player == 1)
	player2_bullet_cooldown_area_2.visible = !(Global.mecha_flight_player == 1)
	player2_bullet_cooldown_area_3.visible = !(Global.mecha_flight_player == 1)
	player2_heart_1.visible = !(Global.mecha_flight_player == 1)
	player2_heart_2.visible = !(Global.mecha_flight_player == 1)
	player1_progress_bar.visible = !(Global.mecha_flight_player == 1)
	player1_sprite_2d.visible = !(Global.mecha_flight_player == 1)
	player2_progress_bar.visible = !(Global.mecha_flight_player == 1)
	player2_sprite_2d.visible = !(Global.mecha_flight_player == 1)
	player1_score_sprite.visible = !(Global.mecha_flight_player == 1)
	player1_score.visible = !(Global.mecha_flight_player == 1)
	player2_score_sprite.visible = !(Global.mecha_flight_player == 1)
	player2_score.visible = !(Global.mecha_flight_player == 1)
	shield1.visible = Global.shield_player1
	shield2.visible = Global.shield_player2
	
	if Global.dead:
		if Global.is_angle_dash or Global.is_space_ray:
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
					Global.hearts = 2
					Global.mecha_flight_animation_done = false
					Global.mecha_flight_player1_hearts = 2
					Global.mecha_flight_player2_hearts = 2
					Global.mecha_flight_player1_bullets = 3
					Global.mecha_flight_player2_bullets = 3
					Global.mecha_flight_player1_score = 0
					Global.mecha_flight_player1_score = 0
					Global.powerup_player1 = null
					Global.powerup_player2 = null
					Global.unli_bullet_player1 = false
					Global.unli_bullet_player2 = false
					Global.magnet_player1 = false
					Global.magnet_player2 = false
					Global.double_point_player2 = false
					Global.double_point_player2 = false
					Global.shield_player1 = false
					Global.shield_player2 = false
					get_tree().reload_current_scene()
					
	if !Global.selected_sound_played:
		if Global.marathon or Global.is_mecha_flight:
			selected_sound.play()
			Global.selected_sound_played = true
		
		
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
		#selected_sound.play()
		
		if Global.marathon:
			angle_dash_bg.play()
			new_mode_sound.play()
		#else:
			#selected_sound.play()
		
			
			
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
		Global.is_angle_dash = false
		Global.is_angle_dash = false
		Global.score = 0
		Global.next_mode_score = 0
		Global.dead = false
		Global.is_angle_dash = false
		Global.angle_dash_score = 0
		Global.start_screen = true
		Global.marathon = false
		Global.is_mecha_flight = false
		Global.is_space_ray = false
		Global.is_ocean_rhythm = false
		Global.is_mecha_flight_player_screen = false
		Global.mecha_flight_player = 1
		Global.mecha_flight_animation_done = false
		Global.mecha_flight_player1_hearts = 2
		Global.mecha_flight_player2_hearts = 2
		Global.mecha_flight_player1_bullets = 3
		Global.mecha_flight_player2_bullets = 3
		Global.mecha_flight_player1_score = 0
		Global.mecha_flight_player1_score = 0
		Global.powerup_player1 = null
		Global.powerup_player2 = null
		Global.unli_bullet_player1 = false
		Global.unli_bullet_player2 = false
		Global.magnet_player1 = false
		Global.magnet_player2 = false
		Global.double_point_player2 = false
		Global.double_point_player2 = false
		Global.shield_player1 = false
		Global.shield_player2 = false
		get_tree().reload_current_scene()
		
	if Global.hearts == 2:
		heart_2.modulate = Color(1,1,1)
		
	if Global.is_mecha_flight or Global.marathon:
		meteor_timer += delta
		if meteor_timer >= Global.spawn_interval and Global.meteor_speed != 0:
			meteor_timer = 0
			if randi_range(0,10) < 1:
				spawn_asteroid(Vector2(2000, randf_range(50, screen_size[1]-100)))
			else:
				if randi_range(0,2) < 2:
					spawn_meteor(Vector2(2000, randf_range(50, screen_size[1]-100)))
				else:
					spawn_small_meteor(Vector2(2000, randf_range(50, screen_size[1]-100)))
	
	#if Global.controls_tutorial:
		#if timer > 7.8:
			#Global.controls_tutorial = false
		#timer += delta
	#else:
		#controls.visible = false
		


func _on_bg_music_finished() -> void:
	bg_music.play()
	
func _on_ocean_rhythm_music_finished() -> void:
	ocean_rhythm_music.play()
	
func spawn_meteor(pos):
	var meteor = METEOR.instantiate()
	meteor.position = pos
	meteors_container.add_child(meteor)
	
func spawn_small_meteor(pos):
	var small_meteor = SMALL_METEOR.instantiate()
	small_meteor.position = pos
	meteors_container.add_child(small_meteor)
	
func spawn_asteroid(pos):
	var small_asteroid = ASTEROID.instantiate()
	small_asteroid.position = pos
	meteors_container.add_child(small_asteroid)
	

func _on_space_ray_music_finished() -> void:
	space_ray_bg.play()
