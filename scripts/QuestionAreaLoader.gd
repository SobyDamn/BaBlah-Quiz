extends ColorRect

var startDegree = 0
var endDegree = 540

onready var LoadingTween = $LoadingTween
func _ready():
	self.visible = false
	LoadingTween.interpolate_property($AnimatedSprite, "rotation_degrees",
	startDegree, endDegree, 1.5,Tween.TRANS_LINEAR,Tween.EASE_IN
	)
	startDegree +=540
	endDegree +=540
	LoadingTween.start()
	



func _on_LoaderTimer_timeout():
	
	LoadingTween.interpolate_property($AnimatedSprite, "rotation_degrees",
	startDegree, endDegree, 1.5,Tween.TRANS_LINEAR,Tween.EASE_IN
	)
	startDegree +=540
	endDegree +=540
	LoadingTween.start()

