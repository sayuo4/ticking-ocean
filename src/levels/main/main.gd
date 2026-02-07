class_name Main
extends Node

var current_scene: Node

@onready var sub_viewport: SubViewport = %SubViewport

func switch_scene_to_packed(scene: PackedScene) -> void:
	if not scene:
		return
	
	for child: Node in sub_viewport.get_children():
		child.queue_free()
	
	var scene_inst: Node = scene.instantiate()
	
	sub_viewport.add_child.call_deferred(scene_inst)
	scene_inst.set_deferred("owner", self)
	set_deferred("current_scene", scene_inst)

func switch_scene_to_file(scene_path: String) -> void:
	var scene: PackedScene = load(scene_path) as PackedScene
	
	switch_scene_to_packed(scene)
