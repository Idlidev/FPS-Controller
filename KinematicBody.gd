extends KinematicBody

var speed = 20
var acceleration = 15
var air_acceleration = 5
var gravity = 0.98
var max_terminal_velocity = 54
var jump_power = 20

var default_speed = 14

var direction = Vector3()

var mouse_sensitivity = 0.3
var min_p = -90
var max_p= 90

var velocity : Vector3
var y_velocity : float
var sprinting = false
var fall = Vector3()
var ads_anim_played = false

onready var pivot = $Spatial
onready var camera = $Spatial/Camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _physics_process(delta):
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("ui_accept"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	direction = Vector3()


func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		pivot.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		pivot.rotation_degrees.x = clamp(pivot.rotation_degrees.x, min_p, max_p)



func _process(delta):
	handle_movement(delta)
	
func handle_movement(delta):

	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x

	if is_on_floor():
		y_velocity = -0.01
	
	else:
		y_velocity = clamp(y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		y_velocity = jump_power

	
	direction = direction.normalized()
	
	var accel = acceleration if is_on_floor() else air_acceleration
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	velocity.y = y_velocity
	velocity = move_and_slide(velocity, Vector3.UP)
