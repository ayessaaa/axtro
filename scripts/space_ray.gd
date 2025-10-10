extends Node
@onready var bg: Sprite2D = $Bg

@onready var gameover_screen = get_parent().get_node("GameoverBg")
@onready var death_sound = get_parent().get_node("DeathSound")
@onready var selected_sound = get_parent().get_node("SelectedSound")
@onready var bg_music = get_parent().get_node("SpaceRayMusic")
@onready var animation = get_node("SpaceRayCharacter/SpaceRayCharacterArea/AnimationPlayer")
@onready var enemy_hit_sound: AudioStreamPlayer2D = $SoundEffects/EnemyHitSound
@onready var laser: AudioStreamPlayer2D = $SoundEffects/Laser
@onready var enemy_loop_sound: AudioStreamPlayer2D = $SoundEffects/EnemyLoopSound
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var powerup_animation: AnimationPlayer = $PowerupAnimation
@onready var q_switch: Label = $CurrentWeapon/QSwitch

const EARTH = preload("res://scenes/sr_earth.tscn")
const MOON = preload("res://scenes/sr_moon.tscn")
const SATURN = preload("res://scenes/sr_saturn.tscn")
var bg_obj_array = [EARTH, MOON, SATURN]
var bg_obj_index = 0
@onready var bg_objects: Node = $BgObjects

const GIBBIOR = preload("res://scenes/space_ray_enemy_1.tscn")
const ROCKET = preload("res://scenes/sr_rocket.tscn")
const METEOR = preload("res://scenes/space_ray_meteor.tscn")
const BLAISTER = preload("res://scenes/space_ray_blaister.tscn")
@onready var enemies: Node = $Enemies

const STAR = preload("res://scenes/space_ray_star.tscn")
@onready var stars: Node = $Stars

const HEART = preload("res://scenes/space_ray_heart_collectible.tscn")
@onready var collectibles: Node = $Collectibles

var timer = 20
var bg_spawn_interval = 12
var gibbior_spawned = false
var gibbior_timer = 0.0
var rocket_timer = 0.0
var meteor_timer = 2.0
var star_timer = 2.0
var heart_timer = 2.0
var blaister_timer = 0.0

@onready var current_weapon_label: Label = $CurrentWeapon/CurrentWeaponLabel
@onready var weapon_sprite: Sprite2D = $CurrentWeapon/WeaponSprite
@onready var name_label: Label = $CurrentWeapon/NameLabel
@onready var damage_label: Label = $CurrentWeapon/DamageLabel
@onready var cooldown_label: Label = $CurrentWeapon/CooldownLabel

@onready var laser_img = preload("res://assets/space_ray_assets/IMG_1851.PNG")
@onready var bomb_img = preload("res://assets/space_ray_assets/IMG_1852.PNG")
@onready var bullet_img = preload("res://assets/space_ray_assets/IMG_1848.PNG")
@onready var snowball_img = preload("res://assets/space_ray_assets/IMG_2033.PNG")

@onready var next_weapon_text: Label = $NextWeapon/NextWeapon
@onready var progress_bar: ProgressBar = $NextWeapon/ProgressBar
@onready var progress_text: Label = $NextWeapon/ProgressText

var weapon_list = ["bomb"]
var weapon_list_index = 0
var weapon_score = {"bomb": 50}
var progress_bar_value

@onready var bomb_animated: AnimatedSprite2D = $NextWeapon/BombArea/Bomb

@onready var corner_laser: AnimatedSprite2D = $Powerup/CornerLaser
@onready var corner_laser_2: AnimatedSprite2D = $Powerup/CornerLaser2
@onready var powerup_progress_bar: ProgressBar = $Powerup/PowerupProgressBar
@onready var powerup_text: Label = $Powerup/PowerupText
var powerup_names = {"shrink": "SHRINK !!", "triple": "3x SHOOTER", "invisible": "INVISIBLEE",
					 "speed": "SPEEDY", "double": "2x SCORE", "machine_gun": "MACHINE GUN",
					 "big_bomb": "BIG BOMB"}

var next_weapon_animation_done
@onready var powerup_sound: AudioStreamPlayer2D = $SoundEffects/PowerupSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bg.visible = Global.is_space_ray
	weapon_sprite.visible = Global.is_space_ray
	name_label.visible = Global.is_space_ray
	damage_label.visible = Global.is_space_ray
	cooldown_label.visible = Global.is_space_ray
	current_weapon_label.visible = Global.is_space_ray
	next_weapon_text.visible = Global.is_space_ray
	progress_bar.visible = Global.is_space_ray
	progress_text.visible = Global.is_space_ray
	q_switch.visible = Global.is_space_ray
	
	if !Global.is_space_ray:
		return
	if Global.space_ray_new_weapon and next_weapon_animation_done:
		if Input.is_action_just_pressed("shoot"):
			animation_player.play("fade_out_weapon")
			Global.space_ray_stop = false
			bomb_animated.play("explode")
			Global.space_ray_new_weapon = false
	if Global.space_ray_stop:
		return
	if Global.dead:
		if !Global.space_ray_gameover_screen:
			Global.space_ray_gameover_screen = true
			bg_music.stop()
			death_sound.play()
			Global.controls_tutorial = false
			enemy_loop_sound.stop()
			gameover_screen.play_animation("default")
			Global.theres_bomb = false
		if Input.is_action_pressed("enter"):
			Global.space_ray_score = 0
			Global.space_ray_hearts = 3
			Global.space_ray_weapon = "bullet"
			Global.space_ray_gameover_screen = false
			Global.dead = false
			Global.is_space_ray = true
			Global.space_ray_powerup = ""
			Global.space_ray_powerup_animation = false
			Global.space_ray_powerup_time = 100.0
			get_tree().reload_current_scene()
	if !Global.selected_sound_played and Global.is_space_ray:
		selected_sound.play()
		animation.play("fade_in")
		laser.play()
		Global.selected_sound_played = true
		
	if Global.space_ray_weapon != "laser":
		laser.stop()
		
	if Global.space_ray_hearts == 0:
		Global.dead = true
	
	if Global.dead:
		return
		
	if Global.space_ray_powerup == "shrink":
		if !Global.space_ray_powerup_animation:
			Global.space_ray_powerup_time = 80.0
			powerup_progress_bar.max_value = 80.0
			powerup_start()
		Global.space_ray_powerup_time -= delta * 4
		powerup_progress_bar.value = Global.space_ray_powerup_time
		if Global.space_ray_powerup_time <= 0:
			powerup_end()
	elif Global.space_ray_powerup == "triple":
		if !Global.space_ray_powerup_animation:
			Global.space_ray_powerup_time = 80.0
			powerup_progress_bar.max_value = 80.0
			powerup_start()
		Global.space_ray_powerup_time -= delta * 4
		powerup_progress_bar.value = Global.space_ray_powerup_time
		if Global.space_ray_powerup_time <= 0:
			powerup_end()
	elif Global.space_ray_powerup == "invisible":
		if !Global.space_ray_powerup_animation:
			Global.space_ray_powerup_time = 80.0
			powerup_progress_bar.max_value = 80.0
			powerup_start()
		Global.space_ray_powerup_time -= delta * 4
		powerup_progress_bar.value = Global.space_ray_powerup_time
		if Global.space_ray_powerup_time <= 0:
			powerup_end()
	elif Global.space_ray_powerup == "speed":
		if !Global.space_ray_powerup_animation:
			Global.space_ray_powerup_time = 80.0
			powerup_progress_bar.max_value = 80.0
			Global.space_ray_thrust_accel = 600
			powerup_start()
		Global.space_ray_powerup_time -= delta * 4
		powerup_progress_bar.value = Global.space_ray_powerup_time
		if Global.space_ray_powerup_time <= 0:
			Global.space_ray_thrust_accel = 400
			powerup_end()
	elif Global.space_ray_powerup == "double":
		if !Global.space_ray_powerup_animation:
			Global.space_ray_powerup_time = 80.0
			powerup_progress_bar.max_value = 80.0
			Global.space_ray_multiplier = 2
			powerup_start()
		Global.space_ray_powerup_time -= delta * 4
		powerup_progress_bar.value = Global.space_ray_powerup_time
		if Global.space_ray_powerup_time <= 0:
			Global.space_ray_multiplier = 1
			powerup_end()
	elif Global.space_ray_powerup == "machine_gun":
		if !Global.space_ray_powerup_animation:
			Global.space_ray_powerup_time = 80.0
			powerup_progress_bar.max_value = 80.0
			powerup_start()
		Global.space_ray_powerup_time -= delta * 4
		powerup_progress_bar.value = Global.space_ray_powerup_time
		if Global.space_ray_powerup_time <= 0:
			powerup_end()
	elif Global.space_ray_powerup == "big_bomb":
		if !Global.space_ray_powerup_animation:
			Global.space_ray_powerup_time = 80.0
			powerup_progress_bar.max_value = 80.0
			powerup_start()
		Global.space_ray_powerup_time -= delta * 4
		powerup_progress_bar.value = Global.space_ray_powerup_time
		if Global.space_ray_powerup_time <= 0:
			powerup_end()
	#else:
		#Global.space_ray_powerup_time = 80.0
		
			
		
	timer += delta
	if timer >= bg_spawn_interval:
		timer = 0
		spawn_bg_obj(Vector2(1500, randf_range(50, 500)), bg_obj_array[bg_obj_index])
		if bg_obj_index < len(bg_obj_array)-1:
			bg_obj_index += 1
		else:
			bg_obj_index = 0
			
	rocket_timer += delta
	if rocket_timer >= 2:
		rocket_timer = 0
		spawn_enemy(Vector2(1500, randf_range(50, 600)), ROCKET)
		
	blaister_timer += delta
	if blaister_timer >= 10:
		blaister_timer = 0
		spawn_enemy(Vector2(1500, randf_range(50, 600)), BLAISTER)
		
	meteor_timer += delta
	if meteor_timer >= 3:
		meteor_timer = 0
		spawn_enemy(Vector2(randf_range(200, 1600), -50), METEOR)
			
	gibbior_timer += delta
	if gibbior_timer >= 20:
		if !gibbior_spawned:
			corner_laser.play("yellow")
			corner_laser_2.play("yellow")
			animation_player.play("gibbior_spawned")
			spawn_gibbior()
			gibbior_spawned = true
			enemy_loop_sound.play()
			bg_music.volume_db = -10
			
	star_timer += delta
	if star_timer >= 2 and Global.space_ray_powerup == "":
		if randi_range(0, 10) < 1:
			spawn_star(Vector2(randf_range(50, 1100), -100))
		star_timer = 0
		
	heart_timer += delta
	if heart_timer >= 2 and Global.space_ray_hearts < 3:
		if randi_range(0, 10) < 1:
			spawn_heart(Vector2(randf_range(50, 1100), -100))
		heart_timer = 0
			
	
	name_label.text = Global.space_ray_weapon
	
	if Global.space_ray_weapon == "laser":
		weapon_sprite.texture = laser_img
	elif Global.space_ray_weapon == "bomb":
		weapon_sprite.texture = bomb_img
	elif Global.space_ray_weapon == "bullet":
		weapon_sprite.texture = bullet_img
	elif Global.space_ray_weapon == "snowball":
		weapon_sprite.texture = snowball_img
		
	next_weapon_text.text = "next weapon: " + weapon_list[weapon_list_index]
		
	progress_bar_value = Global.space_ray_weapon_score/weapon_score[weapon_list[weapon_list_index]]
	progress_bar.value = progress_bar_value
	progress_text.text = str(int(Global.space_ray_weapon_score)) + " / " + str(weapon_score[weapon_list[weapon_list_index]])
	if progress_bar_value >= 1:
		corner_laser.play("green")
		corner_laser_2.play("green")
		Global.space_ray_weapons.append(weapon_list[weapon_list_index])
		Global.space_ray_new_weapon = true
		animation_player.play("new_weapon")
		Global.space_ray_weapon_score = 0.0
		Global.space_ray_stop = true
		next_weapon_animation_done = false
		if weapon_list[weapon_list_index] == "bomb":
			Global.space_ray_powerups.append("big_bomb")
		#weapon_list_index += 1
		
	#print(Global.space_ray_powerups)
		
	
func _on_laser_finished() -> void:
	laser.play()
	
func spawn_bg_obj(pos, obj):
	var bg_obj = obj.instantiate()
	bg_obj.position = pos
	bg_objects.add_child(bg_obj)
	
func spawn_gibbior():
	var gibbior = GIBBIOR.instantiate()
	gibbior.position = Vector2(0, 0)
	enemies.add_child(gibbior)
	
func spawn_enemy(pos, enemy_scene):
	var enemy = enemy_scene.instantiate()
	enemy.position = pos
	enemies.add_child(enemy)
	
func spawn_star(pos):
	var star = STAR.instantiate()
	star.position = pos
	stars.add_child(star)
	
func spawn_heart(pos):
	var heart = HEART.instantiate()
	heart.position = pos
	collectibles.add_child(heart)


func _on_enemy_loop_sound_finished() -> void:
	enemy_loop_sound.play()


func _on_enemy_hit_sound_finished() -> void:
	enemy_hit_sound.volume_db = 0
	
func powerup_start() -> void:
	powerup_text.text = powerup_names[Global.space_ray_powerup]
	powerup_animation.play(Global.space_ray_powerup)
	corner_laser.play("blue")
	corner_laser_2.play("blue")
	Global.space_ray_powerup_animation = true
	powerup_sound.play()
	
func powerup_end() -> void:
	powerup_animation.play("un"+Global.space_ray_powerup)
	Global.space_ray_powerup = ""
	Global.space_ray_powerup_animation = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	next_weapon_animation_done = true
