extends Node;
class_name Assets;

enum Sprites {
	NIL,
    PLAYER,
    CAULDRON,
	GHOUL,
	MAX
};

static var Images : Array = [
	load("res://Assets/MissingTexture.png"),
    load("res://Assets/Player.png"),
    load("res://Assets/Cauldron.png")
];

enum ItemType {
    NIL,
    HERBAL_ESSENCE,
    COMMON_ESSENCE,
    UNDEAD_ESSENCE,
    ANIMAL_ESSENCE,
    HOLY_ESSENCE,
    VOID_ESSENCE,
    HEALTH_POTION,
    MAX
};

static var Items : Array = [
    Item.new("NIL ITEM NOT FOUND", Images[Sprites.NIL], Item.ItemTypes.ESSENCE, ItemType.NIL),
    Item.new("Herbal Essence", Images[Sprites.NIL], Item.ItemTypes.ESSENCE, ItemType.HERBAL_ESSENCE),
    Item.new("Common Essence", Images[Sprites.NIL], Item.ItemTypes.ESSENCE, ItemType.COMMON_ESSENCE),
    Item.new("Undead Essence", Images[Sprites.NIL], Item.ItemTypes.ESSENCE, ItemType.UNDEAD_ESSENCE),
    Item.new("Animal Essence", Images[Sprites.NIL], Item.ItemTypes.ESSENCE, ItemType.ANIMAL_ESSENCE),
    Item.new("Holy Essence", Images[Sprites.NIL], Item.ItemTypes.ESSENCE, ItemType.HOLY_ESSENCE),
    Item.new("Void Essence", Images[Sprites.NIL], Item.ItemTypes.ESSENCE, ItemType.VOID_ESSENCE),
    Item.new("Health Potion", Images[Sprites.NIL], Item.ItemTypes.CARD, ItemType.HEALTH_POTION),
];

static var CraftingRecipes : Array = [
    {Items[ItemType.NIL]: 1},
    {}
];

