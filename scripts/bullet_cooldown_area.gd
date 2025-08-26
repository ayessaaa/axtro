extends Area2D

@export var available = true
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if available:
		sprite_2d.modulate = Color(1,1,1,1)
	else:
		sprite_2d.modulate = Color(1,1,1,0.5)
