extends AnimatableBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation=randfn(0.0, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if !body.dead_:
			body.play_death_anim()
			body.dmgshaketimer.start()
			audio_stream_player_2d.play()
			
			sprite_2d.material.set_shader_parameter("hit_effect", 1)
			await get_tree().create_timer(1).timeout
			sprite_2d.material.set_shader_parameter("hit_effect", 0)
