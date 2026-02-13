@tool
class_name GameLevel
extends Node2D

# Used for drawing lines in editor.
const SUB_VIEWPORT_WIDTH: int = 320
const SUB_VIEWPORT_HEIGHT: int = 180
var LINE_COLOR: Color = Color.from_rgba8(87, 87, 148)

func _draw():
	if Engine.is_editor_hint():
		draw_line(Vector2(SUB_VIEWPORT_WIDTH, 0), Vector2(SUB_VIEWPORT_WIDTH, SUB_VIEWPORT_HEIGHT), LINE_COLOR, 1)
		draw_line(Vector2(SUB_VIEWPORT_WIDTH, SUB_VIEWPORT_HEIGHT), Vector2(0, SUB_VIEWPORT_HEIGHT), LINE_COLOR, 1)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
	if get_tree().current_scene == self:
		Global.Levels.switch_to_file(scene_file_path, false)
