extends Node3D

# Components
@onready var camera_animation_player : AnimationPlayer = $Camera3D/AnimationPlayer
@onready var camera : Camera3D = $Camera3D
@onready var home_ui : Control = %HomeUI
@onready var plaza_ui: Control = %"Plaza UI"
@onready var ui_animation_player : AnimationPlayer = $CanvasLayer/UI/AnimationPlayer

@onready var zoom_buttons_holder: Control = $"CanvasLayer/UI/Plaza UI/ZoomButtonsHolder"
var zoom_buttons : Array[WiiUButton]

# Camera
enum Views{
	GamePad,
	TV
}
var current_view : Views = Views.TV

@export var cam_bounds : int
var input_dir : Vector2
var move_dir : Vector2
var max_cam_speed : float = 10
var cam_speed : float
var cam_velocity : float = 25
var cam_mode : int = 1
var cam_zoom_speed = 5


func _ready() -> void:
	_get_components()
	switch_view()


func _process(delta: float) -> void:
	_handle_camera(delta)
	_handle_resize()


func _get_components():
	for i in zoom_buttons_holder.get_children():
		zoom_buttons.append(i)


func _handle_camera(delta : float):
	_handle_camera_movement(delta)
	_handle_camera_zooming(delta)


func _handle_camera_movement(delta : float):
	if current_view == Views.TV:
		input_dir.x = Input.get_axis("joy_left", "joy_right")
		input_dir.y = Input.get_axis("joy_up", "joy_down")
		
		if input_dir:
			@warning_ignore("integer_division")
			move_dir = input_dir - Vector2(input_dir.x * cam_mode / 4, input_dir.y * cam_mode / 4)
		move_dir = move_dir.normalized()
		
		if input_dir:
			cam_speed += cam_velocity * delta
		else:
			cam_speed -= cam_velocity * delta
		cam_speed = clampf(cam_speed, 0, max_cam_speed)
		
		camera.position.x += move_dir.x * cam_speed * delta
		camera.position.z += move_dir.y * cam_speed * delta
		
		camera.position.x = clampf(camera.position.x, -cam_bounds, cam_bounds)
		camera.position.z = clampf(camera.position.z, -cam_bounds, cam_bounds)


func _handle_camera_zooming(delta : float):
	if current_view == Views.TV:
		if Input.is_action_just_pressed("zoom_in"):
			cam_mode += 1
		if Input.is_action_just_pressed("zoom_out"):
			cam_mode -= 1
		cam_mode = clampi(cam_mode, 0, 3)
		
		match cam_mode:
			0:
				camera.fov = lerpf(camera.fov, 40, cam_zoom_speed * delta)
				for i in zoom_buttons.size():
					if i == 0:
						zoom_buttons[0].turn_blue()
					else:
						zoom_buttons[i].turn_white()
			1:
				camera.fov = lerpf(camera.fov, 32.5, cam_zoom_speed * delta)
				for i in zoom_buttons.size():
					if i == 1:
						zoom_buttons[i].turn_blue()
					else:
						zoom_buttons[i].turn_white()
			2:
				camera.fov = lerpf(camera.fov, 25, cam_zoom_speed * delta)
				for i in zoom_buttons.size():
					if i == 2:
						zoom_buttons[i].turn_blue()
					else:
						zoom_buttons[i].turn_white()
			3:
				camera.fov = lerpf(camera.fov, 15, cam_zoom_speed * delta)
				for i in zoom_buttons.size():
					if i == 3:
						zoom_buttons[i].turn_blue()
					else:
						zoom_buttons[i].turn_white()


func _change_zoom(extra_arg_0: int) -> void:
	cam_mode = extra_arg_0


func _handle_resize():
	if DisplayServer.window_get_size().x < DisplayServer.window_get_size().y:
		# Vertical UI
		pass
	else:
		# Horizontal UI
		pass


func switch_view():
	if current_view == Views.GamePad:
		current_view = Views.TV
		home_ui.visible = false
		plaza_ui.visible = true
		camera_animation_player.play("show_plaza")
		ui_animation_player.play("show_plaza")
		await get_tree().create_timer(ui_animation_player.current_animation.length()).timeout
	else:
		current_view = Views.GamePad
		home_ui.visible = true
		plaza_ui.visible = false
		camera_animation_player.play_backwards("show_plaza")
		ui_animation_player.play_backwards("show_plaza")
		await get_tree().create_timer(ui_animation_player.current_animation.length()).timeout
