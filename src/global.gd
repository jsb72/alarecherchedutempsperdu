extends Node

var debug_mod:bool=true



var dash_unlock:bool = false
var sprint_unlock:bool = false
var doublejump_unlock:bool = false
var walljump_unlock:bool=true

var godmode:bool=false

var next_door_id:int=3#-1
var list_door=[
	{ "door_id": 0, "opened": true, "lvl_name":"start", "pos": Vector2(-1952,1216), "flip_h": true, "door_id_target": "1" },
	{ "door_id": 1, "opened": true, "lvl_name":"26", "pos": Vector2(-768.0,1216), "flip_h": false, "door_id_target": "0" },
	{ "door_id": 2, "opened": false, "lvl_name":"26", "pos": Vector2(2368.0,1856), "flip_h": true, "door_id_target": "3" },
	{ "door_id": 3, "opened": true, "lvl_name":"27", "pos": Vector2(-3200,1216.0), "flip_h": false, "door_id_target": "2" },
]

var color_h_init:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.max_fps=165
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	var language = "automatic"
	# Load here language from the user settings file
	if language == "automatic":
		var preferred_language = OS.get_locale_language()
		TranslationServer.set_locale(preferred_language)
	else:
		TranslationServer.set_locale(language)
		
	color_h_init=randfn(0.0, 1.0)
	
	if next_door_id!=-1:
		get_tree().change_scene_to_file("res://src/network/scenes/"+(list_door[next_door_id])["lvl_name"]+".tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("escape"):
		get_tree().quit()
	if debug_mod:
		dash_unlock = true
		sprint_unlock = false
		doublejump_unlock = false
		walljump_unlock = true
		
	if Input.is_action_just_pressed("start"):
		get_tree().reload_current_scene()
		
		
		
		
		
		
