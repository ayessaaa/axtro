extends Area2D

@onready var score: Label = get_node("/root/Game/Score")
@export var type = "star"
@onready var powerup_sound = get_parent().get_node("PowerupSound")
@onready var powerup_animation = get_parent().get_parent().get_parent().get_node("PowerupLabel/AnimationPlayer")
@onready var powerup_name = get_parent().get_parent().get_parent().get_node("PowerupLabel/PowerupName")
@onready var powerup_sprite = get_parent().get_parent().get_parent().get_node("PowerupLabel/PowerupSprite")

var texture 

#var powerups_array = ["Shield", "DoublePoints", "Magnet", "SomethingAboutBullets"]
var powerups_array = ["Shield", "DoublePoints"]

func _on_area_entered(area: Area2D) -> void:
	if area.player:
		powerup_sound.play()
		queue_free()
		var powerup = powerups_array[randi_range(0, len(powerups_array)-1)]
		print(powerup)
		match powerup:
			"Shield":
				texture = load("res://assets/IMG_1645.PNG")
				powerup_sprite.texture = texture
				Global.powerup = "Shield"
				powerup_name.text = "Shield"
				slow_down()
				powerup_animation.play("default")
				Global.powerup_animation_finish = false
			"DoublePoints":
				texture = load("res://assets/IMG_1554.PNG")
				powerup_sprite.texture = texture
				Global.double_points = true
				Global.powerup = "DoublePoints"
				powerup_name.text = "2x POINTS"
				slow_down()
				powerup_animation.play("default")
				Global.powerup_animation_finish = false
				
				
func slow_down():
	Global.meteor_speed = 0
	Global.speed = Global.speed / 10.0
	Global.object_speed = Global.object_speed / 10.0
	
		
