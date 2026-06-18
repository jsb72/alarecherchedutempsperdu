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
		if 1 or body.state_machine.active_state is FallState:
			#body.jump()
			"""body.velocity.y = -1000
			body.apply_stretch()"""
			
			body.velocity.y = -900
			
			body.apply_stretch()
			body.try_play_new_anim("jumpup")
			#body.jump_sound.play()
			body.jump_particle.restart()
			body.is_sliding=false
			
			
			animation_player.play("new_animation")
			audio_stream_player_2d.play()
			body.groundshaketimer.start()
			#body.velocity = body.velocity*1.66
			"""if Input.is_action_pressed("interaction"):
				body.velocity = body.velocity*1.66"""
			"""if Input.is_action_pressed("interaction"):
				body.jump()"""
		
func _on_body_exited(body: Node2D) -> void:
	pass
