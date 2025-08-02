extends SceneTree
class FakeParent:
	extends Node
	var api_key = ""
	signal grader_run_completed(response: Dictionary)
	signal grader_validation_completed(response: Dictionary)
	func get_api():
		return api_key
var GraderScript = load("res://addons/openai_api/Scripts/Grader.gd")
var parent_node : FakeParent
var grader
func _initialize():
	var key = OS.get_environment("OPENAI_API_KEY")
	if key == "":
		print("Skipping grader tests: OPENAI_API_KEY not set")
		quit(0)
		return
	parent_node = FakeParent.new()
	parent_node.api_key = key
	get_root().add_child(parent_node)
	grader = GraderScript.new()
	parent_node.add_child(grader)
	await self.process_frame
	parent_node.grader_validation_completed.connect(_on_validate)
	parent_node.grader_run_completed.connect(_on_run)
	var g = {
		"type": "string_check",
		"name": "Example string check grader",
		"input": "{{sample.output_text}}",
		"reference": "{{item.label}}",
		"operation": "eq"
	}
	grader.validate_grader(g)
func _on_validate(response: Dictionary) -> void:
	if not response.has("grader"):
		push_error("Validation failed: %s" % [response])
		quit(1)
		return
	_run_test()
func _run_test():
	var g = {
		"type": "string_check",
		"name": "Example string check grader",
		"input": "{{sample.output_text}}",
		"reference": "{{item.label}}",
		"operation": "eq"
	}
	var item = {"label": "foo"}
	grader.run_grader(g, "foo", item)
func _on_run(response: Dictionary) -> void:
	if response.get("reward", -1) == -1:
		push_error("Run failed: %s" % [response])
		quit(1)
		return
	print("All tests passed")
	quit(0)
