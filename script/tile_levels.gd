extends Node2D
@onready var back_tiles: TileMapLayer = $BackTiles
@onready var level_tiles: TileMapLayer = $LevelTiles
var noise_data
var player: PlayerClass
var chunks: Array
var tile_size: Vector2i

const chunk_size = 512
 
func _ready() -> void:
	tile_size = level_tiles.tile_set.tile_size
	player = get_tree().get_first_node_in_group('player')
	var texture = NoiseTexture2D.new()
	texture.noise = FastNoiseLite.new()
	await texture.changed
	noise_data = texture.get_image()
	#noise_data = image.get_data()

func _process(_delta: float) -> void:
	if noise_data:
		update_tile_map()

func update_tile_map():
	var chunk_pos := Vector2i(player.global_position / chunk_size)
	if chunk_pos not in chunks:
		@warning_ignore("integer_division")
		var D := chunk_size / tile_size.y
		print('chunk_pos ', chunk_pos)
		chunks.append(chunk_pos)
		for y in D:
			for x in D:
				var h = noise_data.get_pixel(x*tile_size.x, y*tile_size.y).r
				if h > .75:
					level_tiles.set_cell(chunk_pos+Vector2i(x, y), 1, Vector2i(1, 3))
					
