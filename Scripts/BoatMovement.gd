extends Node2D

#https://www.reddit.com/r/gamedev/comments/6fftbz/help_with_simplifying_sailing_physics/
#https://github.com/omarreis/SailboatBox2d/
#https://github.com/omarreis/SailboatBox2d/wiki

export(int) var sail_area:int = 10


onready var sim = get_parent()
onready var sail = get_node("Sail")

func _ready():
	pass

func true_wind():
	return sim.get_wind(position)

func apparent_wind(wind_dir: Vector2, boat_dir: Vector2) -> Vector2:
	return wind_dir - boat_dir

func _process(delta):
	# Sail force: 
	# Sail force is calculated by taking the cosine 
	# of the angle between apparent wind and sail 
	# multiplied by the cosine of the angle between 
	# sail and ship multiplied by the apparent 
	# windspeed squared multiplied by the area of 
	# the sail.
	var true_wind: Vector2 = true_wind()
	sail.apply_force(true_wind)
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

func _draw():
	var true_wind: Vector2 = true_wind()
	var wind_speed = true_wind.length()
	var boat_dir: Vector2 = transform.x
	var apparent_wind:Vector2 = apparent_wind(true_wind, boat_dir)
	
	var sail_dir: Vector2 = -sail.global_transform.y
#	print(sail_dir)

	var wind_to_sail_angle: float = apparent_wind.angle_to(sail_dir)
	var sail_to_boat_angle: float = -sail_dir.angle_to(boat_dir)
	var speed = sail_to_boat_angle*wind_to_sail_angle
#	print(speed)
	draw_line(Vector2.ZERO, 200*speed*boat_dir,Color.red, 10)
	draw_line(Vector2.ZERO, 200*true_wind, Color.blue, 5)
	draw_line(Vector2.ZERO, 200*apparent_wind, Color.blue, 5)
	draw_line(sail.position, sail.position + 200*sail_dir, Color.yellow, 5)

func _input(event):
	if event.is_action("rotate_left"):
		rotation_degrees -= 5
#		sail.rotation_degrees += 5
	elif event.is_action("rotate_right"):
#		sail.rotation_degrees -= 5
		rotation_degrees += 5

