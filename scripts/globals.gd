extends Node

var using_mouse : bool = false
@onready var mouse_timer : Timer = $MouseTimer


func _input(event):
	if event is InputEventMouseMotion:
		if not using_mouse:
			# Enable cursor
			WiiUCursor.show_cursor(true)
		
		using_mouse = true
		mouse_timer.start()


func _on_mouse_timer_timeout() -> void:
	if using_mouse:
		# Disable cursor
		using_mouse = false
		WiiUCursor.show_cursor(false)
