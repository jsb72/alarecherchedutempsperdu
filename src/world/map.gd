extends Node2D

@onready var map: Node2D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("var world_map={")
	for room in map.find_children("*","ColorRect",false):
		var room_dict = {
			"filename" : room.get_scene_file_path(),
			"global_position" : room["global_position"],
			"size" : room["size"]
		}	
		
		print(room_dict)
		print(",")
	print("}")	
	"""
	var d = {
		print(room["name"] = {
			print("filename" = room.get_scene_file_path(),
			print("global_position" = room["global_position"],
			print("size" = room["size"]
		},
		room["name"] = {
			a1 = {
				a11 = 1, a12 = 2
			},
			a2 = 3
		},
	}
	"""		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
