extends Area2D

@onready var score_label: Label = $Score
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.is_space_ray:
		score_label.text = str(int(Global.space_ray_score))
	else:
		if Global.marathon:
			score_label.text = str(Global.angle_dash_score)
		elif Global.is_mecha_flight and Global.mecha_flight_player == 2:
			score_label.text = str(Global.mecha_flight_player1_score + Global.mecha_flight_player2_score)
		else:
			score_label.text = str(Global.score)
	
func play_animation(animation):
	animation_player.play("dark_screen")
	animation_player.queue("default")
	animation_player.queue("text_size")
