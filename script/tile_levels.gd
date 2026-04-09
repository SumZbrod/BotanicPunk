extends Node2D
@onready var back_tiles: TileMapLayer = $BackTiles
@onready var level_tiles: TileMapLayer = $LevelTiles
var noise_texture
var player: PlayerClass
var visited_chunks: Array
var non_empty_chunks: Array
var tile_d: int
var noise_h := 511
const chunk_size = 32
 
func _ready() -> void:
	tile_d = level_tiles.tile_set.tile_size.y
	player = get_tree().get_first_node_in_group('player')
	var texture = NoiseTexture2D.new()
	texture.noise = FastNoiseLite.new()
	await texture.changed
	noise_texture = texture.get_image()

func _process(_delta: float) -> void:
	if noise_texture:
		update_tile_map()

func saw(x, a):
	return a - abs(a - (abs(x) % (2*a)))

func update_tile_map():
	#var chunk_pos := (Vector2i(player.position / scale.x) / tile_d + Vector2i(1, -1)*(chunk_size/2)) / chunk_size
	@warning_ignore("integer_division")
	var chunk_pos := (Vector2i(player.position / scale.x) / tile_d ) / chunk_size
	if chunk_pos not in visited_chunks:
		var terrain_cells := []
		var back_terrain_cells := []
		visited_chunks.append(chunk_pos)
		for Y in range(-1, 2):
			for X in range(-1, 2):
				var sub_chunk = Vector2i(X, Y) + chunk_pos
				if sub_chunk in non_empty_chunks:
					continue
				non_empty_chunks.append(sub_chunk)
				for y in chunk_size:
					for x in chunk_size:
						var pix_pos = sub_chunk*chunk_size+Vector2i(x, y)
						var h = noise_texture.get_pixel(saw(pix_pos.x, noise_h), saw(pix_pos.y, noise_h)).r
						var h_2 = noise_texture.get_pixel(saw(pix_pos.y, noise_h), saw(pix_pos.x, noise_h)).r
						h *= h_2
						if (h > .45 and h < .5) or h < .1 :
							terrain_cells.append(pix_pos)
						if .05 < h and h < .3:
							back_terrain_cells.append(pix_pos)
		level_tiles.set_cells_terrain_connect(back_terrain_cells, 0, 0, false)
		level_tiles.set_cells_terrain_connect(terrain_cells, 1, 0, false)
					
