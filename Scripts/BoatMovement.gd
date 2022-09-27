extends KinematicBody2D

#https://www.reddit.com/r/gamedev/comments/6fftbz/help_with_simplifying_sailing_physics/
#https://github.com/omarreis/SailboatBox2d/
#https://github.com/omarreis/SailboatBox2d/wiki

export(int) var sail_area:int = 10

#https://data.orc.org/public/WPub.dll/CC/164467
var angles = [52,60,75,90,110,120,135,150]
var wind_velocities = [6,8,10,12,14,16,20]
var velocities = [
	[5.59, 6.69, 7.51, 7.88, 8.01, 8.08, 8.20],
	[5.95,7.06, 7.76, 8.08, 8.23, 8.31, 8.40],
	[6.46, 7.59, 8.06, 8.27, 8.5, 8.66, 8.81],
	[6.7, 7.79, 8.29, 8.58, 8.77, 8.95, 9.34],
	[6.47, 7.64, 8.22, 8.64, 9.08, 9.51, 10.13],
	[6.11, 7.38, 8.12, 8.59, 9.06, 9.55, 10.41],
	[5.47, 6.78, 7.77, 8.3, 8.76, 9.28, 10.54],
	[4.62, 5.82, 6.91, 7.77, 8.27, 8.7, 9.72],
]
var beat_angles = [43.8, 42.0, 41.2, 40.0, 39.0, 38.7, 38.1]
var gybe_angles = [142.6, 147.1, 149.8, 155.2, 163.1, 175.4, 177.2]

var beat_velocities = [3.62, 4.43, 5.08, 5.47, 5.64, 5.72, 5.90]
var run_velocities = [4.00, 5.04, 5.98, 6.79, 7.43, 7.99, 8.82]


onready var sim = get_parent()
onready var sail = get_node("Sail")

func _ready():
	pass

func true_wind():
	return sim.get_wind(position)

func apparent_wind(wind_dir: Vector2, boat_dir: Vector2) -> Vector2:
	return wind_dir - boat_dir

var acceleration: float = 100.0
var MAX_SPEED:float = 1000.0

func velocity(boat_angle:float, true_wind_angle:float = 0.0, dead_angle:float = PI/12):
	var velocity = 1 - exp(- pow(true_wind_angle - boat_angle,2) / dead_angle)
	return acceleration * velocity

func _process(delta):
	var true_wind: Vector2 = sim.get_wind(global_position)
	var boat_angle: float = abs(rad2deg(global_transform.x.angle_to(true_wind)))
	print(boat_angle)
#	var velocity = min(velocity(boat_angle),MAX_SPEED)
#	move_and_slide(velocity * global_transform.x)
	# Sail force: 
	# Sail force is calculated by taking the cosine 
	# of the angle between apparent wind and sail 
	# multiplied by the cosine of the angle between 
	# sail and ship multiplied by the apparent 
	# windspeed squared multiplied by the area of 
	# the sail.
#	var true_wind: Vector2 = true_wind() 
#	var true_wind: float = 0.0
#	var boat_angle: float = global_transform.x.angle_to(Vector2.UP)
#	print(boat_angle)
#	var velocity = velocity(boat_angle, true_wind)
#	sail.apply_force(true_wind)
#	var wind_speed = true_wind.length()
#	var boat_dir: Vector2 = transform.x
#	var apparent_wind:Vector2 = apparent_wind(true_wind, boat_dir)
#
#	var sail_dir: Vector2 = sail.transform.y
#
#	var wind_to_sail_angle: float = apparent_wind.angle_to(sail_dir)
#	var sail_to_boat_angle: float = sail_dir.angle_to(boat_dir)
#	print(wind_to_sail_angle * sail_to_boat_angle)
	
	update()

#func _draw():
#	var true_wind: Vector2 = true_wind()
#	var wind_speed = true_wind.length()
#	var boat_dir: Vector2 = transform.x
#	var apparent_wind:Vector2 = apparent_wind(true_wind, boat_dir)
#
#	var sail_dir: Vector2 = -sail.global_transform.y
##	print(sail_dir)
#
#	var wind_to_sail_angle: float = apparent_wind.angle_to(sail_dir)
#	var sail_to_boat_angle: float = -sail_dir.angle_to(boat_dir)
#	var speed = sail_to_boat_angle*wind_to_sail_angle
	
#	var force = 
#	print(speed)
#	draw_line(Vector2.ZERO, 200*speed*boat_dir,Color.red, 10)
#	draw_line(Vector2.ZERO, 200*true_wind, Color.blue, 5)
#	draw_line(Vector2.ZERO, 200*apparent_wind, Color.blue, 5)
#	draw_line(sail.position, sail.position + 200*sail_dir, Color.yellow, 5)
#	var true_wind: float = 0.0
#	var boat_angle: float = global_transform.x.angle_to(Vector2.UP)
#	print(boat_angle)
#	var velocity = velocity(boat_angle, true_wind)
#	draw_line(Vector2.ZERO, Vector2.RIGHT*velocity, Color.blue, 5)

func _input(event):
	if event.is_action("rotate_left"):
		rotation_degrees -= 5
#		sail.rotation_degrees += 5
	elif event.is_action("rotate_right"):
#		sail.rotation_degrees -= 5
		rotation_degrees += 5

