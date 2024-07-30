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
	VILLAGER,
	GUARD,
	VAMPIRE,
	GOBLIN,
	PIG
}

@export var Health: float;
@export var MaxHealth: float;
@export var AttackDamage : float;
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
@export var MeshOffset : Vector3 = Vector3(0,0,0);
@export var AttackRate : float = 0;
@export var Aggrod : bool = false;
var Dead : bool = false;
var CraftingFailedCount : int = 0;
var AppliedEssence : Dictionary = {};

var LeaveTimer : Timer;
var AttackTimer : Timer;
var EntityID : int;
signal entity_death(entity_id: int);
signal finished_crafting(item: Item);

var CraftingTimer : Timer;

var direction = 1;
var startingY;

func _ready() -> void:
	MaxHealth = Health;
	var material = StandardMaterial3D.new();
	$SpriteMesh.position += MeshOffset;
	$SpriteMesh.mesh = $SpriteMesh.mesh.duplicate();
	material = StandardMaterial3D.new();
	material.albedo_texture = Sprite;
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED;
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR;
	$SpriteMesh.mesh.material = material;
	$SpriteMesh.mesh.size = MeshSize;
	$Col.shape.size.y = MeshSize.y;
	$Col.shape.size.x = MeshSize.x;
	
	startingY = position.y;
	position.y -= 1;

	if AttackTimer != null:
		add_child(AttackTimer);
		AttackTimer.timeout.connect(attack);

	if CraftingTimer != null:
		add_child(CraftingTimer);
		CraftingTimer.timeout.connect(finish_crafting);

	if LeaveTimer != null:
		add_child(LeaveTimer);
	return;

var enterCompleted = false;
func _physics_process(delta: float) -> void:
	#Implement more human movement later, more imperfections
	#lerp this later
	if !enterCompleted:
		position.y = clamp(position.y + 0.5 * delta, position.y, startingY);
		if position.y >= startingY: enterCompleted = true;
	
	if Dead:
		position.y -=  1 * delta;

	if MovePattern == MovementPattern.SWAY:
		rotate_z(SwaySpeed * delta * direction);
		if rotation.z >= SwayArc or rotation.z <= -SwayArc:
			direction *= -1

	# This gets stuck sometimes for some reason
	if MovePattern == MovementPattern.BOUNCE && enterCompleted:
		position += Vector3(0, SwaySpeed * delta * direction, 0);
		if position.y >= startingY + SwayArc or position.y <= startingY - SwayArc:
			direction *= -1;


func update_health(amount, dropItem: bool = true) -> void:
	Health += amount;
	var color_update = 1 - Health / MaxHealth;
	var modulation = Vector3(1,1,1);
	modulation.y -= color_update;
	modulation.z -= color_update;
	$SpriteMesh.mesh.material.albedo_color = Color(modulation.x, modulation.y, modulation.z);
	var particle = get_node("Particles") as CPUParticles3D;
	if amount < 0:
		particle.mesh.material.albedo_texture = Assets.Images[Assets.Sprites.NIL];
		get_node("/root/AudioSystem").play_sound_effect(AudioSystem.SoundEffectCatalog.AH);
	else:
		particle.mesh.material.albedo_texture = Assets.Images[Assets.Sprites.NIL];
		get_node("/root/AudioSystem").play_sound_effect(AudioSystem.SoundEffectCatalog.MM);
	particle.emitting = true;
	if Health <= 0:
		if ItemDropID != 0 && dropItem:
			get_node("/root/Main").add_item_to_inventory(Assets.Items[ItemDropID]);
		entity_death.emit(EntityID);
	return;


func attack() -> void:
	var gamestate = get_node("/root/Main") as GameState;
	var target;
	for i in range(len(gamestate.Entities)):
		if gamestate.Entities[i] == null: continue;
		if gamestate.Entities[i].IsAlly != IsAlly && gamestate.AggrodArchitypes[EntityArch] == true:
			target = gamestate.Entities[i];
			break;

	match (EntityArch):
		EntityArchs.PLAYER:
			target.update_health(-2)
		
		EntityArchs.VILLAGER:
			if gamestate.AggrodArchitypes[EntityArchs.VILLAGER]:
				target.update_health(-2);
		
		EntityArchs.VAMPIRE:
			target.update_health(-4);

		EntityArchs.GUARD:
			if (gamestate.AggrodArchitypes[EntityArchs.GUARD]):
				target.update_health(-6);

		_:
			pass

	#attack based of this units type

func apply_essence(item: Item) -> bool:
	# Change this later if decide to be able to apply essence to creatures
	if EntityArch != EntityArchs.CAULDRON: return false;

	if AppliedEssence.has(item):
		AppliedEssence[item] += 1;
	else:
		AppliedEssence[item] = 1;

	if EntityArch == EntityArchs.CAULDRON:
		begin_crafting();
	return true;


func apply_card(item: Item) -> void:
	var particle = get_node("Particles") as CPUParticles3D;
	match (item.ItemID):
		Assets.ItemType.HEALTH_POTION:
			update_health(5);
			particle.mesh.material.albedo_texture = Assets.Images[Assets.Sprites.NIL];

		Assets.ItemType.GREATER_HEALTH_POTION:
			update_health(10);

		Assets.ItemType.MAGIC_KNIFE:
			update_health(-10);
	
	particle.emitting = true;

func begin_crafting() -> void:
	$Smoke.visible = true;
	CraftingTimer.start();
	IsCrafting = true;
	return;


func finish_crafting() -> void:
	# BUNCHA SHIIIIIIIIEEET
	# Checks all of the item recipes, gets all recipes that have the same items that are applied to this entity
	# Gets the differences between the two dictionaries, if the crafting recipe requires more than what the entity has it has the difference of -1000 and will be ignored
	# Gets the lowest difference that isn't -1000
	var item = null;
	var keys = AppliedEssence.keys();
	print(CraftingFailedCount);

	# logic error here 
	var potential_items = [];
	for i in range(Assets.ItemType.MAX):
		var recipe_keys = Assets.CraftingRecipes[i].keys();
		var count = 0;
		for x in range(len(keys)):
			if recipe_keys.has(keys[x]):
				count += 1;
		
		if count == len(recipe_keys):
			potential_items.append(i);	

	if potential_items.size() == 0:
		CraftingFailedCount += 1;
		if CraftingFailedCount >= 3:
			CraftingFailedCount = 0;
			AppliedEssence = {}
			IsCrafting = false;
			$Smoke.visible = false;
			get_node("/root/AudioSystem").play_sound_effect(AudioSystem.SoundEffectCatalog.PWOSH);
			return;
		begin_crafting();
		return;

	var differences = [];
	for i in range(potential_items.size()):
		var difference = 0;
		var recipe_keys = Assets.CraftingRecipes[i].keys();

		for x in range(len(recipe_keys)):
			if !AppliedEssence.has(recipe_keys[x]):
				difference = -1000;
				break;
			var _diff = AppliedEssence[recipe_keys[x]] - Assets.CraftingRecipes[potential_items[i]][recipe_keys[x]];
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
	get_node("/root/AudioSystem").play_sound_effect(AudioSystem.SoundEffectCatalog.PLING, 1.3, 1.5);
	

	var _recipe_keys = Assets.CraftingRecipes[potential_items[lowest]].keys();
	for i in range(len(_recipe_keys)):
		AppliedEssence[_recipe_keys[i]] -= Assets.CraftingRecipes[potential_items[lowest]][_recipe_keys[i]];
		if AppliedEssence[_recipe_keys[i]] <= 0:
			AppliedEssence.erase(_recipe_keys[i]);
	
	
	if AppliedEssence != {}:
		CraftingFailedCount += 1;
		if CraftingFailedCount >= 3:
			CraftingFailedCount = 0;
			AppliedEssence = {}
			IsCrafting = false;
			$Smoke.visible = false;
			get_node("/root/AudioSystem").play_sound_effect(AudioSystem.SoundEffectCatalog.PWOSH);
			return;
		begin_crafting();
		return;
	IsCrafting = false;
	$Smoke.visible = false;
	return;


func die() -> void:
	get_node("/root/Main").Entities[EntityID] = null;
	var timer = Timer.new();
	Dead = true;
	timer.wait_time = 1; 
	add_child(timer)
	timer.start();
	timer.timeout.connect(queue_free);
	return;
