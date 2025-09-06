extends Node
@onready var bg: Sprite2D = $Bg

@onready var selected_sound = get_parent().get_node("SelectedSound")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bg.visible = Global.is_space_ray
	if !Global.selected_sound_played and Global.is_space_ray:
		selected_sound.play()
		Global.selected_sound_played = true
