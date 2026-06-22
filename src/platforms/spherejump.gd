extends Area2D
@onready var animation_player: AnimationPlayer = $AntialiasedRegularPolygon2D/AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.is_sliding=false
		body.is_bouncing=true
		
		body.global_position.y=global_position.y
		body.velocity.y = -800
		
		body.apply_stretch()
		body.try_play_new_anim("jumpup")
		body.groundshaketimer.start()
		body.jump_particle.restart()
		
		
		animation_player.play("new_animation")
		audio_stream_player_2d.play()
		
func _on_body_exited(body: Node2D) -> void:
	pass
