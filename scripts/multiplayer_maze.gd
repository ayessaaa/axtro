extends Node

@onready var bg: Sprite2D = $Bg
@onready var mm_character: CharacterBody2D = $MMCharacter
@onready var static_body_2d: StaticBody2D = $StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bg.visible = Global.is_multiplayer_maze
	mm_character.visible = Global.is_multiplayer_maze
	static_body_2d.visible = Global.is_multiplayer_maze
	if !Global.is_multiplayer_maze:
		return
