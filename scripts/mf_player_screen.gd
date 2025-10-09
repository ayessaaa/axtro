extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Global.is_mecha_flight_player_screen:
		return
	if Input.is_action_pressed("move_right"):
		animation_player.play("two_players")
	if Input.is_action_pressed("move_left"):
		animation_player.play("one_player")
