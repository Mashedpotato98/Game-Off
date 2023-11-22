@tool
extends Node3D


const EDITOR_CLICK_MARGIN = 0.2

@export var path:Path
@export_group("Selected Connection", "current_connection_")
@export var current_connection_priority := 1.0


func _ready() -> void:
	var mesh = MeshInstance3D.new()
	add_child(mesh)
	var shape = BoxMesh.new()
	mesh.mesh = shape
	shape.size.x = randf()
