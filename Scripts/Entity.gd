extends Node3D;
class_name Entity;

enum MovementPattern {
	BOUNCE,
	SWAY
}

enum EntityArchs {
	NIL,
	PLAYER,
	CAULDRON,
	GHOUL,
	PEDESTRIAN
}

@export var Health: int;
@export var Sprite: Texture2D;
@export var IsAlly: bool;
@export var IsAgressive: bool;
@export var MovePattern : MovementPattern;
@export var SwaySpeed : float;
@export var SwayArc : float;
@export var EntityArch : EntityArchs;
@export var ItemDropID : Assets.ItemType;
@export var IsCrafting : bool;
@export var MeshSize : Vector2 = Vector2(2,2);

var AppliedEssence : Dictionary = {Assets.Items[Assets.ItemType.NIL]: 1};

var AttackTimer : Timer;
var EntityID : int;
signal entity_death(entity_id: int);
signal finished_crafting(item: Item);

var CraftingTimer : Timer;

var direction = 1;
var startingY;

func _ready() -> void:
	var material = StandardMaterial3D.new();
	$SpriteMesh.mesh = $SpriteMesh.mesh.duplicate();
	material = StandardMaterial3D.new();
	material.albedo_texture = Sprite;
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED;
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR;
	$SpriteMesh.mesh.material = material;
	$SpriteMesh.mesh.size = MeshSize;

	startingY = position.y;

	if CraftingTimer != null:
		add_child(CraftingTimer);
		CraftingTimer.timeout.connect(finish_crafting);

	return;


#Some reason if this is process the movement glitches out and stops, physics seems to fix this
func _physics_process(delta: float) -> void:
	#Implement more human movement later, more imperfections
	#lerp this later
	if MovePattern == MovementPattern.SWAY:
		rotate_z(SwaySpeed * delta * direction);
		if rotation.z >= SwayArc or rotation.z <= -SwayArc:
			direction *= -1

	# This gets stuck sometimes for some reason
	if MovePattern == MovementPattern.BOUNCE:
		position += Vector3(0, SwaySpeed * delta * direction, 0);
		if position.y >= startingY + SwayArc or position.y <= startingY - SwayArc:
			direction *= -1;


func update_health(amount) -> void:
	Health += amount;
	if Health <= 0:
		entity_death.emit(EntityID);
	return;


func apply_essence(item: Item) -> void:
	if AppliedEssence.has(item):
		AppliedEssence[item] += 1;
	else:
		AppliedEssence[item] = 1;

	if EntityArch == EntityArchs.CAULDRON:
		begin_crafting();
	return;


func begin_crafting() -> void:
	CraftingTimer.start();
	IsCrafting = true;
	return;


func finish_crafting() -> void:
	# BUNCHA SHIIIIIIIIEEET
	# Checks all of the item recipes, gets all recipes that have the same items that are applied to this entity
	# Gets the differences between the two dictionaries, if the crafting recipe requires more than what the entity has it has the difference of -1000 and will be ignored
	# Gets the lowest difference that isn't -1000
	var item = null;

	var potential_items = [];
	for i in range(Assets.ItemType.MAX):
		if AppliedEssence.keys() == Assets.CraftingRecipes[i].keys():
			potential_items.append(i);

	if potential_items.size() == 0:
		return;

	var differences = [];
	for i in range(potential_items.size()):
		var difference = 0;
		var keys = AppliedEssence.keys();
		for x in range(keys.size()):
			var _diff = AppliedEssence[keys[x]] - Assets.CraftingRecipes[i][keys[x]];
			if _diff < 0:
				difference = -1000;
				break;
			else:
				difference += _diff;
		differences.append(difference);
	
	var lowest = 0;
	for i in range(differences.size()):
		if differences[lowest] == -1000:
			lowest = i
		if differences[i] < differences[lowest] && differences[i] != -1000:
			lowest = i;

	item = Assets.Items[potential_items[lowest]];
	finished_crafting.emit(item);
	return;


func die() -> void:
	queue_free();
	# if Entities[entityId].ItemDropID != null:
	# 	add_item_to_inventory(Entities[entityId].ItemDropID);
	return;
