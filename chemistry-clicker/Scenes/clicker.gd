extends Node2D

@onready var Shops = $"../Shops"
@onready var particles = $GPUParticles2D

var theta = 0
var radius = 0

func _on_button_button_down() -> void:
	Shops._on_clicker_click()

func _animation_frame(frame):
	if frame >= 70:
		pass
	else:
		$Clicker.frame = frame

func _process(delta):
	theta += 100*delta
	radius = 100 * (3*pow(sin(theta/13),2) + 2*pow(sin(theta),2))
	
	particles.position = radius * Vector2.from_angle(theta) + Vector2(300,360)
