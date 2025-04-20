extends StaticBody3D;

##key
@export var has_key : bool = false;
@onready var key : Resource = load("res://scenes/breakable_barrel/key.tscn");
var key_instance;

@onready var animated_barrel : Resource = load("res://scenes/breakable_barrel/animated_barrel.tscn");
@onready var static_barrel_collision : CollisionShape3D = $colision;
var barrel_instance;
var has_been_shot : bool = false;

#signals
signal player_collected_key;

func _on_bullet_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("bullet") and !has_been_shot:
		has_been_shot = true;
		barrel_instance = animated_barrel.instantiate();
		barrel_instance.global_transform = global_transform;
		get_parent().add_child(barrel_instance);
		if has_key:
			_spawn_key();
		static_barrel_collision.disabled = true;
		visible = false;

func _spawn_key() -> void:
	key_instance = key.instantiate();
	key_instance.global_transform = global_transform;
	get_parent().add_child(key_instance);
	key_instance.global_position.y += 1;
	if key_instance.has_signal("player_picked_up_key"):
		emit_signal("player_collected_key");
		print("gate key has been collected");
		
