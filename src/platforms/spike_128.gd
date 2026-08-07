extends AnimatableBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
var shadermaterial
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shadermaterial = load("res://shaders/bloodspike_shader_material.tres")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if !body.dead_:
			dmg()
			body.play_death_anim()
			if !Global.godmode:body.dmgshaketimer.start()


func dmg()->void:
	audio_stream_player_2d.play()
	
	
	
	sprite_2d.material = shadermaterial
	
	await get_tree().create_timer(1).timeout
	
	sprite_2d.material=null
	#sprite_2d.material.set_shader_parameter("hit_effect", 0)
