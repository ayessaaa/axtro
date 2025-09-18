extends Area2D

@export var type = "enemy_rocket"

@onready var character_animation = get_parent().get_parent().get_node("SpaceRayCharacter/SpaceRayCharacterArea/AnimationPlayer")
@onready var progress_bar: ProgressBar = $Sprite2D/ProgressBar
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

var speed = 0
var health = 100

func _ready() -> void:
	speed = randf_range(4, 7)

func _process(delta: float) -> void:
	visible = Global.is_space_ray
	if !Global.is_space_ray or Global.dead:
		return
	if health < 100:
		progress_bar.value = health
		progress_bar.visible = true
	else:
		progress_bar.visible = false
	
		
	position.x -= speed


func _on_area_entered(area: Area2D) -> void:
	if area.type == "player":
		if Global.space_ray_hearts > 0:
			Global.space_ray_hearts -= 1
			character_animation.play("hurt")
			queue_free()
	if area.type == "bullet":
		queue_free()
	if area.type == "laser":
		health -= 10
