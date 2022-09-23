extends Node2D

#https://www.reddit.com/r/gamedev/comments/6fftbz/help_with_simplifying_sailing_physics/
#https://github.com/omarreis/SailboatBox2d/
#https://github.com/omarreis/SailboatBox2d/wiki


onready var sim = get_parent()
onready var sail = get_node("Sail")

func _ready():
	pass


func _process(delta):
	var true_wind:Vector2 = sim.get_wind(position).normalized()
	var forward:Vector2 = transform.x
	var apparent_wind: Vector2 = calc_apparent_wind(true_wind, forward)
	
#	var forward = sail.transform.x.normalized()
#	print(wind_dir.dot(forward))
	update()

func rotate_to_opt_angle(sail, apparent_wind:Vector2, sail_area:int):
	pass

func _draw():
	pass

var boat_velocity: Vector2

func add_lift_force_to_sail(sail:Node2D, true_wind:Vector2, sail_area:float):	
	var apparent_wind: Vector2 = calc_apparent_wind(true_wind, boat_velocity)
	var sail_direction: Vector2 = sail.transform.x
	
	var apparent_wind_angle: int = sail_direction.angle_to(-apparent_wind)
	var lift_coef: float = get_coefficient_at_angle(angle_to_lift_coefficients, apparent_wind_angle)
	var wind_velocity: float = apparent_wind.length()
	
	var lift_force_dir: Vector2 = calc_lift_direction(apparent_wind, sail_direction)
	var sail_lift_force: float = calc_sail_force(lift_coef, wind_velocity, sail_area)
	var sail_lift_force_vector: Vector2 = lift_force_dir * sail_lift_force
	
	return sail_lift_force_vector



func calc_lift_direction(apparent_wind: Vector2, sail_vector:Vector2) -> Vector2:
	var lift_angle: float = -apparent_wind.normalized().angle_to(sail_vector.normalized()) - 180.0 # SIGNED angle
	if abs(lift_angle) < 180:
		lift_angle = -90 * sign(lift_angle)
	else:
		lift_angle = 90 * sign(lift_angle)
	
	#lift angle is always 90 degree to the apparent wind, but has left or right direction
	var lift_force_dir: Vector2 = apparent_wind.rotated(deg2rad(lift_angle))
	return lift_force_dir
	

func rotate_vector_by_degrees(original_vector: Vector2, degree:float):
	return 
	
func get_coefficient_at_angle(angle_to_coef: Array, angle:int) -> float:
	var coef:float = 0.0
	if angle < 0:
		coef = 0.0
	elif 180 < angle:
		coef = angle_to_coef[360 - angle]
	else:
		coef = angle_to_coef[angle]
	return coef


var angle_to_lift_coefficients: Array = prepare_sail_lift_coefficients()
var angle_to_drag_coefficients: Array = prepare_sail_drag_coefficients()

func prepare_sail_drag_coefficients():
	var coef_at_angle:Array = []
	for i in range(100):
		var angle = calc_drag_coefficients(i)
		coef_at_angle.append(angle)
	return coef_at_angle

func prepare_sail_lift_coefficients():
	var coef_at_angle:Array = []
	for i in range(100):
		var angle = calc_lift_coefficients(i)
		coef_at_angle.append(angle)
	return coef_at_angle
	
	

func calc_lift_coefficients(x: float):
	var y = \
	- 0.00236451049 * pow(x, 4) / pow(10, 4) \
	+ 0.06606934732 * pow(x, 3) / pow(10, 3) \
	- 0.6590661422  * pow(x, 2) / pow(10, 2) \
	+ 2.533863636 * pow(x, 1) / pow(10, 1) \
	- 1.7391666
	return y

func calc_drag_coefficients(x: float):
	var y = \
	+ 0.001168609 * pow(x, 3) / pow(10, 3) \
	+ 0.013543124 * pow(x, 2) / pow(10, 2) \
	+ 0.017943279 * pow(x, 1) / pow(10, 1) \
	+ 0.127066667
	return y

func calc_apparent_wind(wind_dir: Vector2, boat_dir: Vector2) -> Vector2:
	return wind_dir - boat_dir

func calc_sail_force(lift_coefficient:float, velocity:float, sail_area:float) -> float:
	var air_rho: float = 1.2
	return 0.5 * air_rho * velocity * velocity * sail_area * lift_coefficient

func _input(event):
	if event.is_action("rotate_left"):
		sail.rotation_degrees += 5
	elif event.is_action("rotate_right"):
		sail.rotation_degrees -= 5

