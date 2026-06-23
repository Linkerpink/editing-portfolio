extends CanvasLayer

@onready var cursor_control : Control = $CursorControl
@onready var cursor_visual : Control = $CursorControl/CursorVisual

@onready var cursor_outline: TextureRect = $CursorControl/CursorVisual/CursorOutline
@onready var cursor_body: TextureRect = $CursorControl/CursorVisual/CursorBody
@onready var cursor_shadow: TextureRect = $CursorControl/CursorVisual/CursorShadow

@onready var animation_player : AnimationPlayer = $CursorControl/CursorVisual/AnimationPlayer

@export var cursor_colors : Array[Color]
@export var cursor_textures : Array[CompressedTexture2D]

var cursor_color : Color
var cursor_number : int = 0


func _ready() -> void:
	set_cursor_color(cursor_colors[0])
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _process(_delta: float) -> void:
	cursor_control.set_position(cursor_control.get_global_mouse_position())
	
	if Input.is_action_just_pressed("click"):
		cursor_shadow.texture = cursor_textures[6]
		cursor_body.texture = cursor_textures[7]
		cursor_outline.texture = cursor_textures[8]
	
	if Input.is_action_just_released("click"):
		cursor_shadow.texture = cursor_textures[0]
		cursor_body.texture = cursor_textures[1]
		cursor_outline.texture = cursor_textures[2]


func show_cursor(value):
	if value:
		animation_player.play("show")
	else:
		animation_player.play_backwards("show")


func set_cursor_color(_color : Color):
	cursor_color = _color
	cursor_outline.self_modulate = _color
