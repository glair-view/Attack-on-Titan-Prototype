extends RigidBody

# movement variables
const _MOVE_FORCE : float = 9.8
const _MAX_FRICTION : float = 10.0
var _current_speed : float = 0.0


const _CHANGE_FOV_AFTER : float = 15.0
var _mouse_sensitivity : float = 0.3
var _time : float = 0.0


# start updating fov after this speed
# grapple hook variables
var _current_wire_length_left : float
var _current_wire_length_right : float
var _max_wire_length : float = 40.0
var _reel_force : float = 12.2


# getting child nodes
onready var _camera_pivote : Spatial = $CameraPivot
onready var _camera : Camera = $CameraPivot/CameraBoom/Camera
onready var _raycast_left : RayCast = $CameraPivot/CameraBoom/Camera/RayCastLeft
onready var _raycast_right : RayCast = $CameraPivot/CameraBoom/Camera/RayCastRight
onready var _hook_point_left : Node = $HookPointLeft
onready var _hook_point_right : Node = $HookPointRight
onready var _fov_tween : GVTween = $FovTween
onready var _friction_tween : GVTween = $FrictionTween
onready var _floor_detector : RayCast = $FloorDetecter


# variables effected by settings
var strike_time : float = 0.0
var min_fov : float = 70.0
var fov_change : float = 30.0
var dont_change_fov : bool = false


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# sets up min max value of tweens
	_fov_tween.set_min_max_value(_CHANGE_FOV_AFTER, 15.0)
	_friction_tween.set_min_max_value(15.0, 100.0)

# handles aiming
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y((deg2rad(-event.relative.x * _mouse_sensitivity)))
		_camera_pivote.rotate_x((deg2rad(-event.relative.y * _mouse_sensitivity)))
		_camera_pivote.rotation.x = clamp(_camera_pivote.rotation.x, deg2rad(-90), deg2rad(90))



# updates fov based on current speed for game feel
func _update_fov() -> void:
	_camera.fov = min_fov + _fov_tween.interpolate(_current_speed) * fov_change
	_camera.fov += sin(_time) * float(_current_speed > _CHANGE_FOV_AFTER)

# update friction based inversely on current_speed
func _update_friction() -> void:
	friction = _friction_tween.interpolate(_current_speed) * _MAX_FRICTION

func is_on_floor() -> bool:
	if _floor_detector.is_colliding():
		print("hello")
	return _floor_detector.is_colliding()


func _get_active_hooks() -> Array:
	var hooks : Array = []
	
	# append all active hooks to hooks
	if _hook_point_left.is_active():
		hooks.append(_hook_point_left)
	if _hook_point_right.is_active():
		hooks.append(_hook_point_right)
	
	return hooks

# pulls player to hook points
func _reel_hooks() -> void:
	var hooks : Array = _get_active_hooks()
	var hook_speeds : Array = []
	
	# draw to all active hooks
	for i in hooks:
		pass

# handle key strokes by the player
func _handle_keys() -> void:
	
	# This is all just the space bar
	if is_on_floor() and Input.Xis_action_just_pressed("jump_or_reel_hooks"):
		# jump
		pass
	# 
	if Input.is_action_pressed("jump_or_reel_hooks"):
		# if there are active hooks reel towards hooks
		if _get_active_hooks().size() > 0:
			_reel_hooks()
		else:
			# gas forwards
			pass


func _process(delta):
	# used to calculate speed
	var current_position : Vector3 = transform.origin
	_handle_keys()
	
	# update current speed
	_current_speed = current_position.distance_to(transform.origin)
	_update_friction()
	if not dont_change_fov:
		_time += delta
		_update_fov()
	
	
	
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
