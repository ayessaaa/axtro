extends Area2D

@export var player = false

var direction := -1
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var trail_segment_scene: PackedScene
var current_segment: Node = null

func _ready() -> void:
	_start_new_segment()

func _process(delta: float) -> void:
	if Global.angle_dash_animation_finished:
		# Flip direction
		if Input.is_action_just_pressed("shoot"):
			direction *= -1
			sprite_2d.rotation_degrees = 80 if direction > 0 else 0
			_start_new_segment()

		# Move character vertically
		position.y += direction * Global.angle_dash_speed * delta

		# Extend current trail
		if current_segment:
			current_segment.extend_to(global_position, delta)

func _start_new_segment() -> void:
	var seg = trail_segment_scene.instantiate()
	get_parent().add_child(seg)

	# If there was a previous segment, snap to its end
	if current_segment:
		seg.start(current_segment.end_pos, direction)
	else:
		seg.start(global_position, direction)
	current_segment = seg
