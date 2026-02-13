class_name PlayerCamera
extends Camera2D

var _shake_fade: float = 0.0
var _shake_strength: float = 0.0

var _zoom_fade: float = 0.0

var default_zoom: Vector2

func _ready() -> void:
	default_zoom = zoom

func apply_shake(strength: float, fade: float) -> void:
	_shake_strength = strength
	_shake_fade = fade

func apply_zoom(value: Vector2, fade: float) -> void:
	zoom = value
	_zoom_fade = fade

func _process(delta: float) -> void:
	_shake_strength = lerpf(_shake_strength, 0.0, _shake_fade * delta)
	
	offset = Vector2(
			randf_range(-_shake_strength, _shake_strength),
			randf_range(-_shake_strength, _shake_strength)
	)
	
	zoom = zoom.lerp(default_zoom, _zoom_fade * delta)
