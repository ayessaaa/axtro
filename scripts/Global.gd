extends Node

var score: int = 0
var meteor_speed: float = 4.0
var speed = 400.0
var object_speed = 2.0

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

var powerup = null
var powerup_showed = false
var powerup_animation_finish = false

var is_angle_dash = false
var free_regular_mode_objects = false
