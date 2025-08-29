extends Node

@onready var bg_music: AudioStreamPlayer2D = $BgMusic
@onready var controls: Area2D = $Controls
@onready var shield: Sprite2D = $Powerups/Shield
@onready var powerups_icon: Area2D = $Powerups/PowerupsIcon

var timer = 0
var double_points_timer = 0

func _ready() -> void:
	bg_music.play()

func _process(delta: float) -> void:
	
	if Global.dead:
		if Input.is_action_pressed("shoot"):
				Global.dead = false
				Global.score = 0
				Global.meteor_speed = 4.0
				Global.spawn_interval = 1.5
				get_tree().reload_current_scene()
			
			
	if Global.controls_tutorial:
		if timer > 7.8:
			Global.controls_tutorial = false
		timer += delta
	else:
		controls.visible = false
	shield.visible = Global.shield
	powerups_icon.visible = Global.double_points
	
	#if Global.controls_tutorial:
		#if timer > 7.8:
			#Global.controls_tutorial = false
		#timer += delta
	#else:
		#controls.visible = false
		


func _on_bg_music_finished() -> void:
	bg_music.play()
	
