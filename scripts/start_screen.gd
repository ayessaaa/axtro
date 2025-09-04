extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var selector: AnimationPlayer = $Selector

@onready var progress_area = get_parent().get_node("ProgressArea/AnimationPlayer")
@onready var angle_dash = get_parent().get_node("AngleDash/AnimationPlayer")
@onready var switch_sound = get_parent().get_node("SwitchGamemode")
@onready var bg_player: AnimationPlayer = $BgPlayer

var selected_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.start_screen:
		animation_player.play("fade_in")
	else:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_down") and selected_index < 2:
		selected_index += 1
		switch_sound.play()
		match selected_index:
			1:
				selector.play("down_mecha")
			2:
				
				selector.play("down_angle")
				bg_player.play("angle_dash")
	if Input.is_action_just_pressed("move_up") and selected_index > 0:
		selected_index -= 1
		switch_sound.play()
		match selected_index:
			0:
				selector.play("up_play")
			1:
				selector.play("up_mecha")
				bg_player.play("mecha_flight")
				
	if Input.is_action_just_pressed("enter"):
		match selected_index:
			0:
				Global.start_screen = false
				Global.marathon = true
				Global.is_angle_dash = false
				Global.meteor_speed = 4
				Global.spawn_interval = 1.5
				Global.object_speed = 2
				Global.speed = 400
				queue_free()
			1:
				Global.start_screen = false
				Global.marathon = false
				Global.is_angle_dash = false
				Global.meteor_speed = 4
				Global.spawn_interval = 1.5
				Global.object_speed = 2
				Global.speed = 400
				queue_free()
			2:
				Global.start_screen = false
				Global.is_angle_dash = true
				Global.marathon = false
				angle_dash.play("angle_dash_selected")
				queue_free()
				
			
