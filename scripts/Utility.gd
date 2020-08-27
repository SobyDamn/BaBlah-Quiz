extends Node

var QuestionList = []
var alreadyAsked = []
var questionInteracted = 0 #number of question interacted with
var temp = {
	"Hard":0,
	"Normal":0,
	"Easy":0
}
func fetchQuestion(idVal:String = "",difficultyType:String="Easy"):
	for i in range(0,QuestionList.size()):
		var difficulty = QuestionList[i].fields.type.stringValue
		var id = queID(QuestionList[i].name)
		var hadAsked = id in alreadyAsked
		if not hadAsked && difficulty == difficultyType:
			alreadyAsked.append(id)
			var questionData = {}
			questionData.question = QuestionList[i].fields.question.stringValue
			questionData.answer = QuestionList[i].fields.answer.stringValue
			questionData.type = difficulty
			questionData.option = [QuestionList[i].fields.option.arrayValue.values[0].stringValue.strip_edges(),QuestionList[i].fields.option.arrayValue.values[1].stringValue.strip_edges(),QuestionList[i].fields.option.arrayValue.values[2].stringValue.strip_edges(),QuestionList[i].fields.option.arrayValue.values[3].stringValue.strip_edges()]
			questionData.id = id
			questionInteracted +=1
			print(questionInteracted,"Question asked")
			return questionData
		else:
			questionInteracted +=1
	return null
func queID(url_str: String) -> String:
	var strArray = url_str.split("/")
	return strArray[strArray.size()-1]
