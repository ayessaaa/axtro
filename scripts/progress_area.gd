extends Area2D

@onready var score: Label = $Score

@onready var progress_area = get_parent().get_node("ProgressArea/AnimationPlayer")
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var score_label: Label = $Score
@onready var real_score: Label = $RealScore
@onready var next_mode: Label = $Text


func  _process(delta: float) -> void:
	score_label.visible = Global.marathon
	sprite_2d.visible = Global.marathon
	next_mode.visible = Global.marathon
	real_score.visible = Global.marathon
	
	if Global.start_screen or !Global.marathon:
		return
	
	if Global.is_angle_dash and Global.progress_area_displayed and Global.marathon:
		real_score.text = "SCORE: "+str(Global.score+Global.angle_dash_score)
		score.text = str(Global.angle_dash_score) + "/10"
		sprite_2d.texture = load("res://assets/angle_dash_assets/IMG_1686.PNG")
	else:
		score.text = str(Global.next_mode_score) + "/10"


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if Global.is_angle_dash:
		
		Global.free_regular_mode_objects = true
		if !Global.progress_area_displayed:
			sprite_2d.texture = load("res://assets/angle_dash_assets/IMG_1686.PNG")
			progress_area.play("RESET")
			progress_area.queue("fade_in_angle_dash")
			print("finished")
			Global.progress_area_displayed = true
