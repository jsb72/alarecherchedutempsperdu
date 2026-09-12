extends TileMapLayer

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var arr_vec = self.get_used_cells()
	for vec_elem in arr_vec:
		var new_pos = vec_elem
		new_pos *= 128
		new_pos = new_pos + Vector2i(64,64)
		print(new_pos)
		var newcol : CollisionShape2D = collision_shape_2d.duplicate()
		newcol.position=new_pos
		area_2d.add_child(newcol)
		
	collision_shape_2d.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	var tween3 = get_tree().create_tween()
	tween3.tween_property(self, "modulate:a", 0.0, 2.0)
	
	await get_tree().create_timer(2).timeout
	
	self.queue_free()
