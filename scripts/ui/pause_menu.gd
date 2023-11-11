extends CanvasLayer

@onready var paused:bool = false:
	set(value):
		paused = value
		get_tree().paused = paused
		animation_player.play("Show" if paused else "Hide")
		if not paused:
			for button in menu.get_children():
				button.release_focus()

		await RenderingServer.frame_post_draw
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if paused else Input.MOUSE_MODE_HIDDEN

@onready var menu = %Menu
@onready var picture_gallery = %PictureGallery
@onready var pictures = %Pictures
@onready var letters = %Letters
@onready var letter_list = %LettersList
@onready var animation_player = $AnimationPlayer
@onready var back_button = %BackButton
@onready var resume_button = %ResumeButton

func _input(event:InputEvent):
	if event.is_action_pressed("ui_cancel"):
		set_paused(not paused)

func add_picture(picture:ImageTexture):
	var texture_rect = TextureRect.new()
	pictures.add_child(texture_rect)
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	texture_rect.texture = picture

@warning_ignore("shadowed_variable")
func set_paused(paused:bool):
	self.paused = paused

func _on_quit_button_pressed():
	get_tree().quit()
	# If the game doesn't save itself, then make sure to make a comfirm menu.

func _on_letter_button_pressed():
	menu.hide()
	back_button.show()
	back_button.grab_focus()
	letters.show()

func _on_gallery_button_pressed():
	menu.hide()
	back_button.show()
	back_button.grab_focus()
	picture_gallery.show()

func _on_back_button_pressed():
	picture_gallery.hide()
	letters.hide()
	back_button.hide()
	menu.show()
	resume_button.grab_focus()
