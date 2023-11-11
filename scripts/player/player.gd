extends CharacterBody3D

signal Picture_taken(picture:ImageTexture)

const MIN_LOOK = deg_to_rad(-23)
const MAX_LOOK = deg_to_rad(50)

@onready var head = $Head
@onready var arms = head.get_node("player_arms")
@onready var hand_anim = arms.get_node("AnimationPlayer")
@onready var cam = head.get_node("Camera3D")
@onready var camera_model = head.get_node("player_arms/Armature/Skeleton3D/Camera")
@onready var ui = $ui
@onready var zoom_mask = ui.get_node("zoom_in_mask")
@onready var ui_animation_player = ui.get_node("AnimationPlayer")

var mouse_sens:float = 0.2
var zoom_speed:float = 0.25
var camera_up:bool = false
var can_take_picture:bool = false
var film:int = 5

var fov = {"Default":90.0,"zoom_in":50.0}

var pictures:Array[ImageTexture] = []

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x,MIN_LOOK,MAX_LOOK)

	if event.is_action_pressed("Picture") and can_take_picture:
		take_picture()

func _process(_delta:float):
	handle_camera_toggled()

func handle_camera_toggled():
	var is_camera_pressed := Input.is_action_pressed("Camera")
	# If the state changed
	if camera_up != is_camera_pressed:
		camera_up = is_camera_pressed
		hand_anim.play("CameraUp" if camera_up else "CameraDown", 0.25)
		if not camera_up:
			can_take_picture = false
			arms.visible = true
			# This animation might be able to be moved to ui_animation_player
			get_tree().create_tween().tween_property(zoom_mask,"modulate:a",0,zoom_speed)
			get_tree().create_tween().tween_property(cam,"fov",fov["Default"],zoom_speed)
			# Hard coded
			await get_tree().create_timer(0.3).timeout
			camera_model.hide()
		else:
			await get_tree().create_timer(0.3).timeout
			camera_model.show()

func take_picture():
	zoom_mask.hide()
	await RenderingServer.frame_post_draw

	var image = get_viewport().get_texture().get_image()
	image.adjust_bcs(1,1,0)
	image.shrink_x2()
	# It would be cleaner to split this up into multiple lines, but long lines are fun, right? ;)
	image = ImageTexture.create_from_image(image.get_region(Rect2i(Vector2i(image.get_width()/4,0),Vector2i(image.get_height(),image.get_height()))))
	pictures.append(image)

	zoom_mask.show()
	ui_animation_player.play("Flash")

	Picture_taken.emit(image)

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "CameraUp":
		arms.visible = false
		get_tree().create_tween().tween_property(zoom_mask,"modulate:a",1,zoom_speed)
		await get_tree().create_tween().tween_property(cam,"fov",fov["zoom_in"],zoom_speed).finished
		can_take_picture = true
