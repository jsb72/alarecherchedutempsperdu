extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	"""var random_reverse:int=randf_range(0, 1)
	if random_reverse:
		animation_player.play_backwards("new_animation")
	else:
		animation_player.play("new_animation")"""
	animation_player.speed_scale=randf_range(0.2, 0.5)
	animation_player.play("new_animation")	
		# Get a random time between 0 and the total length of the animation
	var random_time: float = randf_range(0.0, animation_player.current_animation_length)
		
		# Advance the player to that random position
	animation_player.seek(random_time, true)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
