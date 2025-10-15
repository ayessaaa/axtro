extends Area2D
@export var type = "medkit"

@onready var coin_sound = get_parent().get_node("CoinSound")
@onready var character = get_parent().get_parent().get_parent().get_node("Character")
@onready var character2 = get_parent().get_parent().get_parent().get_node("Character2")
@onready var progress_animation = get_parent().get_parent().get_parent().get_node("ProgressArea/AnimationPlayer")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player_number

func  _ready() -> void:
	animation_player.play("disappearing")

func _on_area_entered(area: Area2D) -> void:
	if area.player:
		coin_sound.play()
		animation_player.play("pick_up")
			
func _process(delta: float) -> void:
	if Global.mecha_flight_player != 2:
		return
	if Global.start_screen or Global.is_space_ray:
		return
	#if Global.free_regular_mode_objects:
		#queue_free()
		#return
	if Global.magnet:
		position = position.move_toward(character.position, 400 * delta)
	if Global.mecha_flight_player == 2:
		if Global.magnet_player1 and player_number == 1:
			position = position.move_toward(character.position, 400 * delta)
		if Global.magnet_player2 and player_number == 2:
			position = position.move_toward(character2.position, 400 * delta)
	if Global.meteor_speed == 0:
		animation_player.pause()
	else:
		animation_player.play()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
