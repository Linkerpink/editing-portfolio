extends Node3D


func _process(delta: float) -> void:
	rotate_x(delta / 25)
	rotate_y(delta / 20)
	rotate_z(delta / 22.5)
