extends Node
@onready var bg: Sprite2D = $Bg

@onready var selected_sound = get_parent().get_node("SelectedSound")
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bg.visible = Global.is_space_ray
	if !Global.is_space_ray:
		return
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
