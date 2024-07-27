extends Node;
class_name Assets;

enum Sprites {
	NIL,
	PLAYER,
	CAULDRON,
	GHOUL,
	VAMPIRE,
	VILLAGER,
	MAX
};

static var Images : Array = [
	preload("res://Assets/MissingTexture.png"),
	preload("res://Assets/Player.png"),
	preload("res://Assets/Cauldron.png"),
	preload("res://Assets/MissingTexture.png"),
	preload("res://Assets/Vampire.png"),
	preload("res://Assets/Villager.png"),
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
	GREATER_HEALTH_POTION,
	MAGIC_KNIFE,
	SLASHY,
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
	Item.new("Greater Health Potion", Images[Sprites.NIL], Item.ItemTypes.CARD, ItemType.GREATER_HEALTH_POTION),
	Item.new("MAGIC KNIFE", Images[Sprites.NIL], Item.ItemTypes.CARD, ItemType.MAGIC_KNIFE),
	Item.new("Slashy", Images[Sprites.NIL], Item.ItemTypes.CARD, ItemType.SLASHY),
	# Item.new("", Images[Sprites.NIL], Item.ItemTypes.CARD, ItemType.HEALTH_POTION),
	# Item.new("", Images[Sprites.NIL], Item.ItemTypes.CARD, ItemType.HEALTH_POTION),
	# Item.new("", Images[Sprites.NIL], Item.ItemTypes.CARD, ItemType.HEALTH_POTION),
	# Item.new("", Images[Sprites.NIL], Item.ItemTypes.CARD, ItemType.HEALTH_POTION),
	# Item.new("", Images[Sprites.NIL], Item.ItemTypes.CARD, ItemType.HEALTH_POTION),
	# Item.new("", Images[Sprites.NIL], Item.ItemTypes.CARD, ItemType.HEALTH_POTION),
	# Item.new("", Images[Sprites.NIL], Item.ItemTypes.CARD, ItemType.HEALTH_POTION),
	# Item.new("", Images[Sprites.NIL], Item.ItemTypes.CARD, ItemType.HEALTH_POTION),
];

static var CraftingRecipes : Array = [
	{Items[ItemType.NIL]: 1}, #NIL
	{Items[ItemType.NIL]: 1}, #H#
	{Items[ItemType.NIL]: 1}, #CE
	{Items[ItemType.NIL]: 1}, #UE
	{Items[ItemType.NIL]: 1}, #AE
	{Items[ItemType.NIL]: 1}, #HE
	{Items[ItemType.NIL]: 1}, #VE
	{Items[ItemType.COMMON_ESSENCE]: 1}, #HP
	{Items[ItemType.COMMON_ESSENCE]: 2, Items[ItemType.HOLY_ESSENCE]: 1}, # GHP
	{Items[ItemType.COMMON_ESSENCE]: 1, Items[ItemType.UNDEAD_ESSENCE]: 1}, # Magic knife
	{Items[ItemType.UNDEAD_ESSENCE]: 2, Items[ItemType.ANIMAL_ESSENCE]: 2}, # Slashy
	# {Items[ItemType.COMMON_ESSENCE]: 1, Items[ItemType.UNDEAD_ESSENCE]: 1},
];