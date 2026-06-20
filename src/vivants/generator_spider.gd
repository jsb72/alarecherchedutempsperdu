extends Node2D

@onready var timer: Timer = $Timer
@onready var spiderlist: Node2D = $"../spiderlist"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	
	var spiderspawedpacked = load("res://src/vivants/newspider.tscn")
	var spiderspawed = spiderspawedpacked.instantiate()
	
	spiderspawed.scale=Vector2(0.5,0.5)
	spiderspawed.global_position=global_position
	spiderspawed.global_position.y+=64
	spiderlist.add_child(spiderspawed)
	timer.start()
