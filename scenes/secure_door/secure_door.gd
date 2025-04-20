extends StaticBody3D

@onready var door_animation_player : AnimationPlayer = $door_animation_player
@onready var spot_light : SpotLight3D = $"Oculus Sensor/light_source/SpotLight3D";

func _ready() -> void:
	spot_light.light_color = Color(1, 0, 0)  # Full red

func _on_scan_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("zombie"):
		spot_light.light_color = Color(0, 1, 0)  # Full green
		door_animation_player.play("open_door")
		await get_tree().create_timer(1).timeout;
		get_tree().change_scene_to_file("res://scenes/other_huds/win_hud.tscn");
