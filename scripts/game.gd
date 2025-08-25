extends Node

@onready var bg_music: AudioStreamPlayer2D = $BgMusic
@onready var controls: Area2D = $Controls

var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.controls_tutorial:
		if timer > 7.8:
			Global.controls_tutorial = false
		timer += delta
	else:
		controls.visible = false
	


func _on_bg_music_finished() -> void:
	bg_music.play()
