extends CanvasLayer

@onready var objectives_label : Label = $obejctives;
@onready var keybinds : Node2D = $keybinds;
@onready var hud_guide : Label  = $hud_guide;
@onready var damage_color : ColorRect = $damage_color;

@onready var health_bar : ProgressBar = $health_bar;
const TOTAL_HEALTH : float = 100.0;
var current_helath : float = 100.0;

func _ready() -> void:
	objectives_label.visible = false;
	keybinds.visible = false;
	damage_color.visible = false;
	_update_health_bar();

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("objectives"):
		objectives_label.visible = true;
		hud_guide.visible = false;
	if Input.is_action_just_released("objectives"):
		objectives_label.visible = false;
		hud_guide.visible = true;

		
	if Input.is_action_pressed("keybinds"):
		keybinds.visible = true;
		hud_guide.visible = false;

	if Input.is_action_just_released("keybinds"):
		keybinds.visible = false;
		hud_guide.visible = true;

func _on_main_character_player_takes_damage(total_dmg: float) -> void:
	damage_color.visible = true;
	current_helath -= total_dmg;
	current_helath = clamp(current_helath, 0, 100);
	await get_tree().create_timer(1).timeout;
	damage_color.visible = false;
	_update_health_bar();


func _update_health_bar() -> void:
	if current_helath != 0:
		health_bar.value = current_helath;
	else:
		get_tree().change_scene_to_file("res://scenes/other_huds/game_over.tscn");
