extends Node

@onready var bg_back: Sprite2D = $BgBack
@onready var bg: Sprite2D = $Bg
@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var mm_character: CharacterBody2D = $MMCharacter
@onready var mm_character_2: CharacterBody2D = $MMCharacter2
@onready var label: Label = $Label
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3
#@onready var mm_key_1: Area2D = $Keys/MMKey1
#@onready var mm_key_2: Area2D = $Keys/MMKey2
@onready var key_1: Sprite2D = $Keys/Key1
@onready var key_1_collected: Label = $Keys/Key1Collected
@onready var key_1_text: Label = $Keys/Key1Text
@onready var key_2: Sprite2D = $Keys/Key2
@onready var key_2_collected: Label = $Keys/Key2Collected
@onready var key_2_text: Label = $Keys/Key2Text

const KEY1 = preload("res://scenes/mm_key_1.tscn")
const KEY2 = preload("res://scenes/mm_key_2.tscn")
@onready var player_1_keys: Node = $Keys/Player1Keys
@onready var player_2_keys: Node = $Keys/Player2Keys

var keys_position = {1:{"player1": [Vector2(524.0, 114.0)], "player2": [Vector2(633.0, 114.0)]}}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.mm_keys_spawned = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.visible = Global.is_multiplayer_maze
	label_2.visible = Global.is_multiplayer_maze
	label_3.visible = Global.is_multiplayer_maze
	bg.visible = Global.is_multiplayer_maze
	mm_character.visible = Global.is_multiplayer_maze
	mm_character_2.visible = Global.is_multiplayer_maze
	static_body_2d.visible = Global.is_multiplayer_maze
	bg_back.visible = Global.is_multiplayer_maze
	
	key_1.visible = Global.is_multiplayer_maze
	key_1_collected.visible = Global.is_multiplayer_maze
	key_1_text.visible = Global.is_multiplayer_maze
	key_2.visible = Global.is_multiplayer_maze
	key_2_collected.visible = Global.is_multiplayer_maze
	key_2_text.visible = Global.is_multiplayer_maze
	
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
		
	if Global.mm_player1_gravity:
		for key in player_2_keys.get_children():
			key.modulate = Color("ffffff64")
		for key in player_1_keys.get_children():
			key.modulate = Color("#ffffff")
	elif Global.mm_player2_gravity:
		for key in player_1_keys.get_children():
			key.modulate = Color("ffffff64")
		for key in player_2_keys.get_children():
			key.modulate = Color("#ffffff")
	
	if Input.is_action_just_pressed("q"):
		Global.mm_player1_gravity = !Global.mm_player1_gravity
		Global.mm_player2_gravity = !Global.mm_player2_gravity
		
	if Input.is_action_just_pressed("esc"):
		Global.is_multiplayer_maze = false
		
	


func _on_spikes_collision_area_entered(area: Area2D) -> void:
	get_tree().reload_current_scene()
