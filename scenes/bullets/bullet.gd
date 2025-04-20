extends RigidBody3D;

const BULLET_SPEED: float = 100.0;

@onready var bullet_mesh : MeshInstance3D = $bullet_mesh;
@onready var bullet_raycast : RayCast3D = $RayCast3D;
@onready var bullet_particles : GPUParticles3D = $GPUParticles3D;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	position += transform.basis * Vector3(0,0, -BULLET_SPEED) * delta;
	if bullet_raycast.is_colliding():
		bullet_mesh.visible = false;
		bullet_particles.emitting = true;
		await get_tree().create_timer(1).timeout;
		queue_free();

func _on_timer_timeout() -> void:
	queue_free();
