extends Node3D

const INTENSITY : float = 0.2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for pieces:RigidBody3D in self.get_children():
		pieces.apply_impulse(pieces.get_child(0).position * INTENSITY, self.global_position);
