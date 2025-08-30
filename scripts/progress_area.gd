extends Area2D

@onready var score: Label = $Score

func  _process(delta: float) -> void:
	score.text = str(Global.score) + "/10"
#AnimationMixer: 'RESET', couldn't resolve track:  '../Sprite2D3:modulate'. This warning can be disabled in Project Settings.


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if Global.is_angle_dash:
		Global.free_regular_mode_objects = true
