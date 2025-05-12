extends Node2D

@onready var Shops = $"../Shops"

func _on_button_button_down() -> void:
	Shops._on_clicker_click()

func _animation_frame(frame):
	if frame >= 70:
		pass
	else:
		$Clicker.frame = frame
