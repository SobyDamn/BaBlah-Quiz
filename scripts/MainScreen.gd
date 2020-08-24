extends Node2D
var difficulty

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$SettingScreen.visible = false
	$HomeScreen.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func onStart():
	get_tree().change_scene("res://QuestionArea.tscn")


func onSetting():
	$HomeScreen.visible = false
	$SettingScreen.visible = true



func onDifficultySelect(val):
	difficulty = val
	$SettingScreen/DifficultyOption/Current.text = "("+difficulty+")"
	$SettingScreen.visible = false
	$HomeScreen.visible = true
	#pass # Replace with function body.
