extends Area3D

@onready var key_animation_player : AnimationPlayer = $key_animation_player;
@onready var interacton_hud : CanvasLayer = $interaction_hud;

var player_in_range: bool = false;
var collected : bool  = false;

signal player_picked_up_key;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	key_animation_player.play("spin");
	interacton_hud.visible = false;


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range and !collected:
		collected = true;
		interacton_hud.visible = false;
		key_animation_player.play("collected");

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = true;
		interacton_hud.visible = true;

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = false;

func _on_key_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "collected":
		emit_signal("player_picked_up_key");
		queue_free();
