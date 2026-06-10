extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func updateAlpha(newValue : float):
	
	modulate.a = newValue
	if newValue == 0.0 :
		queue_free()
	
func startFading():
	var newTween = get_tree().create_tween()
	newTween.tween_method(updateAlpha,0.4,0.0,0.1)
