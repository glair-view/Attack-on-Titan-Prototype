extends Node
# extends node as to not inherent parent's position

var _active : bool = false
var _position : Vector3 = Vector3.ZERO

func set_active(active : bool) -> void:
	_active = active

func is_active() -> bool:
	return _active

func set_position(position : Vector3) -> void:
	_position = position

func get_position() -> Vector3:
	return _position
