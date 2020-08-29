extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Tween = $Tween
onready var LoadingTween = $LoadingTween

# Called when the node enters the scene tree for the first time.
func _ready():
	$LoadingScreenBG.visible = false
	Tween.interpolate_property($BanzanLogo, "modulate",
	Color(1,1,1,0), Color(1,1,1,1), 2.5,Tween.TRANS_SINE,Tween.EASE_IN
	)
	Tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	print("Entering")
	$LoadingScreenBG.visible = true
	#get_tree().change_scene("res://MainScreen.tscn")
