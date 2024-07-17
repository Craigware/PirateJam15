extends Node3D;

class_name Entity;

@export var Health: int;
@export var Sprite: Texture2D;
@export var IsAlly: bool;

var EntityID: int;
signal entity_death(entity_id: int);

func _ready() -> void:
    var material = StandardMaterial3D.new();
    material.albedo_texture = Sprite;
    material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED;
    $SpriteMesh.mesh.material = material;
    return;

func update_health(amount) -> void:
    Health += amount;
    if Health <= 0:
        entity_death.emit(EntityID);
    return;

func die() -> void:
    return;