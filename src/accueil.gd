extends Node2D

@onready var loading: Label = $CanvasLayer/loading
@onready var damn: RichTextLabel = $CanvasLayer/damn
@onready var pressbutton: RichTextLabel = $pressbutton


func _ready() -> void:
	damn.modulate.a=0
	loading.modulate.a=0

func _process(delta: float) -> void:
	pass
	
var key_pressed:bool=false
func _input(event: InputEvent) -> void:
	if !key_pressed:
		if event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton:
			key_pressed=true
			
			var tween = get_tree().create_tween()
			tween.tween_property(pressbutton, "modulate:a", 0.0, 1.0)
			
			await get_tree().create_timer(1).timeout
			
			var tween2 = get_tree().create_tween()
			tween2.tween_property(damn, "modulate:a", 1.0, 3.0)			
			var tween3 = get_tree().create_tween()
			tween3.tween_property(loading, "modulate:a", 1.0, 3.0)
			
			await get_tree().create_timer(3).timeout
			
			get_tree().change_scene_to_file("res://src/vhs.tscn")
