extends Node

var screen_size 

var score: int = 0
var next_mode_score = 0
var meteor_speed: float = 4.0
var speed = 400.0
var object_speed = 2.0

var angle_dash_speed = 250.0
var spike_speed = 250.0

var shoot_left = 3

var prev_meteor_speed = 0.0
var prev_speed = 0.0
var prev_object_speed = 2.0


var dead = false
var controls_tutorial = true

var spawn_interval = 1.5

var shield = false
var shield_animation = false
var double_points = false
var magnet = false
var unli_bullet = false
var hearts = 2

var powerup = null
var powerup_showed = false
var powerup_animation_finish = false

var is_angle_dash = false
var is_angle_dash_selected_sound = false
var free_regular_mode_objects = false
var angle_dash_animation_finished = false
var progress_area_displayed = null
var gameover_and_restart_angle_dash = false
var obstacle_spawn_interval = 5
var direction = 0
var angle_dash_score = 0

var start_screen = true

var marathon = false

var is_mecha_flight = false
var is_mecha_flight_player_screen = false
var mecha_flight_player = 1
var mecha_flight_animation_done = false
var mecha_flight_player1_hearts = 2
var mecha_flight_player2_hearts = 2
var mecha_flight_player1_bullets = 3
var mecha_flight_player2_bullets = 3
var mecha_flight_player1_score = 0
var mecha_flight_player2_score = 0

var powerup_player1 = null
var powerup_player2 = null

var unli_bullet_player1 = false
var unli_bullet_player2 = false
var magnet_player1 = false
var magnet_player2 = false
var double_point_player1 = false
var double_point_player2 = false
var shield_player1 = false
var shield_player2 = false

var is_space_ray = false
var selected_sound_played = false
var space_ray_weapon = "ray"
var space_ray_weapons = ["ray"]
var space_ray_weapon_dmg = {"snowball": 10, "ray": 10, "red_ray": 20, "bullet": 20, "red_bullet": 40, "bomb": 30}
var space_ray_game_time = 0.0
var space_ray_hearts = 3
var space_ray_gameover_screen = false
var rocket_position_laser = Vector2(0,0)
var laser_enter = false
var theres_bomb = false
var space_ray_spawn_interval = 1.5
var space_ray_score = 0.0
var space_ray_weapon_score = 0.0
var space_ray_stop = false
var space_ray_powerup = ""
var space_ray_powerup_animation = false
var space_ray_powerup_time = 80.0
var space_ray_new_weapon = false
var space_ray_thrust_accel = 400
var space_ray_multiplier = 1
var space_ray_powerups = ["shrink", "triple", "invisible", "speed", "double", "machine_gun"]
var space_ray_runspeed = 80.0

var is_ocean_rhythm = false
var bubble_spawn_interval = 1.5
var coral_spawn_interval = 8
var fish_spawn_interval = 15
