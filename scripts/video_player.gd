extends Panel

@onready var video_stream_player : VideoStreamPlayer = %VideoStreamPlayer
@onready var pause_button : Button = %PauseButton
@onready var bottom_bar: Control = %BottomBar
@onready var mute_button: Button = %MuteButton
@onready var volume_slider: HSlider = %VolumeSlider
@onready var video_pos_slider : Slider = %VideoPosSlider
@onready var video_pos_label : Label = %VideoPosLabel

@onready var fullscreen_button : Button = %FullscreenButton
@onready var fullscreen_ui : Control = %FullscreenUI
@onready var fullscreen_video_stream_player: VideoStreamPlayer = %FullscreenVideoStreamPlayer
@onready var fullscreen_pause_button : Button = %FullscreenPauseButton
@onready var fullscreen_video_pos_label : Label = %FullscreenVideoPosLabel
@onready var fullscreen_video_pos_slider: HSlider = %FullscreenVideoPosSlider
@onready var fullscreen_fullscreen_button: Button = %FullscreenFullscreenFullscreenButton
@onready var fullscreen_bottom_bar: Control = %FullscreenBottomBar
@onready var fullscreen_volume_slider: HSlider = %FullscreenVolumeSlider
@onready var fullscreen_title_label: Label = %FullscreenTitleLabel

@onready var title_label : Label = %TitleLabel
@onready var profile_picture_texture_rect: TextureRect = %ProfilePictureTextureRect
@onready var channel_label: Label = %ChannelLabel

var main : Main
var animation_length : float = 0.125
var hovering : bool = false
var pausing : bool = false
var muted : bool = false
var last_volume : float = 1.0
var fullscreen : bool = false
var dragging_video_slider : bool = false

var fullscreen_mouse_timer : float
var fullscreen_mouse_timer_length : float = 1
var last_mouse_pos : Vector2


func _ready() -> void:
	Globals.connect("show_video_ui", _initialize)
	Globals.connect("hide_video_ui", _stop_playing)
	
	main = get_tree().get_first_node_in_group("main")
	pause_button.scale = Vector2(.5, .5)
	pause_button.self_modulate.a = 0
	fullscreen_ui.hide()


func _process(delta : float):
	if Input.is_action_just_pressed("pause"):
		_pause()
	
	if not fullscreen:
		if get_local_mouse_position().x > 0 and get_local_mouse_position().y > 0 and get_local_mouse_position().x < size.x and get_local_mouse_position().y < size.y:
			_set_hovering(true)
		else:
			_set_hovering(false)
		
		if not dragging_video_slider:
			video_pos_slider.value = video_stream_player.stream_position
		
		video_pos_label.text = str(snapped(video_stream_player.stream_position, 0.1)) + "/" + str(snapped(video_stream_player.get_stream_length(), 0.1))
	else:
		# Mouse movement
		if last_mouse_pos != get_local_mouse_position():
			_set_hovering(true)
			fullscreen_mouse_timer = fullscreen_mouse_timer_length
			last_mouse_pos = get_local_mouse_position()
		else:
			if fullscreen_mouse_timer > 0:
				fullscreen_mouse_timer -= delta
			else:
				_set_hovering(false)
		
		if not dragging_video_slider:
			fullscreen_video_pos_slider.value = fullscreen_video_stream_player.stream_position
		
		fullscreen_video_pos_label.text = str(snapped(fullscreen_video_stream_player.stream_position, 0.1)) + "/" + str(snapped(video_stream_player.get_stream_length(), 0.1))


func _initialize():
	if pausing:
		_pause()
	video_stream_player.stream = Globals.current_video.video_stream
	title_label.text = Globals.current_video.title
	fullscreen_title_label.text = Globals.current_video.title
	profile_picture_texture_rect.texture = Globals.current_video.profile_picture
	channel_label.text = Globals.current_video.channel_handle
	
	fullscreen_video_stream_player.stream = Globals.current_video.video_stream
	video_stream_player.play()
	video_pos_slider.max_value = video_stream_player.get_stream_length()
	fullscreen_video_pos_slider.max_value = fullscreen_video_stream_player.get_stream_length()
	_change_volume(1)


func _stop_playing():
	video_stream_player.stop()


func _pause():
	pausing = !pausing
	video_stream_player.paused = pausing
	fullscreen_video_stream_player.paused = pausing
	
	if pausing:
		if fullscreen:
			var _scale_tween = create_tween()
			_scale_tween.tween_property(fullscreen_pause_button, "scale", Vector2.ONE, animation_length)
			
			var _alpha_tween = create_tween()
			_alpha_tween.tween_property(fullscreen_pause_button, "self_modulate:a", 1, animation_length)
		else:
			var _scale_tween = create_tween()
			_scale_tween.tween_property(pause_button, "scale", Vector2.ONE, animation_length)
			
			var _alpha_tween = create_tween()
			_alpha_tween.tween_property(pause_button, "self_modulate:a", 1, animation_length)
	else:
		if fullscreen:
			var _scale_tween = create_tween()
			_scale_tween.tween_property(fullscreen_pause_button, "scale", Vector2(.5, .5), animation_length)
			
			var _alpha_tween = create_tween()
			_alpha_tween.tween_property(fullscreen_pause_button, "self_modulate:a", 0, animation_length)
		else:
			var _scale_tween = create_tween()
			_scale_tween.tween_property(pause_button, "scale", Vector2(.5, .5), animation_length)
			
			var _alpha_tween = create_tween()
			_alpha_tween.tween_property(pause_button, "self_modulate:a", 0, animation_length)
	

func _set_hovering(value : bool) -> void:
	hovering = value
	
	if fullscreen:
		if hovering:
			var _bottom_bar_tween = create_tween()
			_bottom_bar_tween.tween_property(fullscreen_bottom_bar, "modulate:a", 1, animation_length)
			
			var _title_label_tween = create_tween()
			_title_label_tween.tween_property(fullscreen_title_label, "modulate:a", 1, animation_length)
		else:
			if not dragging_video_slider:
				var _bottom_bar_tween = create_tween()
				_bottom_bar_tween.tween_property(fullscreen_bottom_bar, "modulate:a", 0, animation_length)
				
				var _title_label_tween = create_tween()
				_title_label_tween.tween_property(fullscreen_title_label, "modulate:a", 0, animation_length)
	else:
		if hovering:
			var _bottom_bar_tween = create_tween()
			_bottom_bar_tween.tween_property(bottom_bar, "modulate:a", 1, animation_length)
		else:
			if not dragging_video_slider:
				var _bottom_bar_tween = create_tween()
				_bottom_bar_tween.tween_property(bottom_bar, "modulate:a", 0, animation_length)
		


func _on_video_pos_slider_drag_started() -> void:
	dragging_video_slider = true


func _on_video_pos_slider_drag_ended(_value_changed: bool) -> void:
	if fullscreen:
		fullscreen_video_stream_player.stream_position = fullscreen_video_pos_slider.value
		dragging_video_slider = false
	else:
		video_stream_player.stream_position = video_pos_slider.value
		dragging_video_slider = false


func _change_volume(value: float) -> void:
	if value > 0:
		last_volume = value
	
	if fullscreen:
		fullscreen_video_stream_player.volume = value
	else:
		video_stream_player.volume = value
	
	volume_slider.value = value
	fullscreen_volume_slider.value = value


func _on_mute_button_pressed() -> void:
	if muted:
		muted = false
		_change_volume(last_volume)
	else:
		muted = true
		_change_volume(0)


func _set_fullscreen(value : bool) -> void:
	if main.current_view == main.Views.Video or main.current_view == main.Views.VideoFullscreen:
		fullscreen = value
		await get_tree().create_timer(0.01).timeout
		
		if fullscreen:
			fullscreen_ui.show()
			main.current_view = main.Views.VideoFullscreen
			fullscreen_mouse_timer = fullscreen_mouse_timer_length
			
			fullscreen_video_stream_player.stream = Globals.current_video.video_stream
			fullscreen_video_stream_player.play()
			fullscreen_video_stream_player.stream_position = video_stream_player.stream_position
			video_stream_player.stop()
			
			fullscreen_video_stream_player.paused = pausing
			if pausing:
				fullscreen_pause_button.size = Vector2.ONE
				fullscreen_pause_button.self_modulate.a = 1
			else:
				fullscreen_pause_button.size = Vector2(.5, .5)
				fullscreen_pause_button.self_modulate.a = 0
		else:
			fullscreen_ui.hide()
			main.current_view = main.Views.Video
			
			video_stream_player.stream = Globals.current_video.video_stream
			video_stream_player.play()
			video_stream_player.stream_position = fullscreen_video_stream_player.stream_position
			fullscreen_video_stream_player.stop()
			
			video_stream_player.paused = pausing
			if pausing:
				pause_button.size = Vector2.ONE
				pause_button.self_modulate.a = 1
			else:
				pause_button.size = Vector2(.5, .5)
				pause_button.self_modulate.a = 0
