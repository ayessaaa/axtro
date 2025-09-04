extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var selector: AnimationPlayer = $Selector

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
		match selected_index:
			1:
				selector.play("down_mecha")
			2:
				selector.play("down_angle")
	if Input.is_action_just_pressed("move_up") and selected_index > 0:
		selected_index -= 1
		match selected_index:
			0:
				selector.play("up_play")
			1:
				selector.play("up_mecha")
				
	if Input.is_action_just_pressed("enter"):
		match selected_index:
			0:
				Global.start_screen = false
				print("enter")
				queue_free()
			
