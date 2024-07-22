extends Node3D

@export var DayState : GameState.DayStates;
@export var SkyColor : Color;
@export var DayCycleTimer : float;

var SUN_TEXTURE : Texture2D = load("res://Assets/Sun.png");
var MOON_TEXTURE : Texture2D = load("res://Assets/MissingTexture.png");

var started : bool = false;
var seconds = 0;
func _process(_delta: float) -> void:
	var current = $Background.mesh.material.albedo_color
	current = Vector3(current.r, current.g, current.b);
	
	var new_color = current.slerp(Vector3(SkyColor.r, SkyColor.g, SkyColor.b), 1 * _delta);
	new_color = Color(new_color.x, new_color.y, new_color.z);

	if (SkyColor):
		$Background.mesh.material.albedo_color = new_color;
	
	if started:
		var x = 2 / (DayCycleTimer*2) * _delta;
		$Sun.position.x -= x;

		if $Sun.position.x < -1:
			$Sun.position.x = 1;
		
		seconds += _delta;
		if (seconds - floor(seconds) == 0):
			print(seconds)
	pass


func update_day_state(dayState: GameState.DayStates):
	DayState = dayState;
	if DayState == GameState.DayStates.NIGHT or DayState == GameState.DayStates.DUSK:
		$Sun.mesh.material.albedo_texture = MOON_TEXTURE;
	else:
		$Sun.mesh.material.albedo_texture = SUN_TEXTURE;
	pass