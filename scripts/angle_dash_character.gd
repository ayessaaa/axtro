extends Area2D

@export var player = true

var direction = 0
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var trail_segment_scene: PackedScene
var current_segment: Node = null

func _ready() -> void:
	_start_new_segment()

func _process(delta: float) -> void:
	self.visible = Global.is_angle_dash
	if Global.dead:
		return
	if Global.angle_dash_animation_finished:
		if Input.is_action_just_pressed("shoot"):
			if direction == 0:
				direction = 1
			else:
				direction *= -1
			sprite_2d.rotation_degrees = 80 if direction > 0 else 0
			_start_new_segment()

		position.y += direction * Global.angle_dash_speed * delta

		if current_segment:
			current_segment.extend_to(global_position, delta)

func _start_new_segment() -> void:
	var seg = trail_segment_scene.instantiate()
	get_parent().add_child(seg)

	if current_segment:
		seg.start(current_segment.end_pos, direction)
	else:
		seg.start(global_position, direction)
	current_segment = seg
