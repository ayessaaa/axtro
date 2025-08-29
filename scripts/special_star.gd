extends Area2D

@onready var score: Label = get_node("/root/Game/Score")
@export var type = "star"
@onready var powerup_sound = get_parent().get_node("PowerupSound")
@onready var powerup_animation = get_parent().get_parent().get_parent().get_node("PowerupLabel/AnimationPlayer")
@onready var powerup_name = get_parent().get_parent().get_parent().get_node("PowerupLabel/PowerupName")
@onready var powerup_sprite = get_parent().get_parent().get_parent().get_node("PowerupLabel/PowerupSprite")

@onready var double_points_icon_animation = get_parent().get_parent().get_parent().get_node("Powerups/DoublePointIcon/AnimationPlayer")
@onready var double_points_icon = get_parent().get_parent().get_parent().get_node("Powerups/DoublePointIcon/AnimationPlayer")

@onready var magnet_icon_animation = get_parent().get_parent().get_parent().get_node("Powerups/MagnetIcon/AnimationPlayer")
@onready var magnet_icon = get_parent().get_parent().get_parent().get_node("Powerups/MagnetIcon/AnimationPlayer")

var texture 

#var powerups_array = ["Shield", "DoublePoints", "Magnet", "SomethingAboutBullets"]
var powerups_array = ["Magnet"]

func _on_area_entered(area: Area2D) -> void:
	if area.player:
		powerup_sound.play()
		queue_free()
		var powerup = powerups_array[randi_range(0, len(powerups_array)-1)]
		print(powerup)
		match powerup:
			"Shield":
				texture = load("res://assets/IMG_1665.PNG")
				powerup_sprite.texture = texture
				Global.powerup = "Shield"
				powerup_name.text = "Shield"
				slow_down()
				powerup_animation.play("default")
				Global.powerup_animation_finish = false
				double_points_icon_animation.play("default")
				
			"DoublePoints":
				texture = load("res://assets/IMG_1663.PNG")
				powerup_sprite.texture = texture
				Global.double_points = true
				Global.powerup = "DoublePoints"
				powerup_name.text = "2x POINTS"
				slow_down()
				powerup_animation.play("default")
				Global.powerup_animation_finish = false
				double_points_icon.play("default")
				
			"Magnet":
				texture = load("res://assets/IMG_1676.PNG")
				powerup_sprite.texture = texture
				Global.magnet = true
				Global.powerup = "Magnet"
				powerup_name.text = "Magnet"
				slow_down()
				powerup_animation.play("default")
				Global.powerup_animation_finish = false
				magnet_icon.play("default")
				
				
func slow_down():
	Global.prev_meteor_speed = Global.meteor_speed
	Global.meteor_speed = 0
	Global.speed = Global.speed / 10.0
	Global.object_speed = Global.object_speed / 10.0
	
		
