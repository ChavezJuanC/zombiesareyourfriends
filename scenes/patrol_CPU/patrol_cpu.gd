extends CharacterBody3D

var player: CharacterBody3D = null
const MOVEMENT_SPEED: float = 4.5;
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D;
@onready var light_animation_player : AnimationPlayer = $OmniLight3D/AnimationPlayer;
@onready var hit_audio_player : AudioStreamPlayer3D = $hit_audio_player;
@onready var alarm_audio_player : AudioStreamPlayer3D =  $alarm_audio_player;

var pause_chase : bool = false;

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player");
	if players.size() > 0:
		player = players[0]
		
	alarm_audio_player.volume_db = -25.00;

func _physics_process(_delta: float) -> void:
	if !pause_chase:
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
		
		move_and_slide()

func _on_hit_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("bullet"):
		hit_audio_player.play();
		pause_chase = true;
		light_animation_player.play("idle");
		alarm_audio_player.play();
		await  get_tree().create_timer(randi_range(5,30)).timeout;
		light_animation_player.stop();
		alarm_audio_player.stop();
		light_animation_player.play("RESET");
		pause_chase = false;
