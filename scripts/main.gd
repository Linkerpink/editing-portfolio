extends Node3D

@onready var home_ui : Control = %HomeUI
@onready var ui_animation_player : AnimationPlayer = $CanvasLayer/UI/AnimationPlayer
@onready var camera_animation_player : AnimationPlayer = $Camera3D/AnimationPlayer

enum Views{
	GamePad,
	TV
}
var current_view : Views = Views.GamePad


func switch_view():
	if current_view == Views.GamePad:
		current_view = Views.TV
		home_ui.visible = false
		camera_animation_player.play("show_plaza")
		ui_animation_player.play("show_plaza")
	else:
		current_view = Views.GamePad
		home_ui.visible = true
		camera_animation_player.play_backwards("show_plaza")
		ui_animation_player.play_backwards("show_plaza")
