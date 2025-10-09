extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var ship_p_1: AnimatedSprite2D = $ShipP1
@onready var ship_2p_2: AnimatedSprite2D = $Ship2P2
@onready var ship_1p_2: AnimatedSprite2D = $Ship1P2

@onready var bg: Sprite2D = $Bg
@onready var line_2: Sprite2D = $Line2
@onready var line_3: Sprite2D = $Line3
@onready var line: Sprite2D = $Line
@onready var cloud: Sprite2D = $Cloud
@onready var star: Sprite2D = $Star
@onready var axtro: AnimatedSprite2D = $Axtro
@onready var mecha_flight: Label = $MechaFlight
@onready var select_line: Sprite2D = $SelectLine
@onready var select_line_2: Sprite2D = $SelectLine2
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var one_player: Label = $OnePlayer
@onready var two_player: Label = $TwoPlayer
@onready var controls_label: Label = $ControlsLabel

var players = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bg.visible = Global.is_mecha_flight_player_screen
	line_2.visible = Global.is_mecha_flight_player_screen
	line_3.visible = Global.is_mecha_flight_player_screen
	line.visible = Global.is_mecha_flight_player_screen
	cloud.visible = Global.is_mecha_flight_player_screen
	star.visible = Global.is_mecha_flight_player_screen
	axtro.visible = Global.is_mecha_flight_player_screen
	mecha_flight.visible = Global.is_mecha_flight_player_screen
	select_line.visible = Global.is_mecha_flight_player_screen
	select_line_2.visible = Global.is_mecha_flight_player_screen
	progress_bar.visible = Global.is_mecha_flight_player_screen
	one_player.visible = Global.is_mecha_flight_player_screen
	two_player.visible = Global.is_mecha_flight_player_screen
	controls_label.visible = Global.is_mecha_flight_player_screen
	ship_p_1.visible = Global.is_mecha_flight_player_screen
	ship_2p_2.visible = Global.is_mecha_flight_player_screen
	ship_1p_2.visible = Global.is_mecha_flight_player_screen
	
	if !Global.is_mecha_flight_player_screen:
		return
	if Input.is_action_pressed("move_right") and players == 1:
		animation_player.play("two_players")
		ship_p_1.stop()
		ship_2p_2.play("default")
		ship_1p_2.play('default')
		players = 2
		
	if Input.is_action_pressed("move_left") and players == 2:
		animation_player.play("one_player")
		ship_p_1.play("default")
		ship_2p_2.stop()
		ship_1p_2.stop()
		players = 1
		
	if Input.is_action_pressed("enter") and Global.mecha_flight_animation_done:
		Global.mecha_flight_player = players
		Global.is_mecha_flight = true
		if players == 1:
			animation_player_2.play("fade_out")
			ship_p_1.stop()
		else:
			animation_player_2.play("fade_out_p2")
			ship_2p_2.stop()
			ship_1p_2.stop()
		
		#queue_free()
		
		


func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	Global.is_mecha_flight_player_screen = false
	Global.mecha_flight_animation_done = false
	queue_free()
