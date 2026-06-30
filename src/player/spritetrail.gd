extends Node

@onready var sprite: AnimatedSprite2D = $"../Sprite"
@onready var player: Player = $".."
@onready var trailplayer: Node2D = $"../../trailplayer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.state_str_for_anim!="DashState":
		return
	"""if player.state_machine.active_state is not DashState:
		return"""
		
	var newSprite : AnimatedSprite2D = sprite.duplicate()
	
	newSprite.global_position = player.global_position+sprite.position
	
	newSprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	trailplayer.add_child(newSprite)
	newSprite.play("dash")
	newSprite.startFading()
