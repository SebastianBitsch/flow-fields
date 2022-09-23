extends Node2D

#https://www.reddit.com/r/Seaofthieves/comments/d8lif7/physics_based_sailing_mechanics_with_diagrams/
#https://www.reddit.com/r/Games/comments/355kej/why_has_nobody_made_a_good_open_world_sailing_game/
#https://github.com/vlytsus/unity-3d-boat/blob/cf17525846dd67147b21ee479b7e6e1572c27b92/Assets/Scenes/BoatForces.cs
#https://vlytsus.medium.com/my-sailing-story-unity-game-development-part-1-6b6c5e7f3844


export(Vector2) var origin = Vector2.ZERO

export(int) var grid_resolution = 35
export(Vector2) var vector_size = Vector2(25,2)

var window_size = Vector2.ZERO

# Grid parameters
var grid_size = Vector2.ONE
var grid_positions = []
var grid_vectors = []

# Noise parameters
var noise = OpenSimplexNoise.new()
var noise_offset = Vector2.ZERO


var wind_speed: float = 0.04

func _ready():
	window_size = get_viewport().size
	grid_size = (window_size / grid_resolution) + Vector2.ONE
	grid_size = Vector2(int(grid_size.x), int(grid_size.y))
	
	noise.seed = randi()
	noise.octaves = 2
	noise.period = 100
	noise.persistence = 0.8

	for x in range(grid_size.x):
		var p = []
		var v = []
		for y in range(grid_size.y):
			var abs_pos = Vector2(x,y)*grid_resolution
			p.append(origin + abs_pos)
			var angle = 0.5*PI
#			var angle = 2*PI*noise.get_noise_2d(x,y)
			v.append(unit_vector(angle))
			
		grid_positions.append(p)
		grid_vectors.append(v)
	

func get_wind(pos):
	var grid_pos = grid_coords(pos)
	return grid_vectors[grid_pos.x][grid_pos.y]

func _process(delta):
#	print(Engine.get_frames_per_second())
	
	
#	noise_offset += Vector2(randf(), randf())*wind_speed
	
	update()


func _draw():
	
	# Draw vectors
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var pos = grid_positions[x][y]
			var angle = 0.5*PI
#			var angle = 2*PI*noise.get_noise_2d(x+noise_offset.x,y+noise_offset.y)
			
			var vec = unit_vector(angle) * vector_size.x
			grid_vectors[x][y] = vec
			var c = Color.white # Color.from_hsv(angle+1, 1.0, 1.0)
			draw_line(pos, pos+vec, c, vector_size.y)
			draw_circle(pos+vec, 3, c)



func grid_coords(world_coords):
	var c = (world_coords - origin) / grid_resolution
	return Vector2(int(c.x), int(c.y))

func unit_vector(theta):
	return Vector2(cos(theta), sin(theta))

func _input(event):
	if event.is_action("ui_cancel"):
		get_tree().quit()
