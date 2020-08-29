extends Node2D
var difficulty

onready var Tween = $Tween

onready var registerHTTP : HTTPRequest = $RegisterHTTP
onready var savehttp : HTTPRequest = $SaveRequest
func _ready():
	$SettingScreen.visible = true
	$MenuScreen.visible = true
	if Firebase.checkCurrentUser():
		showLoader()
		Firebase.save_document(savehttp)
	else:
		showRegPOP()

func onStart():
	get_tree().change_scene("res://QuestionArea.tscn")


func onSetting():
	$MenuScreen.visible = false
	$SettingScreen.visible = true
	Tween.interpolate_property($SettingScreen, "position",
	Vector2(576,0), Vector2(0,0), 0.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT
	)
	Tween.start()



func onDifficultySelect(val):
	Utility.gameValues.Mode = val
	difficulty = val
	$SettingScreen/DifficultyOption/Current.text = "("+difficulty+")"
	Tween.interpolate_property($SettingScreen, "position",
	Vector2(0,0), Vector2(-576,0), 0.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT
	)
	Tween.start()
	$MenuScreen.visible = true


##USer Register request
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var response_body := JSON.parse(body.get_string_from_ascii())
	print(response_code)
	if response_code != 200:
		print("Error")
		showRegPOP("Network Error")
		print(response_body.result.error.messages)
		$RegisterPOP/Notify.text = response_body.result.error.messages
	elif response_code == 200:
		print("Success Reg")
		hideLoader()



func _on_Save_pressed():
	Firebase.save_document(savehttp)




func _on_SaveRequest_request_completed(result, response_code, headers, body):
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		print("Error")
		print(response_body.result)
		hideLoader()
		showErrorPop()
	else:
		print("Saving from main")
		hideLoader()


func showRegPOP(text:String=""):
	Tween.start()
	Tween.interpolate_property($RegisterPOP, "rect_scale",
	Vector2(0,0), Vector2(1,1), 0.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT
	)
	$RegisterPOP.show()
	$RegisterPOP/ErrorInfo.text = text
func hideRegPOP():
	Tween.interpolate_property($RegisterPOP, "rect_scale",
	Vector2(1,1), Vector2(0,0), 0.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT
	)
	Tween.start()
	$RegisterPOP.hide()
	$RegisterPOP/ErrorInfo.text = ""
func _on_register_pressed():
	var name = $RegisterPOP/Name.text
	if name == "Your Name" || name == "":
		$RegisterPOP/ErrorInfo.text = "Enter name correctly!"
	else:
		hideRegPOP() #hide pop
		showLoader() #show registering
		Firebase.register(registerHTTP,name)
func _on_Leaderboard_pressed():
	get_tree().change_scene("res://LeaderBoard.tscn")

func showLoader():
	$LoadingScreen.visible = true
func hideLoader():
	$LoadingScreen.visible = false

func _on_BackgroundSong_finished():
	$BackgroundSong.play()

func showErrorPop(err="Error while loading the game\nMake sure you have an active data connection."):
	$ErrorInfoPOP/Label.text = err
	$ErrorInfoPOP.show()
func hideErrorPOP():
	$ErrorInfoPOP.hide()
func _on_Ok_Error():
	hideErrorPOP()
	_ready()
