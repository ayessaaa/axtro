extends Node

@onready var gameover_screen = get_parent().get_node("GameoverBg")
@onready var death_sound = get_parent().get_node("DeathSound")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var angle_dash_character: Area2D = $AngleDashCharacter

var playerScreen=preload("res://scenes/angle_dash_character.tscn")
var t = playerScreen.instantiate()

const SPIKES1 = preload("res://scenes/spikes_1.tscn")
const SPIKES2 = preload("res://scenes/spikes_2.tscn")
const SPIKES3 = preload("res://scenes/angle_dash_spikes.tscn")
@onready var obstacles_container = get_parent().get_node("Obstacles")

@onready var obstacles: Node = $Obstacles

var timer = -5
var obstacles_array = [SPIKES2, SPIKES3]
var obs_position_y_array = [117.0, 325.0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.gameover_and_restart_angle_dash:
		animation_player.play("restart")
		Global.gameover_and_restart_angle_dash = false
	if Global.dead and Global.is_angle_dash:
		if Input.is_action_pressed("shoot"):
			Global.dead = false
			#if t: 
				#queue_free()
				#add_child(t)
			get_tree().reload_current_scene()
			Global.gameover_and_restart_angle_dash = true
			#angle_dash_character.position = Vector2(0,0)
			
	if Global.is_angle_dash and !Global.dead:
		timer += delta
		if timer >= 5:
			timer = 0
			var random_int = randi_range(0, len(obstacles_array)-1)
			spawn_obstacle(obstacles_array[random_int], obs_position_y_array[random_int])
			print("spawn " + str(random_int))
		


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Global.angle_dash_animation_finished = true

func spawn_obstacle(obs, position_y):
	var obstacle = obs.instantiate()
	obstacle.position = Vector2(2000, position_y)
	obstacles.add_child(obstacle)
