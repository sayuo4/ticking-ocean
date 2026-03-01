class_name PingPongComponent
extends Node

@export var autostart: bool = true
@export var target_node: Node2D
@export var move_range: float = 1.0
@export var move_dir: Vector2 = Vector2.UP
@export var duration: float
@export var ease_type: Tween.EaseType = Tween.EASE_IN
@export var trans_type: Tween.TransitionType = Tween.TRANS_CUBIC

var _tween: Tween = null
var _moved_dist: Vector2 = Vector2.ZERO: set = _set_moved_dist
var _started: bool = false

func _ready() -> void:
	if autostart:
		play()

func play() -> void:
	if not _tween or not _tween.is_valid():
		_tween = create_tween().set_loops()
		_started = false
	
	if not _started:
		_tween.tween_property(self, "_moved_dist", move_range * move_dir, duration).set_ease(ease_type).set_trans(trans_type)
		_tween.tween_property(self, "_moved_dist", move_range * -move_dir, duration).set_ease(ease_type).set_trans(trans_type)
		_started = true
	
	_tween.play()

func stop() -> void:
	if _tween:
		_tween.stop()
	
	if target_node:
		target_node.global_position -= _moved_dist

func pause() -> void:
	if _tween:
		_tween.pause()

func _set_moved_dist(value: Vector2) -> void:
	if target_node:
		target_node.global_position += value - _moved_dist
	
	_moved_dist = value
