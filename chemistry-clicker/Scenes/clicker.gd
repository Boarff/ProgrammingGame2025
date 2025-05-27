extends Node2D

## Access to nodes
@onready var Scroll = $"../Shops/Scroll"
@onready var Shops = $"../Shops"

## Variables for spawning sparkles
var particles = preload("res://Scenes/particles.tscn")
var spawnParticles

## on scene load
func _ready() -> void:
	Scroll.gameWon.connect(_on_game_won)

## despawns the scene
func _on_game_won():
	queue_free()

##  Activates handling of number changes
##  Spawns particles
func _on_button_button_down() -> void:
	
	# number change
	Shops.on_clicker_click()
	
	# spawns particles
	spawnParticles = particles.instantiate()
	add_child(spawnParticles)

## Changes the frame of animation for the clicker sprite
func animation_frame(frame):
	
	# stops from exceeding 69
	if frame > 69:
		pass
	else:
		$Clicker.frame = frame
