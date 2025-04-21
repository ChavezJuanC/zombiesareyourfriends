extends CharacterBody3D

var chase : bool = false;
var player: CharacterBody3D = null
var MOVEMENT_SPEED: float = randf_range(2.3, 2.5);
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D;
@onready var zombie_animation_player : AnimationPlayer = $AuxScene/AnimationPlayer;
@onready var audio_loop_player : AudioStreamPlayer3D = $audio_loop_player;

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	zombie_animation_player.play("Idle", 0, 2);
	if players.size() > 0:
		player = players[0]
	
	_start_sound_loop();

func _start_sound_loop() -> void:
	await get_tree().create_timer(randf_range(0.1, 3)).timeout;
	audio_loop_player.unit_size = 3.0;
	audio_loop_player.volume_db = 0.5;
	audio_loop_player.pitch_scale = 0.8;
	audio_loop_player.play();

func _physics_process(_delta: float) -> void:
	if chase:
		if player == null:
			return

		navigation_agent.set_target_position(player.global_position)

		if navigation_agent.is_navigation_finished():
			return

		var next_position: Vector3 = navigation_agent.get_next_path_position()
		var direction: Vector3 = (next_position - global_position).normalized()
		velocity = direction * MOVEMENT_SPEED
		
		if !global_position.is_equal_approx(next_position):
			# Make the enemy face the direction it's moving
			look_at(Vector3(next_position.x, global_position.y, next_position.z));
			rotate_y(PI);
		
		move_and_slide();

func _on_gate_gate_opened() -> void:
	await get_tree().create_timer(randf_range(0.2, 1.5)).timeout;
	zombie_animation_player.play("Walking");
	chase = true;
# Replace with function body.
