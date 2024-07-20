extends VBoxContainer

signal start_signal();

func start_game() -> void:
	visible = false;
	start_signal.emit();
	return;

func quit() -> void:
	get_tree().quit();
