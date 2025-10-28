extends Node

@onready var bg_back: Sprite2D = $BgBack
@onready var bg_1: Sprite2D = $Bg1
@onready var bg_2: Sprite2D = $Bg2
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

var keys_position = {1:{"player1": [Vector2(509.0, 80.0)], "player2": [Vector2(610.0, 80.0)]}}

var key_animation_done = false
@onready var line_1: Sprite2D = $Keys/Line1
@onready var line_2: Sprite2D = $Keys/Line2
@onready var keys_bg_1: Sprite2D = $Keys/Bg1
@onready var line_3: Sprite2D = $Keys/Line3
@onready var line_4: Sprite2D = $Keys/Line4
@onready var keys_bg_2: Sprite2D = $Keys/Bg2

@onready var animation_player: AnimationPlayer = $LevelNode/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.mm_keys_spawned = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bg_1.visible = Global.is_multiplayer_maze && Global.mm_level == 1
	bg_2.visible = Global.is_multiplayer_maze && Global.mm_level == 2
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
		
	if Global.mm_keys1_collected == Global.mm_keys1_total && Global.mm_keys2_collected == Global.mm_keys2_total && !Global.mm_pause:
		Global.mm_pause = true
		animation_player.play("level_completed")
		
	


func _on_spikes_collision_area_entered(area: Area2D) -> void:
	if Global.is_multiplayer_maze:
		Global.mm_keys1_collected = 0
		Global.mm_keys2_collected = 0
		get_tree().reload_current_scene()
