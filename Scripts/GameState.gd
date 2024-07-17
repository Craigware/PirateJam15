extends Node
class_name GameState

enum GameStates {
	IDLE = 0,
	CRAFTING = 1,
	BATTLE = 2,
	FAIL = 3
}

const ENTITY_LIMIT = 1024;

var State : GameStates;
var Entities : Array;
var Player : Entity;

func _ready() -> void:
	Entities.resize(ENTITY_LIMIT);
	Entities.fill(null);
	Entities[0] = Player;
	State = GameStates.IDLE;
	return



func add_entity() -> Entity:
	for i in range(ENTITY_LIMIT):
		if Entities[i] == null:
			Entities[i] = Entity.new();
			Entities[i].EntityID = i;
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

func player_failed() -> void:
	return;
