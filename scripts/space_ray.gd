extends Node
@onready var bg: Sprite2D = $Bg

@onready var gameover_screen = get_parent().get_node("GameoverBg")
@onready var death_sound = get_parent().get_node("DeathSound")
@onready var selected_sound = get_parent().get_node("SelectedSound")
@onready var bg_music = get_parent().get_node("SpaceRayMusic")
@onready var animation = get_node("SpaceRayCharacter/SpaceRayCharacterArea/AnimationPlayer")
@onready var laser: AudioStreamPlayer2D = $SoundEffects/Laser

const EARTH = preload("res://scenes/sr_earth.tscn")
const MOON = preload("res://scenes/sr_moon.tscn")
const SATURN = preload("res://scenes/sr_saturn.tscn")
var bg_obj_array = [EARTH, MOON, SATURN]
var bg_obj_index = 0
@onready var bg_objects: Node = $BgObjects

const GIBBIOR = preload("res://scenes/space_ray_enemy_1.tscn")
const ROCKET = preload("res://scenes/sr_rocket.tscn")
const METEOR = preload("res://scenes/space_ray_meteor.tscn")
@onready var enemies: Node = $Enemies

var timer = 20
var bg_spawn_interval = 12
var gibbior_spawned = false
var gibbior_timer = 0.0
var rocket_timer = 0.0
var meteor_timer = 2.0

@onready var progress_bar: ProgressBar = $NextWeapon/ProgressBar

@onready var current_weapon_label: Label = $CurrentWeapon/CurrentWeaponLabel
@onready var weapon_sprite: Sprite2D = $CurrentWeapon/WeaponSprite
@onready var name_label: Label = $CurrentWeapon/NameLabel
@onready var damage_label: Label = $CurrentWeapon/DamageLabel
@onready var damage_label_2: Label = $CurrentWeapon/DamageLabel2
@onready var wip: Label = $NextWeapon/WIP
@onready var wip_2: Label = $NextWeapon/WIP2

@onready var laser_img = preload("res://assets/space_ray_assets/IMG_1851.PNG")
@onready var bomb_img = preload("res://assets/space_ray_assets/IMG_1852.PNG")
@onready var bullet_img = preload("res://assets/space_ray_assets/IMG_1848.PNG")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bg.visible = Global.is_space_ray
	weapon_sprite.visible = Global.is_space_ray
	name_label.visible = Global.is_space_ray
	damage_label.visible = Global.is_space_ray
	damage_label_2.visible = Global.is_space_ray
	wip.visible = Global.is_space_ray
	wip_2.visible = Global.is_space_ray
	current_weapon_label.visible = Global.is_space_ray
	if !Global.is_space_ray:
		return
	if Global.dead:
		if !Global.space_ray_gameover_screen:
			Global.space_ray_gameover_screen = true
			bg_music.stop()
			death_sound.play()
			Global.controls_tutorial = false
			gameover_screen.play_animation("default")
		if Input.is_action_pressed("enter"):
			Global.space_ray_hearts = 3
			Global.space_ray_weapon = "laser"
			Global.space_ray_gameover_screen = false
			Global.dead = false
			Global.is_space_ray = true
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
		
	timer += delta
	if timer >= bg_spawn_interval:
		print("spawn")
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
		
	meteor_timer += delta
	if meteor_timer >= 2:
		meteor_timer = 0
		spawn_enemy(Vector2(randf_range(200, 1600), -50), METEOR)
			
	gibbior_timer += delta
	if gibbior_timer >= 100:
		if !gibbior_spawned:
			spawn_gibbior()
			gibbior_spawned = true
			
	progress_bar.value += delta * 3
	
	name_label.text = Global.space_ray_weapon
	
	if Global.space_ray_weapon == "laser":
		weapon_sprite.texture = laser_img
	elif Global.space_ray_weapon == "bomb":
		weapon_sprite.texture = bomb_img
	elif Global.space_ray_weapon == "bullet":
		weapon_sprite.texture = bullet_img


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
