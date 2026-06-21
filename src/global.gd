extends Node

var debug_mod:bool=true

var nb_fractal:int = 0

var door_opened:bool = false

var dash_unlock:bool = false
var sprint_unlock:bool = false
var doublejump_unlock:bool = false
var walljump_unlock:bool=true

var godmode:bool=false

var fractal_list: Array[bool] = [true, true, true]

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("escape"):
		get_tree().quit()
	if debug_mod:
		dash_unlock = true
		sprint_unlock = false
		doublejump_unlock = false
		walljump_unlock = true
		nb_fractal=3
		
		
		
		
		
		
