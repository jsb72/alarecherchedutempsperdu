extends Node2D

@export var is_rotatingg:bool=true
@export var reverse_rotate:bool=false
@export var speed_rotate:float=0.3

@onready var timer: Timer = $Timer
@onready var player: Player 
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var color_rect_laser: ColorRect = $ColorRectLASER
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2
@onready var texture_rect: TextureRect = $TextureRect
@onready var texture_rect_2: TextureRect = $TextureRect2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_rotatingg:
		if reverse_rotate:
			animation_player.play("new_animation_reverse")
		else:
			animation_player.play("new_animation")
			
	animation_player.speed_scale=speed_rotate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var disable:bool=false
func disable_laser()->void:
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect_laser.material, "shader_parameter/progress", 0.0, 2.0)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(texture_rect, "modulate:a", 0.0, 2.0)
	
	var tween3 = get_tree().create_tween()
	tween3.tween_property(texture_rect_2, "modulate:a", 0.0, 2.0)
	
	audio_stream_player_2d_2.stop()
	
	disable=true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and !disable:
		player=body
		body.laser_dmg = true
		timer.start()
		audio_stream_player_2d.play()
		Input.start_joy_vibration(0,0.5,0.5)
		


func _on_timer_timeout() -> void:
	player.laser_dmg = false
	player.respawn()
	audio_stream_player_2d.stop()
	Input.stop_joy_vibration(0)
