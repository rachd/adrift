extends Node2D

signal game_ended(did_win)
signal scene_ended

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2(1, 0): E, Vector2(-1, 0): W, 
				  Vector2(0, 1): S, Vector2(0, -1): N}
				
var tile_size = 48 # in pixels
var width = 15 # in tiles
var height = 9 # in tiles

var erase_fraction = 0.1

onready var Map = $TileMap

func _ready():
	randomize()
	self.connect("game_ended", get_node("/root/SailingDay"), "_on_game_output")
	self.connect("scene_ended", get_node("/root/SailingDay"), "_start_next_day")
	tile_size = Map.cell_size
	make_maze()
	yield(get_tree().create_timer(1), "timeout")
	$WaterDrop.play()
	
func check_neighbors(cell, unvisited):
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
	
func make_maze():
	var unvisited = []
	var stack = []
	Map.clear()
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2(x, y))
			Map.set_cellv(Vector2(x, y), N|E|S|W)
	var current = Vector2(0, 0)
	unvisited.erase(current)
	
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			
			var dir = next - current
			var current_walls = Map.get_cellv(current) - cell_walls[dir]
			var next_walls = Map.get_cellv(next) - cell_walls[-dir]
			Map.set_cellv(current, current_walls)
			Map.set_cellv(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
	erase_walls()

func erase_walls():
	for i in range(int(width * height * erase_fraction)):
		var x = int(rand_range(1, width-1))
		var y= int (rand_range(1, height-1))
		var cell = Vector2(x, y)
		var neighbor = cell_walls.keys()[randi() % cell_walls.size()]
		if Map.get_cellv(cell) & cell_walls[neighbor]:
			var walls = Map.get_cellv(cell) - cell_walls[neighbor]
			var n_walls = Map.get_cellv(cell + neighbor) - cell_walls[-neighbor]
			Map.set_cellv(cell, walls)
			Map.set_cellv(cell+neighbor, n_walls)
			
func _on_found_spirit():
	emit_signal("game_ended", true)
	$Fairy.play()
	
func _on_found_evil_spirit():
	emit_signal("game_ended", false)
	$Cackle.play()

func _on_spirit_sound_finished():
	emit_signal("scene_ended")
