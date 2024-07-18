extends Resource;
class_name Item;

@export var Name : String;
@export var Icon : Texture2D;

func _init(name: String, icon: Texture2D) -> void:
    Name = name;
    Icon = icon;
    return;