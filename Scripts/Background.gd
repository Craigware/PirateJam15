extends Node;
class_name Background;

enum SceneTypes {
	NIL,
	CITY,
	MOUNTAINS,
	FOREST,
	VILLAGE
}


#Array contains scenes, scenes contain scene layers, layers contain nodes
static var Scenes : Array = [
	[
		[]
	],
	[]
];

func destroy_background():
	#background will have, animation will place where they fall past the board
	pass

func build_background():
	#Background pops up out of the floor 
	pass