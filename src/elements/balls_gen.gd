extends Node2D

@onready var ball: RigidBody2D = $ball
@onready var timer: Timer = $Timer

func duplicate_ball():
	var b = ball.duplicate()
	b.show()
	b.process_mode = Node.PROCESS_MODE_INHERIT
	$".".add_child(b)  

func _ready() -> void:
	ball.hide()
	ball.process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	if timer.is_stopped():
		duplicate_ball()
		timer.start()


func _on_timer_timeout() -> void:
	pass
