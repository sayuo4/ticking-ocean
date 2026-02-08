extends Node

var MainScene: PackedScene = preload("res://src/main/main.tscn")

func setup_main(default_level_path: String) -> void:
	get_tree().change_scene_to_packed.call_deferred(MainScene)
	
	await get_tree().scene_changed
	
	switch_level_to_file(default_level_path)

func get_main() -> Main:
	var main: Main = get_tree().current_scene as Main
	
	return main

func get_hud() -> HUD:
	var hud: HUD = get_tree().get_first_node_in_group("hud") as HUD
	
	return hud

func get_player() -> Player:
	var player: Player = get_tree().get_first_node_in_group("player") as Player
	
	return player

func switch_level_to_packed(level: PackedScene) -> void:
	var main: Main = get_main()
	
	if main:
		main.switch_level_to_packed(level)

func switch_level_to_file(level_path: String) -> void:
	var main: Main = get_main()
	
	if main:
		main.switch_level_to_file(level_path)

func get_current_level() -> Node:
	var main: Main = get_main()
	
	if main:
		return main.current_level
	
	return null

func reload_current_level() -> void:
	var main: Main = get_main()
	
	if main:
		main.reload_current_level()
