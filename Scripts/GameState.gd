extends Node
class_name GameState

enum GameStates {
	IDLE     = 0,
	CRAFTING = 1,
	BATTLE   = 2,
	FAIL     = 3
}

const ENTITY_LIMIT = 1024;

var State : GameStates;
var Entities : Array;
var PS_Entity : PackedScene = load("res://Scenes/entity.tscn");
var Player : Entity;
var Inventory : Dictionary;

@onready var EntityContainer : Node = $EntityContainer;

func _ready() -> void:
	Entities.resize(ENTITY_LIMIT);
	Entities.fill(null);
	create_player();
	create_cauldron();
	State = GameStates.IDLE;
	return;


func create_entity() -> Entity:
	for i in range(ENTITY_LIMIT):
		if Entities[i] == null:
			Entities[i] = PS_Entity.instantiate();
			Entities[i].EntityID = i;
			Entities[i].entity_death.connect(remove_entity);
			print("Created entity of index ", i);
			return Entities[i];
	return null;


func remove_entity(entityId: int) -> void:
	if entityId == 0:
		player_failed();
		return;

	var entity = Entities[entityId];
	entity.die();
	Entities[entityId] = null;
	return;


func create_player() -> bool:
	var _entity = create_entity();
	var resource_id = Assets.Sprites.PLAYER;
	if resource_id > Assets.Images.size()-1: 
		resource_id = Assets.Sprites.NIL;

	_entity.Sprite = Assets.Images[resource_id];
	_entity.Health = 20;
	_entity.EntityArch = Entity.EntityArchs.PLAYER;
	_entity.IsAlly = true;
	_entity.position = Vector3(0.5,-0.75,0);
	_entity.MovePattern = Entity.MovementPattern.BOUNCE;
	_entity.SwayArc = 0.15;
	_entity.SwaySpeed = 0.2;

	EntityContainer.add_child(_entity);
	return true;


# Might need some streamlining
func create_cauldron():
	var _entity = create_entity();
	var resource_id = Assets.Sprites.PLAYER;
	if resource_id > Assets.Images.size()-1: 
		resource_id = Assets.Sprites.NIL;

	_entity.Sprite = Assets.Images[resource_id];
	_entity.Health = 10;
	_entity.IsAlly = true;
	_entity.EntityArch = Entity.EntityArchs.CAULDRON;
	_entity.position = Vector3(-0.5,-0.75,0);
	_entity.MovePattern = Entity.MovementPattern.SWAY;
	_entity.SwayArc = 0.15;
	_entity.SwaySpeed = 0.2;

	var crafting_timer = Timer.new();
	crafting_timer.wait_time = 3;
	crafting_timer.one_shot = true;

	_entity.CraftingTimer = crafting_timer;
	_entity.finished_crafting.connect(add_item_to_inventory);

	EntityContainer.add_child(_entity);
	return;


func create_enemy() -> bool:
	return false;


func add_item_to_inventory(item: Item) -> bool:
	if Inventory.has(item):
		Inventory[item] += 1;
	else:
		Inventory[item] = 1;

	print(Inventory);
	return true;


func remove_item_from_inventory(item: Item) -> bool:
	if !Inventory.has(item):
		return false;

	Inventory[item] -= 1;
	if Inventory[item] <= 0:
		Inventory.erase(item);
	
	return true;


func is_item_in_inventory(item: Item) -> bool:
	if Inventory.has(item):
		return true;
	return false;


func player_failed() -> void:
	return;
