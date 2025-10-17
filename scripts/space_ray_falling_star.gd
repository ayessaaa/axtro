extends CharacterBody2D

@export var gravity: float = 200.0
@export var jump_force: float = 200.0
@onready var animation_player: AnimationPlayer = $SpaceRayFallingStarArea/AnimationPlayer
@onready var falling_star_sound = get_parent().get_parent().get_node("SoundEffects/FallingStarSound")

var pickup = false

func _ready():
	velocity.y = -jump_force

func _physics_process(delta):
	visible = Global.is_space_ray
	if !Global.is_space_ray or Global.dead:
		return
	if Global.space_ray_stop:
		return
	if not pickup:
		velocity.y += gravity * delta
		move_and_slide()


func _on_space_ray_falling_star_area_area_entered(area: Area2D) -> void:
	if area.type == "player":
		animation_player.play("pick_up")
		falling_star_sound.play()
		pickup = true
