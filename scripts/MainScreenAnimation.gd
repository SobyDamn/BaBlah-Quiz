extends Node2D

onready var Tween = $Tween
func _ready():
	$CenterContainer/AnimatedSprite.scale = Vector2(0,0)
	Tween.interpolate_property($CenterContainer/AnimatedSprite, "scale",
	Vector2(0.15,0.15), Vector2(0.3,0.3), 1.0,Tween.TRANS_BOUNCE,Tween.EASE_IN_OUT
	)
	Tween.start()
	pass


func _on_Start_button_down():
	Tween.interpolate_property($CenterContainer2/Start, "rect_scale",
	Vector2(1,1), Vector2(0.98,0.98), 0.05,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT
	)
	Tween.start()


func _on_Start_button_up():
	Tween.interpolate_property($CenterContainer2/Start, "rect_scale",
	Vector2(0.98,0.98), Vector2(1,1), 0.05,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT
	)
	Tween.start()



