extends ParallaxBackground
#var timeElapsed = 0


func _process(delta):
	
	#timeElapsed += delta
	scroll_offset.x -= 45*delta
	scroll_offset.y = 1000*sin(scroll_offset.x/1250)*cos(scroll_offset.x/900)
