extends Area2D

@onready var polygon_2d: Polygon2D = $Polygon2D

@export var scroll_speed: float = 0.2  # how fast it scrolls
var uv_offset: float = 0.0

func _process(delta: float) -> void:
	uv_offset += scroll_speed * delta

	polygon_2d.uv = PackedVector2Array([
		Vector2(0.0 + uv_offset, 0.0),
		Vector2(0.0 + uv_offset, 1.0),
		Vector2(1.0 + uv_offset, 1.0),
		Vector2(1.0 + uv_offset, 0.0),
	])
