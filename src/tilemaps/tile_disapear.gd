extends TileMapLayer
@onready var area_2d: Area2D = $Area2D


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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D, source: Area2D) -> void:
	"""var tween3 = get_tree().create_tween()
	tween3.tween_property(sprite, "modulate:a", 0.0, 1.0)"""
	
	await get_tree().create_timer(1).timeout
	
	var coord = self.local_to_map(source.position)
	self.set_cell(coord,-1)
