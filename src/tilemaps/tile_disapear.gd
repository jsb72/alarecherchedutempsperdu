extends TileMapLayer
@onready var area_2d: Area2D = $Area2D

@onready var tile_map_layer_tmp: TileMapLayer = $TileMapLayerTMP
@onready var tile_map_layer_back: TileMapLayer = $TileMapLayerBack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var arr_vec = self.get_used_cells()
	for vec_elem in arr_vec:
		var new_pos = vec_elem
		new_pos *= 128
		new_pos = new_pos 
		var newcol : Area2D = area_2d.duplicate()
		newcol.position=new_pos
		self.add_child(newcol)
		
		
	area_2d.queue_free()
	
	tile_map_layer_tmp.set_cells_terrain_connect(self.get_used_cells(),0,0)
	tile_map_layer_back.set_cells_terrain_connect(tile_map_layer_tmp.get_used_cells(),0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D, source: Area2D) -> void:
	var coord:Vector2i = self.local_to_map(source.position)
	
	if tile_map_layer_tmp.get_cell_atlas_coords(coord)==Vector2i(-1, -1):return
	
	self.self_modulate.a=1.0
	
	tile_map_layer_tmp.erase_cell(coord)
	
	copy_tilemap_back(coord)
	
	update_tilemap_front(coord)
	
func update_tilemap_front(coord:Vector2i)->void:
	var tween3 = get_tree().create_tween()
	tween3.tween_property(self, "self_modulate:a", 0.0, 1)
	
	await get_tree().create_timer(1).timeout
	
	self.erase_cell(coord)
	
	"""var tween32 = get_tree().create_tween()
	tween32.tween_property(self, "self_modulate:a", 1.0, 1.0)"""
	
func copy_tilemap_back(coord:Vector2i)->void:
	tile_map_layer_back.erase_cell(coord)
	"""tile_map_layer_back.clear() 
	tile_map_layer_back.set_cells_terrain_connect(tile_map_layer_tmp.get_used_cells(),0,0)"""
	
