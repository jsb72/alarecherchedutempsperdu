extends Node2D

@export var type_bonus : String = ""

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.walljump_unlock and type_bonus == "walljump":
		sub_viewport_container.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func anim(body)->void:
	audio_stream_player_2d.play()
	
	var tween223f = get_tree().create_tween()
	tween223f.tween_property(sub_viewport_container, "modulate:a", 0.0, 1)
	
	var tween22 = get_tree().create_tween()
	tween22.tween_property(body.point_light_2d, "energy", 10, 1.0)
	await get_tree().create_timer(1).timeout
	var tween223 = get_tree().create_tween()
	tween223.tween_property(body.point_light_2d, "energy", 0.5, 1.0)
	await get_tree().create_timer(1).timeout

func _on_area_2d_body_entered(body: Node2D) -> void:

	if !Global.sprint_unlock and type_bonus == "sprint":
		Global.sprint_unlock = true
		anim(body)

	if !Global.dash_unlock and type_bonus == "dash":
		Global.dash_unlock = true
		anim(body)
		
	if !Global.doublejump_unlock and type_bonus == "doublejump":
		Global.doublejump_unlock = true
		anim(body)
		
	if !Global.walljump_unlock and type_bonus == "walljump":
		Global.walljump_unlock = true
		anim(body)
