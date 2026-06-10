extends Node2D

@export var white:bool= false

@onready var player: Player

@onready var timer: Timer = $Timer
@onready var reloadtimer: Timer = $reloadtimer

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


@onready var blacksprite: Sprite2D = $blacksprite
@onready var whitesprite: Sprite2D = $whitesprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if white:
		whitesprite.show()
		blacksprite.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player=body
		if !body.dead_:
			#Global.list_des_morts.push_back(body.global_position)
			timer.start()
			reloadtimer.start()
			audio_stream_player_2d.play()
			Input.start_joy_vibration(0,0.5,0.5)
			body.play_death_anim()
			body.shakecamtimer.start()

	
func _on_timer_timeout() -> void:
	audio_stream_player_2d.stop()
	Input.stop_joy_vibration(0)


func _on_reloadtimer_timeout() -> void:
	Global.list_des_morts.push_back(player.global_position)
	
	var cad = player.cadavre.duplicate()
	cad.global_position = player.global_position
	cad.global_position.y -= 36
	cad.visible=true
	get_tree().root.add_child(cad)
	#$".".add_child(cad) 
	print(cad.get_path())
	
	player.respawn()
	


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass
