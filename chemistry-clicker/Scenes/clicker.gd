extends Node2D
signal click

func _on_button_button_down() -> void:
	click.emit()
