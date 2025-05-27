extends ParallaxBackground

# every frame
func _process(delta):
	# moves the background according to a combination of sin and cos
	scroll_offset.x -= 45*delta
	scroll_offset.y = 1000*sin(scroll_offset.x/1250)*cos(scroll_offset.x/900)
