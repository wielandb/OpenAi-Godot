extends SceneTree
class FakeParent:
	extends Node
	var api_key = ""
	signal embedding_received(embedding: Array, response: Dictionary)
	func get_api():
		return api_key
var EmbeddingsScript = load("res://addons/openai_api/Scripts/Embeddings.gd")
var parent_node : FakeParent
var embeddings
func _initialize():
	var key = OS.get_environment("OPENAI_API_KEY")
	if key == "":
		print("Skipping embeddings tests: OPENAI_API_KEY not set")
		quit(0)
		return
	parent_node = FakeParent.new()
	parent_node.api_key = key
	get_root().add_child(parent_node)
	embeddings = EmbeddingsScript.new()
	parent_node.add_child(embeddings)
	await self.process_frame
	parent_node.embedding_received.connect(_on_embedding)
	embeddings.get_embedding("Test embedding")
func _on_embedding(embedding: Array, response: Dictionary) -> void:
	if embedding.size() == 0:
		push_error("Embedding is empty")
		quit(1)
		return
	print("Embedding received")
	quit(0)
