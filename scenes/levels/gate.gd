extends StaticBody3D

@onready var gate_animation_player : AnimationPlayer = $gate_animation_player;
var player_has_key : bool = false;
var player_in_range : bool = false;
var gate_triggered : bool = false;

##sound
@onready var gate_audio_player : AudioStreamPlayer3D = $gate_audio_player;

func _ready() -> void:
	gate_audio_player.volume_db = -25.00;
	gate_audio_player.play();

func _on_breakable_barrel_player_collected_key() -> void:
	player_has_key = true;

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("player in range");
		player_in_range = true;


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = false;


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and player_has_key and player_in_range and !gate_triggered:
		gate_triggered = true;
		gate_audio_player.stop();
		gate_animation_player.play("opening");
