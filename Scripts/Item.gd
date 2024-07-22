extends Resource;
class_name Item;

enum ItemTypes {
	ESSENCE,
	CARD,
	SPECIAL
}

@export var Name : String;
@export var ItemID: int;
@export var Icon : Texture2D;
@export var ItemType : ItemTypes;

func _init(name: String, icon: Texture2D, itemType: ItemTypes, itemID: int) -> void:
	Name = name;
	Icon = icon;
	ItemType = itemType;
	ItemID = itemID;
	return;