extends Node2D
@onready var label: Label = $Label

@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text=str(int(timer.wait_time))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !timer.is_stopped():
		label.text=str(int(timer.time_left))


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		timer.stop()
		if body.respawned:
			label.text=str(int(timer.wait_time))


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		timer.start()
