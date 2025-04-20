extends CanvasLayer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn");
