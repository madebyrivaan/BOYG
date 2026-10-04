extends Node2D

@export var environment : PackedScene
@export var player : CharacterBody2D
@export var OldRoad : Node2D

@export var traffic_spawner : Node2D; 

var NewRoad : Node2D

func _ready() -> void:
	_road_spawner(4)

func _process(_delta: float) -> void:
	if player and OldRoad:
		if player.global_position.y < OldRoad.global_position.y + 3000:
			_road_spawner(4)

func _road_spawner(road_num : int) -> void:
	
	for intS in road_num:
		NewRoad = environment.instantiate();
		NewRoad.player = player;
		add_child(NewRoad);
		if OldRoad:
			connect_road(OldRoad,NewRoad)
		else:
			print("Old Road is not defined!")
		if traffic_spawner.has_method("spawn_traffic"):
			traffic_spawner.spawn_traffic(NewRoad)
		OldRoad = NewRoad;
		NewRoad = null;

func connect_road(previous_road: Node2D, new_road: Node2D) -> void:
	var exit_marker: Marker2D = previous_road.get_node("ExitMarker")
	var entry_marker: Marker2D = new_road.get_node("EntryMarker")

	new_road.global_transform = (
		exit_marker.global_transform
		* entry_marker.transform.affine_inverse()
	)
