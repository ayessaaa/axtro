extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var selector: AnimationPlayer = $Selector

@onready var progress_area = get_parent().get_node("ProgressArea/AnimationPlayer")
@onready var angle_dash = get_parent().get_node("AngleDash/AnimationPlayer")
@onready var space_ray = get_parent().get_node("SpaceRay/AnimationPlayer")
@onready var ocean_rhythm = get_parent().get_node("OceanRhythm/AnimationPlayer")
@onready var ocean_rhythm_text = get_parent().get_node("OceanRhythm/TextAnimation")
@onready var switch_sound = get_parent().get_node("SwitchGamemode")
@onready var bg_player: AnimationPlayer = $BgPlayer
@onready var paper_bg_animation = get_node("PaperBg/Lines")

@onready var bg_music = get_parent().get_node("BgMusic")
@onready var angle_dash_music = get_parent().get_node("AngleDashMusic")
@onready var space_ray_music = get_parent().get_node("SpaceRayMusic")
@onready var ocean_rhythm_music = get_parent().get_node("OceanRhythmMusic")

@onready var wip: Label = $Label7

#@onready var paper_bg: Area2D = $PaperBg

var selected_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.start_screen:
		animation_player.play("fade_in")
	else:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("move_down") and selected_index < 4:
		selected_index += 1
		switch_sound.play()
		match selected_index:
			1:
				selector.play("down_mecha")
				wip.visible = false
			2:
				
				selector.play("down_angle")
				bg_player.play("angle_dash")
				angle_dash_music.play()
				bg_music.stop()
				space_ray_music.stop()
				wip.visible = false
			3:
				selector.play("down_space_ray")
				paper_bg_animation.play("space_ray")
				bg_player.play("space_ray")
				bg_music.stop()
				angle_dash_music.stop()
				space_ray_music.play()
				#bg_player.play("angle_dash")
				wip.visible = true
			4:
				selector.play("down_ocean_rhythm")
				#paper_bg_animation.play("space_ray")
				bg_player.play("ocean_rhythm")
				ocean_rhythm_music.play()
				bg_music.stop()
				angle_dash_music.stop()
				space_ray_music.stop()
				wip.visible = false
				
	if Input.is_action_just_pressed("move_up") and selected_index > 0:
		selected_index -= 1
		switch_sound.play()
		match selected_index:
			0:
				selector.play("up_play")
				wip.visible = false
			1:
				selector.play("up_mecha")
				bg_player.play("mecha_flight")
				bg_music.play()
				angle_dash_music.stop()
				space_ray_music.stop()
				wip.visible = false
			2:
				selector.play("up_angle")
				paper_bg_animation.play("default")
				bg_player.play("up_angle_dash")
				angle_dash_music.play()
				bg_music.stop()
				space_ray_music.stop()
				wip.visible = false
			3:
				selector.play("up_space_ray")
				paper_bg_animation.play("default")
				bg_player.play("up_space_ray")
				angle_dash_music.stop()
				bg_music.stop()
				space_ray_music.play()
				ocean_rhythm_music.stop()
				wip.visible = true

				
	if Input.is_action_just_pressed("enter"):
		
		match selected_index:
			0:
				Global.start_screen = false
				Global.marathon = true
				Global.is_angle_dash = false
				Global.is_ocean_rhythm = false
				Global.is_space_ray = false
				Global.meteor_speed = 4
				Global.spawn_interval = 1.5
				Global.object_speed = 2
				Global.speed = 400
				Global.selected_sound_played = false
				Global.hearts = 2
				Global.is_mecha_flight_player_screen = false
				queue_free()
			1:
				Global.start_screen = false
				Global.marathon = false
				Global.is_angle_dash = false
				Global.is_ocean_rhythm = false
				Global.is_space_ray = false
				Global.meteor_speed = 4
				Global.spawn_interval = 1.5
				Global.object_speed = 2
				Global.speed = 400
				Global.is_mecha_flight = false
				Global.is_mecha_flight_player_screen = true
				Global.selected_sound_played = false
				animation_player.play("mf_fade_out")
			2:
				Global.start_screen = false
				Global.is_angle_dash = true
				Global.marathon = false
				Global.is_ocean_rhythm = false
				Global.is_space_ray = false
				angle_dash.play("angle_dash_selected")
				Global.selected_sound_played = false
				angle_dash_music.stop()
				Global.is_mecha_flight_player_screen = false
				queue_free()
			3:
				Global.start_screen = false
				Global.is_angle_dash = false
				Global.marathon = false
				Global.is_space_ray = true
				Global.is_ocean_rhythm = false
				space_ray.play("fade_in")
				Global.selected_sound_played = false
				#bg_music.stop()
				#angle_dash.play("angle_dash_selected")
				Global.is_mecha_flight_player_screen = false
				queue_free()
				
			4:
				Global.start_screen = false
				Global.is_angle_dash = false
				Global.marathon = false
				Global.is_space_ray = false
				Global.is_ocean_rhythm = true
				ocean_rhythm.play("ocean_rhythm_selected")
				Global.selected_sound_played = false
				ocean_rhythm_text.play("text_animation")
				Global.is_mecha_flight_player_screen = false
				#bg_music.stop()
				#angle_dash.play("angle_dash_selected")
				queue_free()
				
			


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if Global.is_mecha_flight_player_screen:
		queue_free()
