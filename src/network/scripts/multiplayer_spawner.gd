extends MultiplayerSpawner

@export var network_player:PackedScene



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(despawn_player)
	#spawn_player(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_player(id:int)->void:
	if !multiplayer.is_server():return
	
	var player:Node = network_player.instantiate()
	
	player.name=str(id)
	
	get_node(spawn_path).call_deferred("add_child",player)

func despawn_player(id:int)->void:
	if !multiplayer.is_server():return
	
	get_node("/root/example/"+str(id)).queue_free()
	
	
	
