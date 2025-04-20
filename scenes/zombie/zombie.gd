extends CharacterBody3D

var player: CharacterBody3D = null
var MOVEMENT_SPEED: float = randf_range(2.5, 3.5);
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D;

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(_delta: float) -> void:
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
