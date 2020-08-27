extends Node2D

onready var http : HTTPRequest = $FetchQuestions
onready var userDetail = Firebase.userDetail
var questionsList = []
func _ready():
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
		#questionsList = docs.fields
		for i in range(0,docs.size()):
			Utility.QuestionList.append(docs[i])
		if not nextPage:
			print(Utility.QuestionList.size())
			Utility.fetchQuestion()
