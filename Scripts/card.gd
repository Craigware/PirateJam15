extends Button

func hovered() -> void:
	scale = Vector2(2.0, 2.0);
	position = position - Vector2(size.x/2, size.y);
	z_index = 1;

func unhovered() -> void:
	scale = Vector2(1.0, 1.0);
	position = position + Vector2(size.x/2, size.y);
	z_index = 0;
