extends Node

var score: int = 0
var meteor_speed: float = 2.0
var speed = 400.0
var object_speed = 2.0

var dead = false
var controls_tutorial = true

var spawn_interval = 2.0

var shield = false
var shield_animation = false
var double_points = false

var powerup = null
var powerup_showed = false
var powerup_animation_finish = false
