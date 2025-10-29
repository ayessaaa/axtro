extends Node

@onready var bg_back: Sprite2D = $BgBack
@onready var bg_1: Sprite2D = $Bg1
@onready var bg_2: Sprite2D = $Bg2
@onready var bg_3: Sprite2D = $Bg3
@onready var static_body_2d_1: StaticBody2D = $Walls/StaticBody2D1
@onready var mm_character: CharacterBody2D = $MMCharacter
@onready var mm_character_2: CharacterBody2D = $MMCharacter2
#@onready var mm_key_1: Area2D = $Keys/MMKey1
#@onready var mm_key_2: Area2D = $Keys/MMKey2
@onready var key_1: Sprite2D = $Keys/Key1
@onready var key_1_collected: Label = $Keys/Key1Collected
@onready var key_2: Sprite2D = $Keys/Key2
@onready var key_2_collected: Label = $Keys/Key2Collected

const KEY1 = preload("res://scenes/mm_key_1.tscn")
const KEY2 = preload("res://scenes/mm_key_2.tscn")
@onready var player_1_keys: Node = $Keys/Player1Keys
@onready var player_2_keys: Node = $Keys/Player2Keys
@onready var key_animation: AnimationPlayer = $Keys/KeyAnimation

var keys_position = {1:{"player1": [Vector2(509.0, 80.0)], "player2": [Vector2(610.0, 80.0)]}, 
						2:{"player1": [Vector2(155.0, 63.0)], "player2": [Vector2(994.0, 63.0)]}, 
						3:{"player1": [Vector2(300.0, 539.0)], "player2": [Vector2(789.0, 536.0)]}, }
var player_position = {1:{"player1": Vector2(80.0, 471.0), "player2": Vector2(1090.0, 425.0)}, 
						2:{"player1": Vector2(101.0, 590.0), "player2": Vector2(1061.0, 596.0)}, 
						3:{"player1": Vector2(525.0, 169.0), "player2": Vector2(601.0, 169.0)}}

var key_animation_done = false
@onready var line_1: Sprite2D = $Keys/Line1
@onready var line_2: Sprite2D = $Keys/Line2
@onready var keys_bg_1: Sprite2D = $Keys/Bg1
@onready var line_3: Sprite2D = $Keys/Line3
@onready var line_4: Sprite2D = $Keys/Line4
@onready var keys_bg_2: Sprite2D = $Keys/Bg2

@onready var animation_player: AnimationPlayer = $LevelNode/AnimationPlayer
@onready var spike_disabler: AnimationPlayer = $Spikes/SpikeDisabler
@onready var walls_disabler: AnimationPlayer = $Walls/WallsDisabler

@onready var level_number: Label = $LevelNode/LevelNumber
@onready var time: Label = $LevelNode/Time
@onready var deaths: Label = $LevelNode/Deaths
\

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.mm_keys_spawned = false
	Global.mm_keys1_collected = 0
	Global.mm_keys2_collected = 0
	mm_character.position = player_position[Global.mm_level]["player1"]
	mm_character_2.position = player_position[Global.mm_level]["player2"]
	spike_disabler.play("lvl_"+str(Global.mm_level))
	walls_disabler.play("lvl_"+str(Global.mm_level))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bg_1.visible = Global.is_multiplayer_maze && Global.mm_level == 1
	bg_2.visible = Global.is_multiplayer_maze && Global.mm_level == 2
	bg_3.visible = Global.is_multiplayer_maze && Global.mm_level == 3
	
	mm_character.visible = Global.is_multiplayer_maze
	mm_character_2.visible = Global.is_multiplayer_maze
	static_body_2d_1.visible = Global.is_multiplayer_maze
	bg_back.visible = Global.is_multiplayer_maze
	
	key_1.visible = Global.is_multiplayer_maze
	key_1_collected.visible = Global.is_multiplayer_maze
	key_2.visible = Global.is_multiplayer_maze
	key_2_collected.visible = Global.is_multiplayer_maze
	line_1.visible = Global.is_multiplayer_maze
	line_2.visible = Global.is_multiplayer_maze
	keys_bg_1.visible = Global.is_multiplayer_maze
	line_3.visible = Global.is_multiplayer_maze
	line_4.visible = Global.is_multiplayer_maze
	keys_bg_2.visible = Global.is_multiplayer_maze
	
	if !Global.is_multiplayer_maze:
		return
		
	if !Global.mm_keys_spawned:
		var key1 = KEY1.instantiate()
		key1.position = keys_position[Global.mm_level]["player1"][0]
		player_1_keys.add_child(key1)
		
		var key2 = KEY2.instantiate()
		key2.position = keys_position[Global.mm_level]["player2"][0]
		player_2_keys.add_child(key2)
		Global.mm_keys_spawned = true
		print("keys")
		
	if Global.mm_player1_gravity:
		if !key_animation_done:
			key_animation.play("player1")
			key_animation_done = true
		for key in player_2_keys.get_children():
			key.modulate = Color("ffffff64")
		for key in player_1_keys.get_children():
			key.modulate = Color("#ffffff")
	elif Global.mm_player2_gravity:
		if !key_animation_done:
			key_animation.play("player2")
			key_animation_done = true
		for key in player_1_keys.get_children():
			key.modulate = Color("ffffff64")
		for key in player_2_keys.get_children():
			key.modulate = Color("#ffffff")
	
	if Input.is_action_just_pressed("q"):
		Global.mm_player1_gravity = !Global.mm_player1_gravity
		Global.mm_player2_gravity = !Global.mm_player2_gravity
		key_animation_done = false
		
	if Input.is_action_just_pressed("esc"):
		Global.is_multiplayer_maze = false
		
	if Global.mm_keys1_collected == Global.mm_keys1_total && Global.mm_keys2_collected == Global.mm_keys2_total:
		if !Global.mm_pause:
			Global.mm_pause = true
			animation_player.play("level_completed")
			level_number.text = str(Global.mm_level)
			deaths.text = str(Global.mm_deaths)
		if Input.is_action_just_pressed("enter"):
			animation_player.play("fade_out")
			Global.mm_level += 1
			Global.mm_pause = false
			Global.mm_keys1_collected = 0
			Global.mm_keys2_collected = 0
			mm_character.position = player_position[Global.mm_level]["player1"]
			mm_character_2.position = player_position[Global.mm_level]["player2"]
			spike_disabler.play("lvl_"+str(Global.mm_level))
			walls_disabler.play("lvl_"+str(Global.mm_level))
			Global.mm_keys_spawned = false
			Global.mm_deaths = 0
			key_1_collected.text = str(Global.mm_keys1_collected) + "/" + str(Global.mm_keys1_total)
			key_2_collected.text = str(Global.mm_keys1_collected) + "/" + str(Global.mm_keys1_total)
		
	


func _on_spikes_collision_area_entered(area: Area2D) -> void:
	if Global.is_multiplayer_maze:
		Global.mm_keys1_collected = 0
		Global.mm_keys2_collected = 0
		Global.mm_deaths += 1
		get_tree().reload_current_scene()


func _on_spikes_collision_2_area_entered(area: Area2D) -> void:
	if Global.is_multiplayer_maze:
		Global.mm_keys1_collected = 0
		Global.mm_keys2_collected = 0
		Global.mm_deaths += 1
		get_tree().reload_current_scene()
