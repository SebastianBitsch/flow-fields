extends Node2D

export(Vector2) var origin = Vector2.ZERO

export(int) var grid_resolution = 35
export(Vector2) var vector_size = Vector2(25,2)

# Grid parameters
var grid_size = Vector2.ONE
var grid_positions = []
var grid_vectors = []

# Noise parameters
var noise = OpenSimplexNoise.new()
var noise_offset = Vector2.ZERO

# Drop parameters
var drop_interval:int = 100
var last_drop_time:int = OS.get_system_time_msecs()
var drop_points = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]
var ball_speed: float = 2.5

var ball_positions = []
var ball_velocities = []

var noise_scroll_speed: float = 0.04

func _ready():
	var window_size = get_viewport().size
	grid_size = (window_size / grid_resolution) + Vector2.ONE
	grid_size = Vector2(int(grid_size.x), int(grid_size.y))
	drop_points[0] = window_size / 2.0 + Vector2(0, 150)
	drop_points[1] = window_size / 2.0 + Vector2(0, -150)
	drop_points[2] = window_size / 2.0 + Vector2(-300,0)
	drop_points[3] = window_size / 2.0 + Vector2(300,0)
	
	noise.seed = randi()
	noise.octaves = 2
	noise.period = 16
	noise.persistence = 0.8

	for x in range(grid_size.x):
		var p = []
		var v = []
		for y in range(grid_size.y):
			var abs_pos = Vector2(x,y)*grid_resolution
			p.append(origin + abs_pos)
#			var angle = PI
			var angle = 2*PI*noise.get_noise_2d(x,y)
			v.append(unit_vector(angle))
			
		grid_positions.append(p)
		grid_vectors.append(v)
	drop()


func _process(delta):
	print(Engine.get_frames_per_second())
	
	if drop_interval + last_drop_time < OS.get_system_time_msecs():
		last_drop_time = OS.get_system_time_msecs()
		drop()
	
	noise_offset += Vector2(randf(), randf())*noise_scroll_speed
	
	for i in range(len(ball_positions)):
		var coords = grid_coords(ball_positions[i])

		var x = coords[0]
		var y = coords[1]
		if x < 0 or grid_size.x <= x or y < 0 or grid_size.y <= y:
#			ball_positions.pop_front()
#			ball_positions.pop_front()
			continue

		ball_velocities[i] = grid_vectors[x][y].normalized() * ball_speed
		ball_positions[i] += ball_velocities[i]
	
#	drop_point += Vector2(sin(20*delta),0)
	update()

func drop():
	for d in drop_points:
		ball_positions.append(d)
		ball_velocities.append(Vector2.ZERO)

func _draw():
	
	# Draw vectors
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var pos = grid_positions[x][y]
			var angle = 2*PI*noise.get_noise_2d(x+noise_offset.x,y+noise_offset.y)
			
			var vec = unit_vector(angle) * vector_size.x
			grid_vectors[x][y] = vec
			var c = Color.white # Color.from_hsv(angle+1, 1.0, 1.0)
			draw_line(pos, pos+vec, c, vector_size.y)
			draw_circle(pos+vec, 3, c)

	# Draw balls
	for i in range(len(ball_positions)):
		draw_circle(ball_positions[i],5.0,Color.orange)
	
	# Draw spawnpoint
	for d in drop_points:
		draw_circle(d, 10.0, Color.orange)


func grid_coords(world_coords):
	var c = (world_coords - origin) / grid_resolution
	return [int(c.x), int(c.y)]

func unit_vector(theta):
	return Vector2(cos(theta), sin(theta))

func _input(event):
	if event.is_action("ui_cancel"):
		get_tree().quit()
