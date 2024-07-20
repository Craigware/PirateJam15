extends VBoxContainer

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Restart"):
		if visible:
			visible = false;
			get_tree().reload_current_scene();
			return;