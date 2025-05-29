extends Node2D

# setting random position for particles
var theta = randf() * 12 * PI
var radius = 100 * (3*pow(sin(theta/13),2) + 2*pow(sin(theta),2))

# exported variable to change scene before spawning
@export var behind = true

# providing access to particle spawner and main node
@onready var particles = $GPUParticles2D
@onready var Main = $"/root/Main"

## on startup, sets amount to progress and starts emitting
func _ready() -> void:
	if behind:
		particles.amount = Main.elementProgress
	$GPUParticles2D.emitting = true


## every frame, changes the position of the spawner
func _process(delta):
	# creates the movement
	theta += 100*delta
	radius = 100 * (3*pow(sin(theta/13),2) + 2*pow(sin(theta),2))
	
	# applies the movement
	particles.position = radius * Vector2.from_angle(theta) + Vector2(300,360)
	
	# stops particles from spawning offscreen
	if particles.position.x < 0:
		particles.position.x = 0
	
	if particles.position.x > 600:
		particles.position.x = 600
	
	if particles.position.y < 0:
		particles.position.y = 0
	
	if particles.position.y > 700:
		particles.position.y = 700

## when emission stops, despawns the scene
func _on_gpu_particles_2d_finished() -> void:
	queue_free()
