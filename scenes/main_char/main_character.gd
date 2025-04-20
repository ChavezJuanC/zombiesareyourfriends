extends CharacterBody3D

const WALK_SPEED: float = 3.7;
const RUN_SPEED: float = 5.5
var speed : float;
const JUMP_VELOCITY: float = 4.5
const SENSITIVITY: float = 0.005;


@onready var head : Node3D = $head;
@onready var cam : Camera3D = $head/Camera3D;

##head motion
const BOB_FREQ = 2.0;
const BOB_AMP = 0.08;
var t_bob : float;

##shooting 
var bullet : Resource = load("res://scenes/bullets/bullet.tscn");
var bullet_instance;
@onready var gun_animation_player : AnimationPlayer = $head/Camera3D/hand/gun/AnimationPlayer;
@onready var barrel : Node3D = $head/Camera3D/hand/gun/barrel;
@onready var gun_audio_player : AudioStreamPlayer3D = $head/Camera3D/hand/gun/gun_auido_player;


##attacked
var on_attacked_cooldown : bool = false;
var enemy_in_range : bool = false;
signal player_takes_damage(total_dmg: float);

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("run"):
		speed = RUN_SPEED;
	else:
		speed = WALK_SPEED;

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down");
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x , direction.x * speed, delta * 7.0);
			velocity.z = lerp(velocity.z , direction.z * speed, delta * 7.0);
	else:
		velocity.x = lerp(velocity.x , direction.x * speed, delta * 2.0);
		velocity.z = lerp(velocity.z , direction.z * speed, delta * 2.0);
	
	t_bob += delta * velocity.length() * float(is_on_floor());
	cam.transform.origin = _head_bob(t_bob);
	
	##shooting
	if Input.is_action_just_pressed("shoot"):
		_shoot();

	move_and_slide();
	
func _shoot() -> void:
	if !gun_animation_player.is_playing():
		##sound effect here
		gun_audio_player.play();
		gun_animation_player.play("shot", 0, 1.5);
		bullet_instance = bullet.instantiate();
		bullet_instance.global_transform = barrel.global_transform; # <- Fixed!
		get_parent().add_child(bullet_instance);

func _head_bob(time : float) -> Vector3:
	var pos = Vector3.ZERO;
	pos.y = sin(time * BOB_FREQ) * BOB_AMP;
	pos.x = cos(time * BOB_FREQ /2) * BOB_AMP;
	return pos;


#handle head movement
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY);
		cam.rotate_x(-event.relative.y * SENSITIVITY);
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-40), deg_to_rad(60));


##ATTACKED
func _start_cool_down() -> void:
	await get_tree().create_timer(3).timeout;
	if enemy_in_range:
		_apply_damage_taken(20.0);
		_start_cool_down();

func _on_hit_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		enemy_in_range = true;
		_apply_damage_taken(20.0);
		_start_cool_down();
		
func _apply_damage_taken(dmg : float):
	print("DMAGE : ", dmg);
	emit_signal("player_takes_damage", dmg);

func _on_hit_box_body_exited(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		enemy_in_range = false;
