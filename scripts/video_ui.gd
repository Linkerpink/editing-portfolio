extends Control


func _on_view_on_youtube_button_pressed() -> void:
	OS.shell_open(Globals.current_video.link)
