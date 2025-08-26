extends Area2D

@onready var score_label: Label = $Score
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score_label.text = str(Global.score)
	
func play_animation(animation):
	animation_player.play("dark_screen")
	animation_player.queue("default")
	animation_player.queue("text_size")
