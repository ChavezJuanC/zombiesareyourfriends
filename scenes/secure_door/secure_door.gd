extends StaticBody3D

@onready var door_animation_player : AnimationPlayer = $door_animation_player
@onready var spot_light : SpotLight3D = $"Oculus Sensor/light_source/SpotLight3D";
@onready var interaction_hud_label : Label = $interaction_hud/Label;
@onready var alert_label : Label = $interaction_hud/Alert;
@onready var alert_label_animation_player : AnimationPlayer = $interaction_hud/AnimationPlayer;

var friends_rescued : bool = false;

func _ready() -> void:
	spot_light.light_color = Color(1, 0, 0)  # Full red
	interaction_hud_label.visible = false;

func _on_scan_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("zombie"):
		spot_light.light_color = Color(0, 1, 0)  # Full green
		door_animation_player.play("open_door")
		await get_tree().create_timer(1).timeout;
		get_tree().change_scene_to_file("res://scenes/other_huds/win_hud.tscn");
	if body.is_in_group("player") and !friends_rescued:
		interaction_hud_label.visible = true;

func _on_scan_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		interaction_hud_label.visible = false;

func _on_gate_gate_opened() -> void:
	friends_rescued = true;
	alert_label_animation_player.play("blink_alert");
	
	
