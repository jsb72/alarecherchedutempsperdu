extends Node2D

@onready var fogmidlvl: ColorRect = $Parallax2D/FOGMIDLVL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(fogmidlvl, "modulate:a", 0.0, 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		var tween = get_tree().create_tween()
		tween.tween_property(fogmidlvl, "modulate:a", 1.0, 3.0)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		var tween = get_tree().create_tween()
		tween.tween_property(fogmidlvl, "modulate:a", 0.0, 1.0)
