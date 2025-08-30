extends Node

@onready var bg_music: AudioStreamPlayer2D = $BgMusic
@onready var controls: Area2D = $Controls
@onready var shield: Sprite2D = $Powerups/Shield
@onready var double_point_icon: Area2D = $Powerups/DoublePointIcon
@onready var magnet_icon: Area2D = $Powerups/MagnetIcon
@onready var magnet_icon_sprite: Sprite2D = $Powerups/MagnetIcon/Sprite2D
@onready var unli_bullet_icon: Area2D = $Powerups/UnliBulletIcon
@onready var unli_bullet_icon_sprite: Sprite2D = $Powerups/UnliBulletIcon/Sprite2D

var timer = 0
var double_points_timer = 0

func _ready() -> void:
	bg_music.play()
	magnet_icon_sprite.texture = load("res://assets/IMG_1676.PNG")
	unli_bullet_icon_sprite.texture = load("res://assets/IMG_1677.PNG")

func _process(delta: float) -> void:
	
	if Global.dead:
		if Input.is_action_pressed("shoot"):
				Global.dead = false
				Global.score = 0
				Global.meteor_speed = 4.0
				Global.spawn_interval = 1.5
				Global.shield = false
				Global.double_points = false
				Global.magnet = false
				Global.unli_bullet = false
				get_tree().reload_current_scene()
			
			
	if Global.controls_tutorial:
		if timer > 7.8:
			Global.controls_tutorial = false
		timer += delta
	else:
		controls.visible = false
	shield.visible = Global.shield
	double_point_icon.visible = Global.double_points
	magnet_icon.visible = Global.magnet
	unli_bullet_icon.visible = Global.unli_bullet
	
	#if Global.controls_tutorial:
		#if timer > 7.8:
			#Global.controls_tutorial = false
		#timer += delta
	#else:
		#controls.visible = false
		


func _on_bg_music_finished() -> void:
	bg_music.play()
	
