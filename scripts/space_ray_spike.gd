extends CharacterBody2D

var speed = 100

func _ready() -> void:
	velocity = Vector2(-200, -200).normalized() * speed
	
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity*delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		print("collide")


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
