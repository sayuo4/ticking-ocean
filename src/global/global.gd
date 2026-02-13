extends Node

signal start_transition_finished
signal end_transition_finished

@export var after_end_transition_time: float

var GameManagerScene: PackedScene = preload("res://src/game_manager/game_manager.tscn")

@onready var transition_animation_player: AnimationPlayer = %TransitionAnimationPlayer as AnimationPlayer

func play_start_transition() -> void:
	transition_animation_player.play("start_transition")
	await transition_animation_player.animation_finished
	start_transition_finished.emit()

func play_end_transition() -> void:
	transition_animation_player.play("end_transition")
	await transition_animation_player.animation_finished
	await get_tree().create_timer(after_end_transition_time, true).timeout
	end_transition_finished.emit()

func is_playing_transition() -> bool:
	return transition_animation_player.is_playing()

class Game:
	static func get_manager() -> GameManager:
		var game_manager: GameManager = Global.get_tree().current_scene as GameManager
		
		return game_manager
	
	static func get_or_add_manager() -> GameManager:
		var game_manager: GameManager = Global.get_tree().current_scene as GameManager
		
		if not game_manager:
			Global.get_tree().change_scene_to_packed.call_deferred(Global.GameManagerScene)
			
			await Global.get_tree().scene_changed
			game_manager = Global.get_tree().current_scene as GameManager
		
		return game_manager
	
	static func get_player() -> Player:
		var player: Player = Global.get_tree().get_first_node_in_group("player") as Player
		
		return player
	
class Camera:
	static func get_camera() -> PlayerCamera:
		var camera: PlayerCamera = Global.get_tree().get_first_node_in_group("player_camera") as PlayerCamera
		
		return camera
	
	static func apply_shake(strength: float, fade: float) -> void:
		var camera: PlayerCamera = get_camera()
		
		if camera:
			camera.apply_shake(strength, fade)
	
	static func apply_zoom(value: Vector2, fade: float) -> void:
		var camera: PlayerCamera = get_camera()
		
		if camera:
			camera.apply_zoom(value, fade)

class UI:
	static func get_pause_menu() -> PauseMenu:
		var pause_menu: PauseMenu = Global.get_tree().get_first_node_in_group("pause_menu") as PauseMenu
		
		return pause_menu
	
	static func enable_pause_menu() -> void:
		var pause_menu: PauseMenu = get_pause_menu()
		
		if pause_menu:
			pause_menu.enabled = true
	
	static func get_hud() -> HUD:
		var hud: HUD = Global.get_tree().get_first_node_in_group("hud") as HUD
		
		return hud

class Levels:
	static func switch_to_packed(level_scene: PackedScene, play_transitions: bool = true) -> void:
		var game_manager: GameManager = await Global.Game.get_or_add_manager()
		
		if game_manager:
			game_manager.switch_level_to_packed(level_scene, play_transitions)
	
	static func switch_to_file(level_path: String, play_transitions: bool = true) -> void:
		var game_manager: GameManager = await Global.Game.get_or_add_manager()
		
		if game_manager:
			game_manager.switch_level_to_file(level_path, play_transitions)
	
	static func reload_current() -> void:
		var game_manager: GameManager = Global.Game.get_manager()
		
		if game_manager:
			game_manager.reload_current_level()
	
	static func get_current() -> Node:
		var game_manager: GameManager = Global.Game.get_manager()
		
		if game_manager:
			return game_manager.current_level
		
		return null

class Scenes:
	static func switch_to_node(node: Node, play_transitions: bool = true) -> void:
		_handle_scene_switch(Global.get_tree().change_scene_to_node, play_transitions, node)
	
	static func switch_to_packed(scene: PackedScene, play_transitions: bool = true) -> void:
		_handle_scene_switch(Global.get_tree().change_scene_to_packed, play_transitions, scene)
	
	static func switch_to_file(path: PackedScene, play_transitions: bool = true) -> void:
		_handle_scene_switch(Global.get_tree().change_scene_to_file, play_transitions, path)
	
	static func _handle_scene_switch(callable: Callable, play_transitions: bool, scene: Variant) -> void:
		Global.get_tree().paused = true
		
		if play_transitions:
			Global.play_end_transition()
			await Global.end_transition_finished
		
		callable.call(scene)
		await Global.get_tree().scene_changed
		
		if play_transitions:
			Global.play_start_transition()
			await Global.start_transition_finished
		
		Global.get_tree().paused = false
