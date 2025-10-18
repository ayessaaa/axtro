extends Node

@onready var gameover_screen = get_parent().get_node("GameoverBg")
@onready var death_sound = get_parent().get_node("DeathSound")
@onready var bg_music = get_parent().get_node("AngleDashBg")
@onready var selected_sound = get_parent().get_node("SelectedSound")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var angle_dash_character: Area2D = $AngleDashCharacter
@onready var label_2: Label = $Label2
@onready var score: Label = $Score

var playerScreen=preload("res://scenes/angle_dash_character.tscn")
var t = playerScreen.instantiate()

const SPIKES1 = preload("res://scenes/spikes_1.tscn")
const SPIKES2 = preload("res://scenes/spikes_2.tscn")
const SPIKES3 = preload("res://scenes/angle_dash_spikes.tscn")
const DIAMOND_SCENE = preload("res://scenes/diamond_scene.tscn")
const DIAMOND_SCENE2 = preload("res://scenes/diamond_scene_2.tscn")
const DIAMOND_MOVING_SCENE1 = preload("res://scenes/diamond_moving_scene_1.tscn")
const DIAMOND_MOVING_SCENE2 = preload("res://scenes/diamond_moving_scene_2.tscn")
@onready var obstacles_container = get_parent().get_node("Obstacles")

@onready var progress_area_animation = get_parent().get_node("ProgressArea/AnimationPlayer")

@onready var obstacles: Node = $Obstacles
@onready var tutorial_fade_out_animation: AnimationPlayer = $TutorialFadeOutAnimation

var timer = 4
#var obstacles_array = [SPIKES2, SPIKES3, DIAMOND_SCENE, DIAMOND_SCENE2, DIAMOND_MOVING_SCENE1, DIAMOND_MOVING_SCENE2]
#var obs_position_y_array = [117.0, 322.0, 0, 0, 0, 0]

var obstacles_array = [DIAMOND_MOVING_SCENE1, DIAMOND_MOVING_SCENE2]
var obs_position_y_array = [0, 0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.start_screen:
		return
	if !Global.selected_sound_played and Global.is_angle_dash:
		selected_sound.play()
		bg_music.play()
		Global.selected_sound_played = true
		
	label_2.visible = Global.is_angle_dash
	if Global.gameover_and_restart_angle_dash:
		animation_player.play("restart")
		Global.gameover_and_restart_angle_dash = false
		timer = 3
		Global.spike_speed = 250
		Global.angle_dash_speed = 250
		Global.direction = 0
		Global.angle_dash_score = 0
		Global.score = 0
		bg_music.play()
		
	if Global.dead and Global.is_angle_dash:
		if Input.is_action_pressed("enter"):
			Global.dead = false
			get_tree().reload_current_scene()
			Global.gameover_and_restart_angle_dash = true
			
	if Global.is_angle_dash and !Global.dead and Global.direction != 0:
		timer += delta
		if timer >= 4:
			timer = 0
			var random_int = randi_range(0, len(obstacles_array)-1)
			spawn_obstacle(obstacles_array[random_int], obs_position_y_array[random_int])
			print("spawn " + str(random_int))
		if Global.spike_speed > 450:
			Global.spike_speed += delta * 1.5
			Global.angle_dash_speed += delta * 1.5
		else:
			Global.spike_speed += delta * 3
			Global.angle_dash_speed += delta * 3
	
	
	if Global.free_regular_mode_objects:
		Global.next_mode_score = 0
		
	if !Global.marathon:
		score.text = "SCORE: "+str(Global.angle_dash_score)
		
	score.visible = !Global.marathon
	
	if Input.is_action_just_pressed("shoot") and Global.direction == 0 and Global.angle_dash_animation_finished:
		tutorial_fade_out_animation.play("fade_out")
		
	#print(Global.score)
	
	#if Global.angle_dash_score >= 10 and Global.score > 10 and Global.marathon:
		#print("PLAY BRUH")
		#progress_area_animation.play("next_mode_sr")
		


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Global.angle_dash_animation_finished = true

func spawn_obstacle(obs, position_y):
	var obstacle = obs.instantiate()
	obstacle.position = Vector2(2000, position_y)
	obstacles.add_child(obstacle)


func _on_angle_dash_bg_finished() -> void:
	bg_music.play()
