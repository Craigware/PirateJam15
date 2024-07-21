extends Node;
class_name Assets;

enum Sprites {
	NIL     = 0,
    PLAYER  = 1,
    CAULDRON = 2,
	GHOUL   = 3,
	MAX
};

static var Images : Array = [
	load("res://Assets/MissingTexture.png"),
    load("res://Assets/Player.png"),
    load("res://Assets/Cauldron.png")
];

enum ItemType {
    NIL,
    HEALTH_POTION,
    MAX
};

static var Items : Array = [
    Item.new("NIL ITEM NOT FOUND", Images[Sprites.NIL], Item.ItemTypes.ESSENCE),
    Item.new("Health Potion", Images[Sprites.NIL], Item.ItemTypes.CARD),
];

static var CraftingRecipes : Array = [
    {Items[ItemType.NIL]: 1},
    {}
];

