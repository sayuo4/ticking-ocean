class_name HUD
extends Control

signal oxygen_finished

@export var oxygen_reduce_amount: float

var oxygen: float: set = set_oxygen

@onready var oxygen_bar: ProgressBar = $OxygenBar as ProgressBar
@onready var oxygen_reduce_timer: Timer = %ReduceTimer as Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer

func _ready() -> void:
	reset()

func reset() -> void:
	oxygen_bar.value = oxygen_bar.max_value
	oxygen = oxygen_bar.max_value

func set_oxygen(value: float) -> void:
	oxygen = clampf(value, 0, oxygen_bar.max_value)
	
	if not value:
		oxygen_finished.emit()
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(oxygen_bar, "value", value, 0.1)

func pause_oxygen_for(time_sec: float) -> void:
	oxygen_reduce_timer.stop()
	await get_tree().create_timer(time_sec, false, true).timeout
	oxygen_reduce_timer.start()

func _on_reduce_timer_timeout() -> void:
	oxygen -= oxygen_reduce_amount
