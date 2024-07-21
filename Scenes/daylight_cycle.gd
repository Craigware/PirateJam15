extends Node3D

@export var DayState : GameState.DayStates;
@export var SkyColor : Color;
@export var DayCycleTimer : float;

func _process(_delta: float) -> void:
	var current = $Background.mesh.material.albedo_color
	current = Vector3(current.r, current.g, current.b);
	
	var new_color = current.slerp(Vector3(SkyColor.r, SkyColor.g, SkyColor.b), 1 * _delta);
	new_color = Color(new_color.x, new_color.y, new_color.z);

	if (SkyColor):
		$Background.mesh.material.albedo_color = new_color;
		
	pass
