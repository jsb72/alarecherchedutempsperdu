extends Node2D

@onready var t1_1: Node2D = $"T1/1"
@onready var t1_2: Node2D = $"T1/2"
@onready var t1_3: Node2D = $"T1/3"
@onready var t2_1: Node2D = $"T2/1"
@onready var t2_2: Node2D = $"T2/2"
@onready var t2_3: Node2D = $"T2/3"

var zoom_true :bool=false
@onready var zoomcamfixnbig: PhantomCamera2D = %zoomcamfixnbig

func _ready() -> void:
	pass
	t1_1.hide()
	t1_2.hide()
	t1_3.hide()
	t2_1.hide()
	t2_2.hide()
	t2_3.hide()
	
func _process(delta: float) -> void:
	if zoom_true:
		zoomcamfixnbig.priority = 100
	else :
		zoomcamfixnbig.priority = 0

func _on_button_body_entered1(body: Node2D) -> void:
	if body is Player : t1_1.show()
	if body is Player : t1_3.show()

func _on_button_body_entered2(body: Node2D) -> void:
	if body is Player : t1_1.show()
	if body is Player : t1_2.show()

func _on_button_2_body_entered3(body: Node2D) -> void:
	if body is Player : t2_1.show()
	if body is Player : t2_2.show()

func _on_button_2_body_entered4(body: Node2D) -> void:
	if body is Player : t2_1.show()
	if body is Player : t2_3.show()


func _on_cam_zone_body_entered(body: Node2D) -> void:
	if body is Player :
		zoom_true = true
func _on_cam_zone_body_exited(body: Node2D) -> void:
	if body is Player :
		zoom_true = false
		
@onready var color_rect_fog: ColorRect = $Parallax2D3/color_rect_fog
func _on_fog_zone_body_entered(body: Node2D) -> void:
	if body is Player :
		var tween = get_tree().create_tween()
		tween.tween_property(color_rect_fog, "modulate:a", 1.0, 4.0)

func _on_fog_zone_body_exited(body: Node2D) -> void:
	if body is Player :
		var tween = get_tree().create_tween()
		tween.tween_property(color_rect_fog, "modulate:a", 0.0, 4.0)
