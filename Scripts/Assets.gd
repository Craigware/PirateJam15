extends Node;
class_name Assets;

enum Sprites {
	NIL     = 0,
    PLAYER  = 1,
	GHOUL   = 2,
	MAX
};

static var Images : Array = [
	load("res://Assets/MissingTexture.png"),
];

enum ItemType {
    NIL,
    HEALTH_POTION,
    MAX
};

static var Items : Array = [
    Item.new("NIL ITEM NOT FOUND", Images[Sprites.NIL]),
    Item.new("Health Potion", null)
];

static var CraftingRecipes : Array = [
    {Items[ItemType.NIL]: 1},
    {}
];

