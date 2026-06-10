extends Area2D

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
		#body.jump()
		body.velocity = body.velocity*1.66
		"""if Input.is_action_pressed("interaction"):
			body.velocity = body.velocity*1.66"""
		"""if Input.is_action_pressed("interaction"):
			body.jump()"""
		
func _on_body_exited(body: Node2D) -> void:
	pass
