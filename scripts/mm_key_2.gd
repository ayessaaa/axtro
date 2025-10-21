extends Area2D

@export var type = "key2"
@onready var pickup_animation: AnimationPlayer = $PickupAnimation
@onready var key_sound: AudioStreamPlayer2D = $KeySound
@onready var key_2_collected = get_parent().get_parent().get_node("Key2Collected")

func _on_area_entered(area: Area2D) -> void:
	if area.type == "player2" and Global.mm_player2_gravity:
		print("pickup")
		pickup_animation.play("pick_up")
		key_sound.play()
		Global.mm_keys2_collected += 1
		key_2_collected.text = str(Global.mm_keys2_collected) + "/" + str(Global.mm_keys2_total)

func _on_pickup_animation_animation_finished(anim_name: StringName) -> void:
	queue_free()
