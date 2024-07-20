extends Node
class_name GameState

enum GameStates {
	IDLE     = 0,
	CRAFTING = 1,
	BATTLE   = 2,
	FAIL     = 3
}

enum DayStates {
	NIL,
	DAWN,
	DAY,
	DUSK,
	NIGHT,
	MAX
}

enum CloudStates {
	NIL,
	CLEAR,
	CLOUDY,
	OVERCAST,
	MAX
}

const ENTITY_LIMIT = 1024;

var State : GameStates;
var Entities : Array;
var PS_Entity : PackedScene = load("res://Scenes/entity.tscn");
var Player : Entity;
var Inventory : Dictionary;
var DayState : DayStates;
var CloudState : CloudStates;
var IsShadowed : bool;

var DaylightTimer : Timer;
var CloudStateTimer : Timer;
var ShadowStateTimer : Timer;

var AggrodArchitypes : Array = [
	false,
	false,
	false,
	true,
	false,
];

@onready var EntityContainer : Node = $EntityContainer;

func _process(_delta: float) -> void:
	var _isCrafting = false;
	for i in range(Entities.size()):
		if Entities[i] == null: continue;
		if Entities[i].IsAlly && Entities[i].IsCrafting:
			_isCrafting = true;
	pass

func start_game() -> void:
	Entities.resize(ENTITY_LIMIT);
	Entities.fill(null);
	create_player();
	create_cauldron();
	create_enemy(1);
	create_enemy(1);
	create_enemy(1);

	DaylightTimer = Timer.new();
	DaylightTimer.wait_time = 75;
	DaylightTimer.timeout.connect(update_day_state);
	DaylightTimer.autostart = true;
	add_child(DaylightTimer);

	CloudStateTimer = Timer.new();
	CloudStateTimer.wait_time = randf_range(5, 20);
	CloudStateTimer.autostart = true;
	CloudStateTimer.one_shot = true;
	CloudStateTimer.timeout.connect(update_cloud_state);
	add_child(CloudStateTimer);

	ShadowStateTimer = Timer.new();
	ShadowStateTimer.wait_time = 3;
	ShadowStateTimer.autostart = true;
	ShadowStateTimer.timeout.connect(update_shadow_state);
	add_child(ShadowStateTimer);

	update_cloud_state(CloudStates.CLEAR);
	IsShadowed = false;
	update_day_state(DayStates.DAWN);

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


func get_random_spawn_location(isAlly: bool) -> Vector3:
	var x;
	if isAlly:
		x = randf_range(-.8, 0);
	else:
		x = randf_range(0,.8);
	var y = randf_range(-2.15, -1.6);
	var z = randf_range(-1, 0.25);

	return Vector3(x,y,z);

func create_player() -> bool:
	var _entity = create_entity();
	var resource_id = Assets.Sprites.PLAYER;
	if resource_id > Assets.Images.size()-1: 
		resource_id = Assets.Sprites.NIL;

	_entity.Sprite = Assets.Images[resource_id];
	_entity.Health = 20;
	_entity.EntityArch = Entity.EntityArchs.PLAYER;
	_entity.IsAlly = true;
	_entity.position = Vector3(-.2,-2.0,0.5);
	_entity.MovePattern = Entity.MovementPattern.BOUNCE;
	_entity.SwayArc = 0.15;
	_entity.SwaySpeed = 0.2;
	_entity.MeshSize = Vector2(2,3);

	EntityContainer.add_child(_entity);
	return true;


# Might need some streamlining
# need to have a max sway arc that doesn't go off screen
func create_cauldron():
	var _entity = create_entity();
	var resource_id = Assets.Sprites.CAULDRON;
	if resource_id > Assets.Images.size()-1: 
		resource_id = Assets.Sprites.NIL;

	_entity.Sprite = Assets.Images[resource_id];
	_entity.Health = 10;
	_entity.IsAlly = true;
	_entity.EntityArch = Entity.EntityArchs.CAULDRON;
	_entity.position = get_random_spawn_location(_entity.IsAlly);
	_entity.position.z = 0.25;
	_entity.MovePattern = randi_range(0,1);
	_entity.SwayArc = 0.05;
	_entity.SwaySpeed = 0.1;
	_entity.MeshSize = Vector2(1.75,1.75);

	var crafting_timer = Timer.new();
	crafting_timer.wait_time = 3;
	crafting_timer.one_shot = true;

	_entity.CraftingTimer = crafting_timer;
	_entity.finished_crafting.connect(add_item_to_inventory);

	EntityContainer.add_child(_entity);
	return;


func create_enemy(_architype) -> bool:
	var _entity = create_entity();
	var resource_id = Assets.Sprites.GHOUL;
	if resource_id > Assets.Images.size()-1: 
		resource_id = Assets.Sprites.NIL;

	_entity.Sprite = Assets.Images[resource_id];
	_entity.Health = 10;
	_entity.EntityArch = Entity.EntityArchs.GHOUL;
	_entity.IsAlly = false;
	_entity.position = get_random_spawn_location(_entity.IsAlly);
	_entity.MovePattern = Entity.MovementPattern.SWAY;
	_entity.SwayArc = 0.05;
	_entity.SwaySpeed = 0.1;
	_entity.MeshSize = Vector2(2,3);

	EntityContainer.add_child(_entity);
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


func update_day_state(_dayState: DayStates = DayStates.NIL):
	var updatedState = DayState;

	if (_dayState == DayStates.NIL):
		if updatedState == DayStates.MAX - 1:
			updatedState = DayStates.DAWN;
		else:
			updatedState = DayState + 1 as DayStates;
	else:
		updatedState = _dayState;
		
	
	DayState = updatedState as DayStates;
	print("DayState updated to ", DayState);

func update_cloud_state(_cloudState: CloudStates = CloudStates.NIL):
	if _cloudState == CloudStates.NIL:
		_cloudState = randi_range(1,CloudStates.MAX-1) as CloudStates;
	CloudState = _cloudState;
	CloudStateTimer.wait_time = randf_range(5,20);
	CloudStateTimer.start();
	print("Cloud state updated to ", CloudState);

func update_shadow_state():
	var chance = randf_range(0,1);
	if CloudState == CloudStates.OVERCAST:
		if chance < .80:
			IsShadowed = true;
		else:
			IsShadowed = false;
	
	if CloudState == CloudStates.CLOUDY:
		if chance < .50:
			IsShadowed = true;
		else:
			IsShadowed = false;

	if CloudState == CloudStates.CLEAR:
		if chance < .05:
			IsShadowed = true;
		else:
			IsShadowed = false;

	print("Shadow state updated. Is it currently shadowed? ", IsShadowed);

func player_failed() -> void:
	return;
