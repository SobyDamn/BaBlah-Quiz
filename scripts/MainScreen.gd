extends Node2D
var difficulty

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var registerHTTP : HTTPRequest = $RegisterHTTP
onready var savehttp : HTTPRequest = $SaveRequest
onready var updatehtto : HTTPRequest = $UpdateRequest
# Called when the node enters the scene tree for the first time.
func _process(delta):
	pass
func _ready():
	$SettingScreen.visible = false
	$HomeScreen.visible = true
	if Firebase.checkCurrentUser():
		Firebase.save_document(savehttp)
		setName(Firebase.userDetail.name.stringValue)
	else:
		showRegPOP()

func setName(val):
	$UserInfo.text = "Hi!\n%s" % val
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


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var response_body := JSON.parse(body.get_string_from_ascii())
	print(response_code)
	if response_code != 200:
		print("Error")
		print(response_body.result.error.messages)
		$RegisterPOP/Notify.text = response_body.result.error.messages
	elif response_code == 200:
		print("Success Reg")
		hideRegPOP()
		#Firebase.save_document(savehttp)



func _on_Save_pressed():
	Firebase.save_document(savehttp)


func _on_Update_pressed():
	Firebase.get_document(updatehtto)


func _on_SaveRequest_request_completed(result, response_code, headers, body):
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		print("Error")
		print(response_body.result)
	else:
		setName(Firebase.userDetail.name.stringValue)
		hideRegPOP()

func _on_UpdateRequest_request_completed(result, response_code, headers, body):
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		print("Error")
		print(response_body.result)
	else:
		print("Got the document")
		print(response_body.result)

func showRegPOP():
	$RegisterPOP.show()
func hideRegPOP():
	$RegisterPOP/Notify.text = ""
	$RegisterPOP.hide()
func _on_register_pressed():
	var name = $RegisterPOP/Name.text
	$UserInfo.text = "Hi!\n%s"%name
	Firebase.register(registerHTTP,name)

