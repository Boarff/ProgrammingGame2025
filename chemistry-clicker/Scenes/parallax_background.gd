extends ParallaxBackground
var timeElapsed = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeElapsed += delta
	scroll_offset.x -= 45*delta
	scroll_offset.y = 1000*sin(timeElapsed/30)*cos(timeElapsed/20)
