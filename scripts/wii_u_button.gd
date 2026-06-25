extends Button

var animation_length : float = 0.05


func _on_mouse_entered() -> void:
	Globals.select_button(self)
	
	var _scale_tween = create_tween()
	_scale_tween.tween_property(self, "scale", Vector2(1.1, 1.1), animation_length)


func _on_mouse_exited() -> void:
	var _scale_tween = create_tween()
	_scale_tween.tween_property(self, "scale", Vector2.ONE, animation_length)
