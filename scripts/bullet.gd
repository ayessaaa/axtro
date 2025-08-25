extends Area2D

var speed = 2
@export var player = false
@onready var bullet_sound: AudioStreamPlayer2D = $BulletSound
@onready var meteor_explosion_sound = get_parent().get_node("MeteorExplosionSound")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bullet_sound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * delta * 200


func _on_area_entered(area: Area2D) -> void:
	if area.type == "meteor":
		meteor_explosion_sound.play()
		queue_free()
		
