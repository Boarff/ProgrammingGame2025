extends ParallaxBackground

var particles = preload("res://Scenes/particles.tscn")
var spawnParticles

# every frame
func _process(delta):
	# moves the background according to a combination of sin and cos
	scroll_offset.x -= 45*delta
	scroll_offset.y = 1000*sin(scroll_offset.x/1250)*cos(scroll_offset.x/900)

func spawn_particles():
	
	spawnParticles = particles.instantiate()
	add_child(spawnParticles)
