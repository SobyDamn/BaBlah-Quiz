extends Node

var QuestionList = []
var questionInteracted = 0 #number of question interacted with
var temp = {
	"Hard":0,
	"Normal":0,
	"Easy":0
}
func fetchQuestion():
	for i in range(0,QuestionList.size()):
		var difficulty = QuestionList[i].fields.type.stringValue
		var id = queID(QuestionList[i].name)
		var questionData = {}
		questionData.question = QuestionList[i].fields.question.stringValue
		questionData.answer = QuestionList[i].fields.answer.stringValue
		questionData.type = difficulty
		questionData.option = [QuestionList[i].fields.option.arrayValue.values[0].stringValue,QuestionList[0].fields.option.arrayValue.values[1].stringValue,QuestionList[0].fields.option.arrayValue.values[2].stringValue,QuestionList[0].fields.option.arrayValue.values[3].stringValue]
		questionData.id = id
		temp.difficulty +=1
		#print(questionData)
		#return questionData
	return {}
func queID(url_str: String) -> String:
	var strArray = url_str.split("/")
	return strArray[strArray.size()-1]
