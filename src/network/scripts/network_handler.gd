extends Node

const IP_ADDRESS:String="176.31.252.194"#""
const PORT:int=7272
const MAX_CLIENTS:int=32#default 32
var peer:ENetMultiplayerPeer


func start_server()->void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	
	
func start_client()->void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
