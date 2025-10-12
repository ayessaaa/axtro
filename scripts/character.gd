extends CharacterBody2D

@export var player = true
@export var type = "player"
@export var player_number = 1
var screen_size

@onready var animated_sprite_2d: AnimatedSprite2D = $CharacterArea/AnimatedSprite2D
@onready var bullet_cooldown_area: Area2D = $"../BulletCooldown/BulletCooldownArea"
@onready var bullet_cooldown_area_2: Area2D = $"../BulletCooldown/BulletCooldownArea2"
@onready var bullet_cooldown_area_3: Area2D = $"../BulletCooldown/BulletCooldownArea3"

@onready var player1_bullet_cooldown_area: Area2D = $"../TwoPlayers/Player1/BulletCooldownArea"
@onready var player1_bullet_cooldown_area_2: Area2D = $"../TwoPlayers/Player1/BulletCooldownArea2"
@onready var player1_bullet_cooldown_area_3: Area2D = $"../TwoPlayers/Player1/BulletCooldownArea3"
@onready var heart: AnimatedSprite2D = $"../TwoPlayers/Player1/Heart"
@onready var heart_2: AnimatedSprite2D = $"../TwoPlayers/Player1/Heart2"
@onready var character_area: Area2D = $CharacterArea
@onready var revive_progress: TextureProgressBar = $ReviveProgress
@onready var revive_label: Label = $ReviveLabel
@onready var revive_sound: AudioStreamPlayer2D = $"../TwoPlayers/ReviveSound"

@onready var character_line1 = $Line
@onready var character_line2 = $Line2

const GRAVITY = 100

#
#const METEOR = preload("res://scenes/meteor.tscn")
#const SMALL_METEOR = preload("res://scenes/small_meteor.tscn")
#const ASTEROID = preload("res://scenes/asteroid.tscn")
#@onready var meteors_container = get_parent().get_node("Meteors")

const BULLET = preload("res://scenes/bullet.tscn")
@onready var bullets_container = get_parent().get_node("Bullets")

@onready var selected_sound = get_parent().get_node("SelectedSound")

var shoot_cooldown_time = 0

var timer = 0.0

@onready var shield_bubble: Node = $ShieldBubble
@onready var animation_player: AnimationPlayer = $AnimationPlayer

	
var down_sub_counter = 0
var down_sub_counter2 = 0

var up_sub_counter = 0
var up_sub_counter2 = 0
var reviving_value = 0

#var velocity = Vector2.ZERO # The player's movement vector.

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Global.mecha_flight_player == 2:
		character_line1.visible = Global.mecha_flight_player1_hearts > 0
		character_line2.visible = Global.mecha_flight_player1_hearts > 0
		
	if Global.mecha_flight_player == 2 and (Global.mecha_flight_player1_hearts > 0 or Global.mecha_flight_player2_hearts > 0):
		revive_progress.visible = Global.mecha_flight_player1_hearts <= 0
		revive_label.visible = Global.mecha_flight_player1_hearts <= 0
	if Global.dead or Global.start_screen:
		return
	#if Global.free_regular_mode_objects:
		##queue_free()
		#return
	if Global.is_angle_dash or Global.is_space_ray:
		return
	if !Global.marathon and !Global.is_mecha_flight:
		return
		
		
	if Global.mecha_flight_player == 2 and Global.mecha_flight_player1_hearts == 0:
		if Input.is_action_pressed("shoot2"):
			if Global.mecha_flight_colliding_with_player:
				reviving_value += delta * 40
				if reviving_value >= 100:
					reviving_value = 0
					Global.mecha_flight_player1_hearts = 1
					heart.modulate = Color(1,1,1)
					revived()
				revive_progress.value = reviving_value
				return
		else:
			if reviving_value > 0:
				reviving_value -= delta * 40
				revive_progress.value = reviving_value
		# Always fall downward
		if velocity.y < 0:
			velocity.y = 0
		elif velocity.y > 200:
			velocity.y = 200
		velocity.y += GRAVITY * delta
		velocity.x = 0
		move_and_slide()
		character_area.rotate(0.02 * delta * 50)
		if position.y > 1000:
			queue_free()
		return
	
	velocity = Vector2.ZERO
	#shield_bubble.visible = Global.shield
	
	if Global.shield_animation:
		animation_player.play("shield_fade_in")
		animation_player.queue("default")
		Global.shield_animation = false
		
		
	if Input.is_action_pressed("move_right") and position.x <= 1050:
		velocity.x = 1
	if Input.is_action_pressed("move_left") and position.x >= 100:
		velocity.x = -1
	if Input.is_action_pressed("move_down") and position.y <= 520:
		velocity.y = 1
		if Input.is_action_just_pressed("move_down"):
			animated_sprite_2d.play("down_sub")
		else:
			if down_sub_counter >= 1:
				animated_sprite_2d.play("down")
			else:
				down_sub_counter += delta * 10

	if Input.is_action_pressed("move_up") and position.y >= 70:
		velocity.y = -1
		if Input.is_action_just_pressed("move_up"):
			animated_sprite_2d.play("up_sub")
		else:
			if up_sub_counter >= 1:
				animated_sprite_2d.play("up")
			else:
				up_sub_counter += delta * 10
		
	if Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up"):
		pass 
	else:
		
		if down_sub_counter > 0:
			animated_sprite_2d.play("down_sub")
			down_sub_counter2 += delta * 10
			if down_sub_counter2 >= 1:
				animated_sprite_2d.play("default")
				down_sub_counter = 0
				down_sub_counter2 = 0
		
		if up_sub_counter > 0:
			animated_sprite_2d.play("up_sub")
			up_sub_counter2 += delta * 10
			if up_sub_counter2 >= 1:
				animated_sprite_2d.play("default")
				up_sub_counter = 0
				up_sub_counter2 = 0
		
		
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
				
	if Global.mecha_flight_player == 2:
		if Global.mecha_flight_player1_bullets == 1:
			player1_bullet_cooldown_area.available = true
			player1_bullet_cooldown_area_2.available = false
			player1_bullet_cooldown_area_3.available = false
		elif Global.mecha_flight_player1_bullets == 2:
			player1_bullet_cooldown_area.available = true
			player1_bullet_cooldown_area_2.available = true
			player1_bullet_cooldown_area_3.available = false
		elif Global.mecha_flight_player1_bullets >= 3:
			player1_bullet_cooldown_area.available = true
			player1_bullet_cooldown_area_2.available = true
			player1_bullet_cooldown_area_3.available = true
		else:
			player1_bullet_cooldown_area.available = false
			player1_bullet_cooldown_area_2.available = false
			player1_bullet_cooldown_area_3.available = false
			
		if Global.mecha_flight_player1_bullets < 3:
			if shoot_cooldown_time > 2:
				Global.mecha_flight_player1_bullets+=1
				shoot_cooldown_time = 0
			else:
				shoot_cooldown_time += delta
	else:
		if Global.shoot_left == 1:
			bullet_cooldown_area.available = true
			bullet_cooldown_area_2.available = false
			bullet_cooldown_area_3.available = false
		elif Global.shoot_left == 2:
			bullet_cooldown_area.available = true
			bullet_cooldown_area_2.available = true
			bullet_cooldown_area_3.available = false
		elif Global.shoot_left >= 3:
			bullet_cooldown_area.available = true
			bullet_cooldown_area_2.available = true
			bullet_cooldown_area_3.available = true
		else:
			bullet_cooldown_area.available = false
			bullet_cooldown_area_2.available = false
			bullet_cooldown_area_3.available = false
		
		if Global.shoot_left < 3:
			if shoot_cooldown_time > 2:
				Global.shoot_left+=1
				shoot_cooldown_time = 0
			else:
				shoot_cooldown_time += delta
				
				
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * Global.speed

	move_and_slide()
		
			
func shoot():
	if Global.mecha_flight_player == 1:
		if Global.shoot_left <= 0:
			return
		var bullet = BULLET.instantiate()
		bullet.position = Vector2(position.x+100, position.y)
		bullets_container.add_child(bullet)
		Global.shoot_left -= 1
	else:
		if Global.mecha_flight_player1_bullets <= 0:
			return
		var bullet = BULLET.instantiate()
		bullet.position = Vector2(position.x+100, position.y)
		bullets_container.add_child(bullet)
		Global.mecha_flight_player1_bullets -= 1
		
func revived():
	character_area.rotation = 0
	animation_player.play("revive")
	revive_sound.play()
	
