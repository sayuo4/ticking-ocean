extends Node

var MainScene: PackedScene = preload("res://src/levels/main/main.tscn")

func setup_main(default_scene_path: String) -> void:
	get_tree().change_scene_to_packed.call_deferred(MainScene)
	
	await get_tree().scene_changed
	
	switch_scene_to_file(default_scene_path)

func get_main() -> Main:
	var main: Main = get_tree().current_scene as Main
	
	return main

func switch_scene_to_packed(scene: PackedScene) -> void:
	var main: Main = get_main()
	
	if not main:
		return
	
	main.switch_scene_to_packed(scene)

func switch_scene_to_file(scene_path: String) -> void:
	var main: Main = get_main()
	
	if not main:
		return
	
	main.switch_scene_to_file(scene_path)

func get_current_scene() -> Node:
	var main: Main = get_main()
	
	if not main:
		return null
	
	return main.current_scene
