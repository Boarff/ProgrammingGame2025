extends Control
var protonTotal = 0
var neutronTotal = 0

func _ready():
	var clicker = get_node("clicker")
	clicker.click.connect(_on_clicker_click)
	
	

func _on_clicker_click():
	pass
