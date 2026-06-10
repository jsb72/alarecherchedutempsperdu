extends Node2D

@onready var parallax_1: Parallax2D = $Parallax1
@onready var tile_map_layer_1: TileMapLayer = $TileMapLayer1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(1,14):#1 à 13
		var new_p = parallax_1.duplicate()
		var new_scale = 0.2+float(i)/10
		new_p.scroll_scale=Vector2(new_scale,new_scale)
		if new_scale < 1.0 :
			new_p.z_index=-1
		if new_scale == 1.0 :
			new_p.z_index=1
		if new_scale > 1.0 :
			new_p.z_index=6
		$".".add_child(new_p)  
		
		var new_t = tile_map_layer_1.duplicate()
		var new_scale_tile = float(i)/20
		new_t.scale=Vector2(new_scale_tile,new_scale_tile)
		new_p.add_child(new_t)  
		
		
		var x_min =-250
		var x_max = 100 
		if new_scale == 1.0 :
			x_min = -90
			x_max = 10
			
		if new_scale == 1.1 :
			x_min = -100
			x_max = 9
		if new_scale == 1.2 :
			x_min = -105
			x_max = 8
		if new_scale == 1.3 :
			x_min = -105
			x_max = 7
		if new_scale == 1.4 :
			x_min = -110
			x_max = 6
			
		if new_scale == 1.5 :
			x_min = -120
			x_max = 5
		var y_min =-250
		var y_max = 100 
		for x in range(x_min,x_max):
			for y in range(y_min,y_max):
				var do_set_tile = randi_range(0, 150)
				if do_set_tile==0:
					new_t.set_cell(Vector2(x,y),0,Vector2(randi_range(6, 11),randi_range(1, 7)))
					
				
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
