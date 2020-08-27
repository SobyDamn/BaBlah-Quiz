extends Node2D

onready var http : HTTPRequest = $FetchQuestions
onready var userDetail = Firebase.userDetail
var questionData = {} #will get the value from utility
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
			print(Utility.QuestionList.size())
			askQuestion()
func askQuestion():
	print("Fetching next question")
	questionData = Utility.fetchQuestion()
	$QuestionContainer/Question.text = questionData.question
	$OptionContainer/OptionA.text = questionData.option[0]
	$OptionContainer/OptionB.text = questionData.option[1]
	$OptionContainer/OptionC.text = questionData.option[2]
	$OptionContainer/OptionD.text = questionData.option[3]
	print(questionData)


func option_pressed(button):
	if button.text == questionData.answer:
		print("Asking next question")
		askQuestion()
	else:
		print("wrong")
