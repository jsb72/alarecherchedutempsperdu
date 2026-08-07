extends Node2D

@onready var static_body_2d: StaticBody2D = $StaticBody2D
var opened:bool=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !opened:
		opened=true
		
		body.unlock_door()
		
		await get_tree().create_timer(0.5).timeout
		
		var tween = get_tree().create_tween()
		tween.tween_property(static_body_2d, "global_position:y", static_body_2d.global_position.y-300, 5)
