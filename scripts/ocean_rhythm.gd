extends Node

@onready var selected_sound = get_parent().get_node("SelectedSound")

const BUBBLE = preload("res://scenes/ocean_rhythm_bubble.tscn")
@onready var bubbles: Node = $Bubbles

const CORAL1 = preload("res://scenes/or_coral_1.tscn")
const CORAL2 = preload("res://scenes/or_coral_2.tscn")
@onready var corals: Node = $Corals
var coral_arr = [CORAL1, CORAL2]

const FISH1 = preload("res://scenes/or_fish.tscn")
const FISH2 = preload("res://scenes/or_shark.tscn")
@onready var fishes: Node = $Fishes
var fish_arr = [FISH1, FISH2]

var timer = 0.0
var timer_corals = 0.0
var timer_fish = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.start_screen or !Global.is_ocean_rhythm:
		return
	if !Global.selected_sound_played:
		selected_sound.play()
		Global.selected_sound_played = true
		
	timer += delta
	if timer >= Global.bubble_spawn_interval:
		print("spawn")
		timer = 0
		spawn_bubble(Vector2(1200,randf_range(50, 648-50)))
		
	timer_corals += delta
	if timer_corals >= Global.coral_spawn_interval:
		print("spawn")
		timer_corals = 0
		spawn_coral(Vector2(1500,600))
		
		
	timer_fish += delta
	if timer_fish >= Global.fish_spawn_interval:
		print("spawn")
		timer_fish = 0
		spawn_fish(Vector2(1200,randf_range(300, 648-50)))
		
		

func spawn_bubble(pos):
	var bubble = BUBBLE.instantiate()
	bubble.position = pos
	bubbles.add_child(bubble)
	
func spawn_coral(pos):
	var coral = coral_arr[randi_range(0, len(coral_arr)-1)].instantiate()
	coral.position = pos
	corals.add_child(coral)
	
func spawn_fish(pos):
	var fish = fish_arr[randi_range(0, len(fish_arr)-1)].instantiate()
	fish.position = pos
	fishes.add_child(fish)
