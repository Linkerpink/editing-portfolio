extends Node

@onready var mouse_timer : Timer = $MouseTimer

var using_mouse : bool = false
var selected_button : Control
var current_video : Video
signal show_video_ui
signal hide_video_ui


func _input(event):
	if event is InputEventMouseMotion:
		if not using_mouse:
			# Enable cursor
			WiiUCursor.show_cursor(true)
		
		using_mouse = true
		mouse_timer.start()


func select_button(_button : Control):
	selected_button = _button


func _on_mouse_timer_timeout() -> void:
	if using_mouse:
		# Disable cursor
		using_mouse = false
		WiiUCursor.show_cursor(false)
