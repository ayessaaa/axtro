extends Area2D

@export var type = "key1"
@onready var pickup_animation: AnimationPlayer = $PickupAnimation
@onready var key_sound: AudioStreamPlayer2D = $KeySound
@onready var key_1_collected = get_parent().get_parent().get_node("Key1Collected")


func _on_area_entered(area: Area2D) -> void:
	if area.type == "player1" and Global.mm_player1_gravity:
		print("pickup")
		pickup_animation.play("pick_up")
		key_sound.play()
		Global.mm_keys1_collected += 1
		key_1_collected.text = str(Global.mm_keys1_collected) + "/" + str(Global.mm_keys1_total)

func _on_pickup_animation_animation_finished(anim_name: StringName) -> void:
	queue_free()
