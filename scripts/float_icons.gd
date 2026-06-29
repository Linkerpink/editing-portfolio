extends Node3D


func _process(delta: float) -> void:
	rotate_x(delta / 30)
	rotate_y(delta / 25)
	rotate_z(delta / 27.5)
