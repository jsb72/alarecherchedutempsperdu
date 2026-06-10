extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var point_light_2d_2: PointLight2D = $PointLight2D2

@onready var rich_text_label: RichTextLabel = $RichTextLabel
var iswaken : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.first_cycle_done:
		animated_sprite_2d.play("stone")
		point_light_2d_2.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if !iswaken and !Global.first_cycle_done:
			var tween2 = get_tree().create_tween()
			tween2.tween_property(rich_text_label, "modulate:a", 1.0, 1.0)
			
			animated_sprite_2d.play("wakeup")
			await get_tree().create_timer(1).timeout
			var tween = get_tree().create_tween()
			tween.tween_property(rich_text_label, "modulate:a", 0.0, 60.0)
			
			iswaken=true
