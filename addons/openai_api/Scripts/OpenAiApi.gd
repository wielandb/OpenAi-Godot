@icon("res://addons/openai_api/Icons/openico.png")
extends Node

var chatgpt_inst = preload("res://addons/openai_api/Scenes/ChatGpt.tscn")
var dalle_inst = preload("res://addons/openai_api/Scenes/Dalle.tscn")
var grader_inst = preload("res://addons/openai_api/Scenes/Grader.tscn")

@export var dalle :Dalle = null
@export var chatgpt :ChatGpt = null
@export var grader :Grader = null

@export var openai_api_key = ""

signal gpt_response_completed(message:Message, response:Dictionary)
signal dalle_response_completed(texture:ImageTexture)
signal grader_run_completed(response:Dictionary)
signal grader_validate_completed(response:Dictionary)

##Makes an api call to open ai chatgpt, and returns a class `Message` that contains `{"role":role,"content":content}`
func prompt_gpt(ListOfMessages:Array[Message], model: String = "gpt-o-mini", url:String="https://api.openai.com/v1/chat/completions"):
	
	while !chatgpt:
		await get_tree().create_timer(0.2).timeout
		
	chatgpt.prompt_gpt(ListOfMessages,model,url)

##Makes an api call to open ai dalle, and returns the generated Texture
func prompt_dalle(prompt:String, resolution:String = "1024x1024", model: String = "dall-e-2", url:String="https://api.openai.com/v1/images/generations"):

		while !dalle:
				await get_tree().create_timer(0.2).timeout

		dalle.prompt_dalle(prompt,resolution,model,url)

##Runs a grader and returns the result dictionary
func run_grader(grader_dict:Dictionary, model_sample:String, item:Dictionary = {}, url:String="https://api.openai.com/v1/fine_tuning/alpha/graders/run"):

		while !grader:
				await get_tree().create_timer(0.2).timeout

		grader.run_grader(grader_dict, model_sample, item, url)

##Validates a grader and returns the validation dictionary
func validate_grader(grader_dict:Dictionary, url:String="https://api.openai.com/v1/fine_tuning/alpha/graders/validate"):

		while !grader:
				await get_tree().create_timer(0.2).timeout

		grader.validate_grader(grader_dict, url)

func get_api() -> String:
	if openai_api_key.is_empty():
		push_error("Insert your OpenAi api key!")
	return openai_api_key
	
func set_api(api:String) -> void:
	openai_api_key = api

func _ready():
		if chatgpt and dalle and grader:
				return

		call_deferred("add_child",chatgpt_inst.instantiate())
		call_deferred("add_child",dalle_inst.instantiate())
		call_deferred("add_child",grader_inst.instantiate())
	
func _process(delta):
		if dalle and chatgpt and grader:
				set_process(false)
		if get_children() == []:
				return

		chatgpt = get_children()[0]
		dalle = get_children()[1]
		if get_child_count() > 2:
				grader = get_children()[2]
