extends Button;
class_name Card;

@export var related_item : Item;

func hovered() -> void:
	scale = Vector2(2.0, 2.0);
	position = position - Vector2(size.x/2, size.y);
	z_index = 1;

func unhovered() -> void:
	scale = Vector2(1.0, 1.0);
	position = position + Vector2(size.x/2, size.y);
	z_index = 0;

# I wanna have a hearthstone style arrow here
func selected() -> void:
	pass

func deselected() -> void:
	pass