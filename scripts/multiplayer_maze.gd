extends Node

@onready var bg_back: Sprite2D = $BgBack
@onready var bg: Sprite2D = $Bg
@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var mm_character: CharacterBody2D = $MMCharacter
@onready var mm_character_2: CharacterBody2D = $MMCharacter2
@onready var label: Label = $Label
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
	if !Global.is_multiplayer_maze:
		return
	
	if Input.is_action_just_pressed("q"):
		Global.mm_player1_gravity = !Global.mm_player1_gravity
		Global.mm_player2_gravity = !Global.mm_player2_gravity
		
	if Input.is_action_just_pressed("esc"):
		Global.is_multiplayer_maze = false
		
	


func _on_spikes_collision_area_entered(area: Area2D) -> void:
	get_tree().reload_current_scene()


func _on_mm_meteor_area_entered(area: Area2D) -> void:
	print("collide")
	if area.type == "player1":
		get_tree().reload_current_scene()
