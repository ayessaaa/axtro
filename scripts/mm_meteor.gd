extends Area2D
#
@export var type = "mm_meteor"

@onready var player1 = get_parent().get_parent().get_node("MMCharacter")
@onready var player2 = get_parent().get_parent().get_node("MMCharacter2")

func _process(delta: float) -> void:
	visible = Global.is_multiplayer_maze
	if !Global.is_multiplayer_maze:
		return
	if Global.mm_player1_gravity:
		position = position.move_toward(player2.position, 50 * delta)
	elif Global.mm_player2_gravity:
		position = position.move_toward(player1.position, 50 * delta)


func _on_area_entered(area: Area2D) -> void:
	if !Global.is_multiplayer_maze:
		return
	if area.type == "player1" or area.type == "player2":
		print("meteor dead")
		get_tree().reload_current_scene()
