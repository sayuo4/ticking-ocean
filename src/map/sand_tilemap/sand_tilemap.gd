extends TileMapLayer

const SAND_TILESET_SOURCE_ID: int = 0
const SPIKES_SOURCE_ID: int = 1
const FILLED_CORNER_SAND_TILESET_SOURCE_ID: int = 2

func _ready() -> void:
	replace_cells()

func replace_cells() -> void:
	for cell: Vector2i in get_used_cells():
		replace_cell(cell)

func replace_cell(coords: Vector2i) -> void:
	if get_cell_source_id(coords) != SAND_TILESET_SOURCE_ID:
		return
	
	var dirs: Array[Vector2i] = [
		Vector2i.RIGHT,
		Vector2i.LEFT,
		Vector2i.UP,
		Vector2i.DOWN,
	]
	
	for dir: Vector2i in dirs:
		if get_cell_source_id(coords + dir) == SPIKES_SOURCE_ID:
			var atlas_coords: Vector2i = get_cell_atlas_coords(coords)
			
			set_cell(coords, FILLED_CORNER_SAND_TILESET_SOURCE_ID, atlas_coords)
			return
