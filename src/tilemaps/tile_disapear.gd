extends TileMapLayer
@onready var area_2d: Area2D = $Area2D

@onready var tile_map_permanent: TileMapLayer = $TileMapPermanent


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
	
	tile_map_permanent.set_cells_terrain_connect(self.get_used_cells(),0,0)
	self.self_modulate.a=0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func _on_area_2d_body_entered(body: Node2D, source: Area2D) -> void:
	
	var coord:Vector2i = self.local_to_map(source.position)
	
	if self.get_cell_atlas_coords(coord)==Vector2i(-1, -1):return
	
	self.erase_cell(coord)

	var tilemap_new_a_dissoudre : TileMapLayer = tile_map_permanent.duplicate()
	add_child(tilemap_new_a_dissoudre)
	#move_child(tilemap_tmp, 0)
	
	tile_map_permanent.erase_cell(coord)
	
	
	var tween3 = get_tree().create_tween()
	tween3.tween_property(tilemap_new_a_dissoudre, "self_modulate:a", 0.0, 2)
	
	await get_tree().create_timer(2).timeout
	#tilemap_new_a_dissoudre.erase_cell(coord)
	tilemap_new_a_dissoudre.queue_free()
	#set_deferred("process_mode",tilemap_new_a_dissoudre.PROCESS_MODE_DISABLED)
	
	
	#self.self_modulate.a=1.0
	
	"""var tween3 = get_tree().create_tween()
	tween3.tween_property(self, "self_modulate:a", 0.0, 1)
	
	await get_tree().create_timer(1).timeout
	
	self.erase_cell(coord)"""
	
	"""var tween32 = get_tree().create_tween()
	tween32.tween_property(self, "self_modulate:a", 1.0, 1.0)"""
	#tile_map_layer_back.erase_cell(coord)
	"""tile_map_layer_back.clear() 
	tile_map_layer_back.set_cells_terrain_connect(tile_map_layer_tmp.get_used_cells(),0,0)"""
	
