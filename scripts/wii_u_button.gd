extends Button
class_name WiiUButton

@export var shader_material : ShaderMaterial
@export var selectable : bool = true
var animation_length : float = 0.05


func _on_mouse_entered() -> void:
	if selectable:
		Globals.select_button(self)
	
	var _scale_tween = create_tween()
	_scale_tween.tween_property(self, "scale", Vector2(1.1, 1.1), animation_length)


func _on_mouse_exited() -> void:
	var _scale_tween = create_tween()
	_scale_tween.tween_property(self, "scale", Vector2.ONE, animation_length)


func turn_blue():
	shader_material.set_shader_parameter("tint", Color(0.306, 0.737, 1.0, 0.486))


func turn_white():
	shader_material.set_shader_parameter("tint", Color(0.949, 0.969, 1.0, 0.122))
