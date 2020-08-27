extends Node

const API_KEY := "AIzaSyC728p_6CNPtdPKURfG66YQpyJd1ol9UoU"
const PROJECT_ID := "bablah-quiz"
const REGISTER_URL := "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=%s" % API_KEY
const FIRESTORE_URL := "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/" % PROJECT_ID
var userDetail = {}
func setUserData(name,id):
	userDetail = {
		"userid" : {
			"stringValue": id
			},
		"name": {
			"stringValue": name
			},
		"score":{
			"integerValue": 0
			},
		"savedOnline":{
			"booleanValue":false
		}
	}
func save_userData():
	var userData = File.new()
	userData.open("user://data.json", File.WRITE)
	userData.store_line(to_json(userDetail))
	userData.close()
	print("Saved Offline")
	
func _get_local_id_from_result(result: Array) -> String:
	var result_body := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
	return result_body.localId
	
func checkCurrentUser():
	var userData = File.new()
	if not userData.file_exists("user://data.json"):
		return false
	else:
		userData.open("user://data.json", userData.READ)
		var text = userData.get_as_text()
		if text == "":
			userData.close()
			return false
		else:
			var json = JSON.parse(userData.get_as_text())
			userDetail = json.result
			userData.close()
			return true
func updateData(val:int):
	userDetail.score.integerValue = val
	var userData = File.new()
	userData.open("user://data.json", userData.WRITE)
	userData.store_string(JSON.print(userDetail, "  ", true))
	userData.close()
func register(http: HTTPRequest,name:String) -> void:
	var body := {"returnSecureToken":true}
	var userData = File.new()
	http.request(REGISTER_URL, ["Content-Type: application/json"], false, HTTPClient.METHOD_POST,to_json(body))
	var result := yield(http, "request_completed") as Array
	if result[1] == 200:
		var id = _get_local_id_from_result(result)
		setUserData(name,id)
		save_userData()
		
func save_document( http: HTTPRequest) -> void:
	if not userDetail.savedOnline.booleanValue:
		var path: String = "users?documentId=%s" % userDetail.userid.stringValue
		userDetail.savedOnline = {"booleanValue": true}
		var document := {
			"fields": userDetail
		}
		var body := to_json(document)
		var url := FIRESTORE_URL + path
		http.request(url, ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, body)
		save_userData()
		print("Saved in Firestore")
	else:
		update_document(http)

func update_document(http: HTTPRequest,path: String = "users/%s?updateMask.fieldPaths=score" % userDetail.userid.stringValue, fields: Dictionary = userDetail) -> void:
	var document := { "fields": userDetail }
	var body := to_json(document)
	var url := FIRESTORE_URL + path
	http.request(url, ["Content-Type: application/json"], false, HTTPClient.METHOD_PATCH, body)
	print("Updated")
	save_userData()

func get_document(http: HTTPRequest,path: String = "questions") -> void:
	var url := FIRESTORE_URL + path
	print(url)
	http.request(url, ["Content-Type: application/json"], false, HTTPClient.METHOD_GET)
