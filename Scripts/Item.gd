extends Resource;
class_name Item;

enum ItemTypes {
    ESSENCE,
    CARD
}

@export var Name : String;
@export var Icon : Texture2D;
@export var Itemtype : ItemTypes;

func _init(name: String, icon: Texture2D, itemType: ItemTypes) -> void:
    Name = name;
    Icon = icon;
    Itemtype = itemType;
    return;