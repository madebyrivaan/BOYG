extends Node2D

const trafficArray: Array[PackedScene] = [
	preload("uid://cxvknj8kspjx3"),
	preload("uid://d4g2pmuoxvsvp"),
	preload("uid://bk1hhi0mocefu"),
	preload("uid://b1deueyqvn3dt"),
	preload("uid://ctyt6g48jo5t"),
	preload("uid://cjtsvv56547ix"),
	preload("uid://btxsce2ub8xut")
]

func spawn_traffic(current_road: Node2D) -> void:
	var marker_parent := current_road.get_node_or_null("TrafficMarker")

	if not marker_parent:
		push_error("TrafficMarker node not found under road!")
		return

	var traffic_markers := marker_parent.get_children()

	if traffic_markers.is_empty():
		return

	var diff := GameManager.get_difficulty()
	# Spawn chance starts lower (35%) so early game is not overcrowded, ramps to 90%
	var spawn_chance := lerpf(0.35, 0.90, diff)
	if randf() > spawn_chance:
		return

	var available_markers := traffic_markers.duplicate()
	var spawn_point: Marker2D = available_markers.pick_random()
	available_markers.erase(spawn_point)
	_create_car_at(current_road, spawn_point)

	# Higher difficulty adds a chance to spawn a second car in another lane
	if diff > 0.4 and not available_markers.is_empty():
		var second_car_chance := lerpf(0.0, 0.40, (diff - 0.4) / 0.6)
		if randf() < second_car_chance:
			var second_spawn: Marker2D = available_markers.pick_random()
			_create_car_at(current_road, second_spawn)

func _create_car_at(road: Node2D, marker: Marker2D) -> void:
	var traffic_car_scene = trafficArray.pick_random().instantiate()
	road.add_child(traffic_car_scene)
	traffic_car_scene.position = marker.position
