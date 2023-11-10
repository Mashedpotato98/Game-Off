extends CharacterBody3D

@onready var head = $Head
@onready var arms = $player_arms
@onready var cam = $Head/Camera3D
@onready var zoom_mask = $CanvasLayer/zoom_in_mask
@onready var hand_anim = $player_arms/AnimationPlayer

var mouse_sens:float = 0.2
var arm_y_lerp:int = 0.1
var arm_x_rotation_lerp:int = 20
var fov_lerp:int = 5


var arm_position = {"Default":4.0,"zoom_in":4.3}
var arm_rotation = {"Default":0.0,"zoom_in":-40.0}
var fov = {"Default":90.0,"zoom_in":50.0}

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-23),deg_to_rad(50))

func _process(delta):
	if Input.is_action_pressed("Zoom_in"):
		#arms.position.y = lerp(arms.position.y,arm_position["zoom_in"],arm_y_lerp*delta)
		#arms.rotation_degrees.x = lerp(arms.rotation_degrees.x,arm_rotation["zoom_in"],arm_x_rotation_lerp*delta)
		#arms.position.y = lerp(arms.position.y,120.0,arm_y_lerp*delta)
		hand_anim.play("Picture")
		
		cam.fov = lerp(cam.fov,fov["zoom_in"],fov_lerp*delta)

		zoom_mask.visible = true
		arms.visible = false
	else:
		arms.position.y = lerp(arms.position.y,arm_position["Default"],arm_y_lerp*delta)
		arms.rotation_degrees.x = lerp(arms.rotation_degrees.x,arm_rotation["Default"],arm_x_rotation_lerp*delta)
		cam.fov = lerp(cam.fov,fov["Default"],fov_lerp*delta)

		zoom_mask.visible = false
		arms.visible = true
