extends Node2D

@onready var layer1_gpu_particles_2d: GPUParticles2D = $CanvasLayer/GPUParticles2D
@onready var layer2_gpu_particles_2d: GPUParticles2D = $CanvasLayer2/GPUParticles2D
@onready var layer3_gpu_particles_2d: GPUParticles2D = $CanvasLayer3/GPUParticles2D

@onready var layer1: CanvasLayer = $CanvasLayer
@onready var layer2: CanvasLayer = $CanvasLayer2
@onready var layer3: CanvasLayer = $CanvasLayer3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(1,31):
		var p1 = layer1_gpu_particles_2d.duplicate()
		p1.position += Vector2(500*i,0)
		layer1.add_child(p1)  
		var p2 = layer2_gpu_particles_2d.duplicate()
		p2.position += Vector2(500*i,0)
		layer2.add_child(p2)  
		var p3 = layer3_gpu_particles_2d.duplicate()
		p3.position += Vector2(500*i,0)
		layer3.add_child(p3)  
		
		
	for i in range(1,5):
		var p1 = layer1_gpu_particles_2d.duplicate()
		p1.position += Vector2(-500*i,0)
		layer1.add_child(p1)  
		var p2 = layer2_gpu_particles_2d.duplicate()
		p2.position += Vector2(-500*i,0)
		layer2.add_child(p2)  
		var p3 = layer3_gpu_particles_2d.duplicate()
		p3.position += Vector2(-500*i,0)
		layer3.add_child(p3)  


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
