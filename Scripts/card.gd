extends Button;
class_name Card;

@export var related_item : Item;
var essence_amount = 0;
var isHovered : bool = false;
var isSelected : bool = false;


func _ready() -> void:
	if related_item.ItemType == Item.ItemTypes.CARD or related_item.ItemType == Item.ItemTypes.SPECIAL:
		var _icon = $MarginContainer/Card/MarginContainer/VBoxContainer/CenterContainer/Icon;
		_icon.texture = related_item.Icon; 
		var name_label = $MarginContainer/Card/MarginContainer/VBoxContainer/Name;
		name_label.text = related_item.Name;
	
	if related_item.ItemType == Item.ItemTypes.ESSENCE:
		var _icon = $MarginContainer/Icon;
		var _amount = $Amount;

		_icon.texture = related_item.Icon;
		_amount.text = "[center]"+str(essence_amount);
	pass

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Click"):
		if isHovered:
			selected();
	elif Input.is_action_just_released("Click"):
		if isSelected:
			deselected();

func hovered() -> void:
	isHovered = true;
	scale *= 2;
	position = position - Vector2(size.x/2, size.y);
	z_index = 1;

func unhovered() -> void:
	isHovered = false;
	scale /= 2;
	position = position + Vector2(size.x/2, size.y);
	z_index = 0;

# I wanna have a hearthstone style arrow here
func selected() -> void:
	isSelected = true;
	print("Selected.")
	pass

func deselected() -> void:	
	isSelected = false;
	var gameState = get_node("/root/Main");
	var entity = gameState.entity_ray_cast();

	if entity == null: 
		return;
	if related_item.ItemType == Item.ItemTypes.ESSENCE:
		entity.apply_essence(related_item);
		pass
	if related_item.ItemType == Item.ItemTypes.CARD:
		entity.apply_card(related_item);
		pass
	if related_item.ItemType == Item.ItemTypes.SPECIAL:
		# bunch of ifs for different item effects
		pass

	queue_free();
