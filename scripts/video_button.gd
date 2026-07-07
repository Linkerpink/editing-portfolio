extends Control

@export var video : Video

@onready var texture_rect : TextureRect = %TextureRect
@onready var profile_picture_texture_rect : TextureRect = %ProfilePictureTextureRect
@onready var title_label: Label = %TitleLabel
@onready var channel_label : Label = %ChannelLabel
var main : Main


func _ready() -> void:
	await get_tree().process_frame
	main = get_tree().get_first_node_in_group("main")
	
	texture_rect.texture = video.thumbnail
	title_label.text = video.title
	profile_picture_texture_rect.texture = video.profile_picture
	channel_label.text = str(video.channel_handle)


func _on_wii_u_button_pressed() -> void:
	Globals.current_video = video.video_stream
	main.instantiate_video_ui()
