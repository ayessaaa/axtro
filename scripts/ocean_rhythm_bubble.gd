extends Area2D

var speed = 120

@onready var a = get_parent().get_parent().get_node("Notes/a")
@onready var c = get_parent().get_parent().get_node("Notes/c")
@onready var d1 = get_parent().get_parent().get_node("Notes/d1")
@onready var d2 = get_parent().get_parent().get_node("Notes/d2")
@onready var f = get_parent().get_parent().get_node("Notes/f")
@onready var g = get_parent().get_parent().get_node("Notes/g")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var notes = [a, c, d1, f, g]

func _process(delta: float) -> void:
	if !Global.is_ocean_rhythm or Global.start_screen:
		return
	position.x -= speed * delta


func _on_area_entered(area: Area2D) -> void:
	if !Global.is_ocean_rhythm or Global.start_screen:
		return
	if area.type == "player":
		animation_player.play("fade_out")
		notes[randi_range(0, len(notes)-1)].play()
		#a.play()
		collision_shape_2d.disabled = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
