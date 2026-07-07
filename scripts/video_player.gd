extends Panel

@onready var video_stream_player : VideoStreamPlayer = %VideoStreamPlayer
@onready var pause_button : Button = %PauseButton
@onready var timeline : HBoxContainer = %Timeline
@onready var video_pos_slider : Slider = %VideoPosSlider
@onready var video_pos_label : Label = %VideoPosLabel
@onready var fullscreen_button : Button = %FullscreenButton

var animation_length : float = 0.125
var hovering : bool = false
var pausing : bool = false
var dragging_video_slider : bool = false


func _ready() -> void:
	Globals.connect("show_video_ui", _initialize)
	Globals.connect("hide_video_ui", _stop_playing)
	
	pause_button.scale = Vector2(.5, .5)
	pause_button.self_modulate.a = 0


func _process(_delta : float):
	if Input.is_action_just_pressed("pause"):
		_pause()
	
	if get_local_mouse_position().x > 0 and get_local_mouse_position().y > 0 and get_local_mouse_position().x < size.x and get_local_mouse_position().y < size.y:
		_set_hovering(true)
	else:
		_set_hovering(false)
	
	if not dragging_video_slider:
		video_pos_slider.value = video_stream_player.stream_position
	
	video_pos_label.text = str(snapped(video_stream_player.stream_position, 0.1)) + "/" + str(snapped(video_stream_player.get_stream_length(), 0.1))


func _initialize():
	if pausing:
		_pause()
	video_stream_player.stream = Globals.current_video
	video_stream_player.play()
	
	video_pos_slider.max_value = video_stream_player.get_stream_length()


func _stop_playing():
	video_stream_player.stop()


func _pause():
	pausing = !pausing
	video_stream_player.paused = pausing
	
	if pausing:
		var _scale_tween = create_tween()
		_scale_tween.tween_property(pause_button, "scale", Vector2.ONE, animation_length)
		
		var _alpha_tween = create_tween()
		_alpha_tween.tween_property(pause_button, "self_modulate:a", 1, animation_length)
	else:
		var _scale_tween = create_tween()
		_scale_tween.tween_property(pause_button, "scale", Vector2(.5, .5), animation_length)
		
		var _alpha_tween = create_tween()
		_alpha_tween.tween_property(pause_button, "self_modulate:a", 0, animation_length)
	

func _set_hovering(value : bool) -> void:
	hovering = value
	
	if hovering:
		var _fs_button_tween = create_tween()
		_fs_button_tween.tween_property(fullscreen_button, "modulate:a", 1, animation_length)
		
		var _timeline_tween = create_tween()
		_timeline_tween.tween_property(timeline, "modulate:a", 1, animation_length)
	else:
		var _fs_button_tween = create_tween()
		_fs_button_tween.tween_property(fullscreen_button, "modulate:a", 0, animation_length)
		
		if not dragging_video_slider:
			var _timeline_tween = create_tween()
			_timeline_tween.tween_property(timeline, "modulate:a", 0, animation_length)


func _on_video_pos_slider_drag_started() -> void:
	dragging_video_slider = true


func _on_video_pos_slider_drag_ended(_value_changed: bool) -> void:
	video_stream_player.stream_position = video_pos_slider.value
	dragging_video_slider = false
