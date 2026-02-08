class_name StartMenu
extends Control

@export var time_after_end_anim: float

var started: bool: set = set_started

@onready var menu: Control = $Menu as Control
@onready var arrow_text: RichTextLabel = %ArrowText as RichTextLabel
@onready var swim_text: RichTextLabel = %SwimText as RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer

func _ready() -> void:
	started = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("boost") and not started:
		started = true
		get_viewport().set_input_as_handled()

func set_started(value: bool) -> void:
	started = value
	menu.visible = not started
	get_tree().paused = not started
