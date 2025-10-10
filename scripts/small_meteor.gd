extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var type = "meteor"
@export var small_meteor_fall = false

const LINES = preload("res://scenes/line.tscn")
@onready var lines_container = get_parent().get_node("Lines")

const STAR = preload("res://scenes/star.tscn")
const SHIBA_STAR = preload("res://scenes/shiba_star.tscn")
@onready var stars_container = get_parent().get_node("Stars")
var star

var line: Sprite2D

@onready var death_sound = get_parent().get_parent().get_node("DeathSound")

const GRAVITY = 800

@onready var gameover_screen = get_parent().get_parent().get_node("GameoverBg")

var random_speed = randf_range(1, 1.3)

@onready var shield_pop_sound: AudioStreamPlayer2D = get_parent().get_parent().get_node("Powerups/ShieldPopSound")
@onready var meteor_explosion_sound = get_parent().get_parent().get_node("Bullets/MeteorExplosionSound")

var meteor_killed_from_shield = false

@onready var character_sprite = get_parent().get_parent().get_node("Character/AnimatedSprite2D")
@onready var character_animation = get_parent().get_parent().get_node("Character/AnimationPlayer")
@onready var character_line1 = get_parent().get_parent().get_node("Character/Line")
@onready var character_line2 = get_parent().get_parent().get_node("Character/Line2")
@onready var character2_sprite = get_parent().get_parent().get_node("Character2/AnimatedSprite2D")
@onready var character2_animation = get_parent().get_parent().get_node("Character2/AnimationPlayer")
@onready var character2_line1 = get_parent().get_parent().get_node("Character2/Line3")
@onready var character2_line2 = get_parent().get_parent().get_node("Character2/Line4")

@onready var heart1 = get_parent().get_parent().get_node("Hearts/Sprite2D")
@onready var heart2 = get_parent().get_parent().get_node("Hearts/Sprite2D2")
@onready var hurt_sound = get_parent().get_parent().get_node("Hearts/HurtSound")
@onready var collision_polygon_2d: CollisionPolygon2D = $SmallMeteorArea2d/CollisionPolygon2D

@onready var player1_heart1 = get_parent().get_parent().get_node("TwoPlayers/Player1/Heart")
@onready var player1_heart2 = get_parent().get_parent().get_node("TwoPlayers/Player1/Heart2")
@onready var player2_heart1 = get_parent().get_parent().get_node("TwoPlayers/Player2/Heart")
@onready var player2_heart2 = get_parent().get_parent().get_node("TwoPlayers/Player2/Heart2")

func _ready() -> void:
	line = LINES.instantiate()
	line.position = Vector2(position.x, position.y-1200)
	line.object = self
	lines_container.add_child(line)

func _physics_process(delta: float) -> void:
	if !Global.marathon and !Global.is_mecha_flight:
		return
	if Global.dead or Global.is_space_ray:
		return
	#speed += 1 * delta
	#if Global.free_regular_mode_objects or Global.start_screen:
		#return
	
	if small_meteor_fall:
		velocity.y += GRAVITY * delta
		move_and_slide()
		rotate(0.2*delta*50)
		if position.y > 1000:
			queue_free()
	else:
		position.x -= Global.meteor_speed * delta * 70 * random_speed


func _on_small_meteor_area_2d_area_entered(area: Area2D) -> void:
	if meteor_killed_from_shield:
		return
	if area.player:
		collision_polygon_2d.disabled = true
		if small_meteor_fall:
			return
		if Global.shield:
			if area.player_number == 1:
				character_animation.play("shield_fade_out")
			else:
				character2_animation.play("shield_fade_out")
			Global.shield = false
			shield_pop_sound.play()
			meteor_explosion_sound.play()
			small_meteor_fall = true
			if line and line.is_inside_tree():
				line.queue_free()
			return
			
#		if player number 1
		if area.player_number == 1:
#			if singleplayer
			if Global.mecha_flight_player == 1:
				character_animation.play("hurt")
				Global.hearts -= 1
				if Global.hearts <= 0:
					Global.dead = true
					death_sound.play()
					Global.controls_tutorial = false
					gameover_screen.play_animation("default")
					heart1.modulate = Color(1.0, 1.0, 1.0, 0.5)
				else:
					heart2.modulate = Color(1.0, 1.0, 1.0, 0.5)
#			if multiplayer
			else:
				Global.mecha_flight_player1_hearts -= 1
				if Global.mecha_flight_player1_hearts <= 0:
					if Global.mecha_flight_player2_hearts <= 0:
						gameover_screen.play_animation("default")
						Global.dead = true
						death_sound.play()
						Global.controls_tutorial = false
					player1_heart1.modulate = Color(1.0, 1.0, 1.0, 0.5)
					character_animation.play("dead")
					character_line1.queue_free()
					character_line2.queue_free()
					character_sprite.stop()
				else:
					player1_heart2.modulate = Color(1.0, 1.0, 1.0, 0.5)
					character_animation.play("hurt")
					
#		if player number 2
		else:
			Global.mecha_flight_player2_hearts -= 1
			if Global.mecha_flight_player2_hearts <= 0:
				if Global.mecha_flight_player1_hearts <= 0:
					gameover_screen.play_animation("default")
					Global.dead = true
					death_sound.play()
					Global.controls_tutorial = false
				player2_heart1.modulate = Color(1.0, 1.0, 1.0, 0.5)
				character2_animation.play("dead")
				character2_line1.queue_free()
				character2_line2.queue_free()
				character2_sprite.stop()
			else:
				player2_heart2.modulate = Color(1.0, 1.0, 1.0, 0.5)
				character2_animation.play("hurt")
				
		hurt_sound.play()
		small_meteor_fall = true
		if line and line.is_inside_tree():
			line.queue_free()
	else:
		if !small_meteor_fall:
			if Input.is_action_pressed("move_up") and Input.is_action_pressed("move_down"):
				star = SHIBA_STAR.instantiate()
			else:
				star = STAR.instantiate()
			star.position = position
			stars_container.add_child(star)
		small_meteor_fall = true
		
		if line and line.is_inside_tree():
			line.queue_free()
