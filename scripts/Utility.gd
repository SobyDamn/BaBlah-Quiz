extends Node

var gameValues = {
	"Score":{
		"Easy":10,
		"Normal":20,
		"Hard":25
	},
	"Timer":{
		#starttime,consession
		"Easy":[60,0],
		"Normal":[45,5],
		"Hard":[30,10]
	},
	"Mode":"Easy"
}
var QuestionList = []
var questionInteracted = 0 #number of question interacted with
var temp = {
	"Hard":0,
	"Normal":0,
	"Easy":0
}
func fetchQuestion(idVal:String = "",difficultyType:String="Easy"):
	var alreadyAsked = Firebase.userDetail.askedQuestion.arrayValue.values
	for i in range(questionInteracted,QuestionList.size()):
		var difficulty = QuestionList[i].fields.type.stringValue
		var id = queID(QuestionList[i].name)
		if not checkHadAsked(id) && difficulty == difficultyType:
			var questionData = {}
			questionData.question = QuestionList[i].fields.question.stringValue
			questionData.answer = QuestionList[i].fields.answer.stringValue
			questionData.type = difficulty
			questionData.option = [QuestionList[i].fields.option.arrayValue.values[0].stringValue.strip_edges(),QuestionList[i].fields.option.arrayValue.values[1].stringValue.strip_edges(),QuestionList[i].fields.option.arrayValue.values[2].stringValue.strip_edges(),QuestionList[i].fields.option.arrayValue.values[3].stringValue.strip_edges()]
			questionData.id = id
			questionInteracted +=1
			return questionData
		else:
			questionInteracted +=1
			pass
	return null
func queID(url_str: String) -> String:
	var strArray = url_str.split("/")
	return strArray[strArray.size()-1]
func checkHadAsked(id:String) ->bool:
	var alreadyAsked = Firebase.userDetail.askedQuestion.arrayValue.values
	for i in range(0,alreadyAsked.size()):
		if id == alreadyAsked[i].stringValue:
			return true
	return false
func saveQuestionId(id:String) -> void:
	var idObj = {}
	idObj.stringValue = id
	Firebase.userDetail.askedQuestion.arrayValue.values.append(idObj)
