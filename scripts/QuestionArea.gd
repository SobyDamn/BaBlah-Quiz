extends Node2D

onready var http : HTTPRequest = $FetchQuestions
onready var userDetail = Firebase.userDetail
var questionData = {} #will get the value from utility
var playerScore = 0
var oldHighScore = Firebase.userDetail.score.integerValue
var gameMode = Utility.gameValues.Mode
var scorePerQ = Utility.gameValues.Score[gameMode]
var startTimer = Utility.gameValues.Timer[gameMode] #startTime[0] is total time
													#startTime[1] is consession time
func _ready():
	for button in get_tree().get_nodes_in_group("OptionButton"):
		button.connect("pressed", self, "option_pressed", [button])
	Firebase.get_document(http)
func _on_FetchQuestions(result, response_code, headers, body):
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		print("Error")
		print(response_body.result)
	else:
		print("Got the document")
		var docs = response_body.result.documents
		var nextPage = false
		if "nextPageToken" in response_body.result:
			nextPage = response_body.result.nextPageToken
			Firebase.get_document(http,"questions?pageSize=20&pageToken=%s"%nextPage)
		else:
			nextPage=false
		for i in range(0,docs.size()):
			Utility.QuestionList.append(docs[i])
		if not nextPage:
			$QuestionContainer/Timer.start()
			askQuestion()
func askQuestion():
	print("Fetching next question")
	questionData = Utility.fetchQuestion()
	if questionData != null:
		$QuestionContainer/Question.text = questionData.question
		$OptionContainer/OptionA.text = questionData.option[0]
		$OptionContainer/OptionB.text = questionData.option[1]
		$OptionContainer/OptionC.text = questionData.option[2]
		$OptionContainer/OptionD.text = questionData.option[3]
	else:
		$NoMoreQuesPOP.show()
	print(questionData)


func option_pressed(button):
	if button.text == questionData.answer:
		onCorrectAnswer()
	else:
		onWrongAnswer()

func onCorrectAnswer():
	print("Asking next question")
	playerScore += scorePerQ
	$QuestionContainer/HBoxContainer/ScoreLabel.text = "Score\n%s"%str(playerScore)
	startTimer[0]+=startTimer[1] #add consession if any
	Utility.saveQuestionId(questionData.id)
	Firebase.save_userData()
	askQuestion()
func onWrongAnswer():
	askQuestion()
	print("wrong")
func onTimeOver():
	#finish the game
	if playerScore > oldHighScore:
		Firebase.userDetail.score.integerValue = playerScore
		Firebase.save_userData() #save offline
func _on_Timer_timeout():
	$QuestionContainer/TimeLabel.text = str(startTimer[0])
	startTimer[0] -=1


func onPopButton():
	$NoMoreQuesPOP.hide()
	get_tree().change_scene("res://MainScreen.tscn")
