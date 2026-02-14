class_name Coral
extends Node2D

@export var shape_node: Node2D

@export var skew_range: float
@export var skew_time: float

func _ready() -> void:
	_start_tween()

func _start_tween() -> void:
	var tween: Tween = create_tween().set_loops()
	
	var skew_range_rad: float = deg_to_rad(skew_range)
	
	tween.tween_property(shape_node, "skew", skew_range_rad, skew_time)
	tween.tween_property(shape_node, "skew", -skew_range_rad, skew_time)
