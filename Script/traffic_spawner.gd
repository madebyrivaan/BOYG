extends Node2D

const trafficArray: Array[PackedScene] = [
	preload("uid://cxvknj8kspjx3"),
	preload("uid://d4g2pmuoxvsvp")
]

func spawn_traffic(current_road: Node2D) -> void:
	var marker_parent := current_road.get_node_or_null("TrafficMarker")

	if not marker_parent:
		push_error("TrafficMarker node not found under road!")
		return

	var traffic_markers := marker_parent.get_children()

	if traffic_markers.is_empty():
		return

	var spawn_point: Marker2D = traffic_markers.pick_random()
	var traffic_car_scene = trafficArray.pick_random().instantiate()

	current_road.add_child(traffic_car_scene)
	traffic_car_scene.position = spawn_point.position
