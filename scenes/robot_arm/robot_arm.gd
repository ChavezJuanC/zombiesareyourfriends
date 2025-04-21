extends StaticBody3D

@export var animated : bool = true;
@onready var animation_player : AnimationPlayer = $AnimationPlayer;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if animated:
		_start_animation_loop();


func _start_animation_loop() -> void:
	while true:
		if !animation_player.is_playing():
			animation_player.play("idle");
			await get_tree().create_timer(randf_range(2.0, 4.0)).timeout;
