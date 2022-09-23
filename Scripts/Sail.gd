extends Node2D

const max_angle:float = 90.0
var current_max_angle:float = 90.0
var angle: float = 0.0

var d: float = 2

func clamp_angle(angle:float) -> float:
	""" Clamp an angle between a max and min angle """
	return max(min(angle, current_max_angle), -current_max_angle)

func change_angle(delta):
	angle += delta
	angle = clamp_angle(angle)
	rotation_degrees = angle

func apply_force(dir):
	var angle: float = rad2deg(dir.angle_to(global_transform.x))
	change_angle(sign(angle)*d)


func _ready():
	pass

func _draw():
	draw_line(Vector2.ZERO, 200*transform.x,Color.purple, 10)


func _input(event):
	if event.is_action("hoist_in"):
		current_max_angle -= 5
		current_max_angle = max(current_max_angle, 0)

	elif event.is_action("hoist_out"):
		current_max_angle += 5
		current_max_angle = min(current_max_angle, max_angle)


#func _process(delta):
#	pass

