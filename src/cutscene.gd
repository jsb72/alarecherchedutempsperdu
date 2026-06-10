extends Node2D

@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var blackbg: ColorRect = $blackbg
@onready var vignette: ColorRect = $vignette
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(vignette.material, "shader_parameter/vignette_intensity", 50.0, 0)

var start_playing:bool=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.debug_mod:
		video_stream_player.hide()
		blackbg.hide()
		vignette.hide()
	else:
		if !start_playing :
			Engine.time_scale=0.5
			start_playing=true
			timer.start()
			var tween = get_tree().create_tween()
			tween.tween_property(vignette.material, "shader_parameter/vignette_intensity", 2.0, 3.0)
			video_stream_player.play()




func _on_timer_timeout() -> void:
	Engine.time_scale=1
	Fadetoblack.transition(5)
	await Fadetoblack.on_transition_finished
	video_stream_player.hide()
	blackbg.hide()
	vignette.hide()
