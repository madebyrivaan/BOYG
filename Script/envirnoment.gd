extends Node2D


@onready var exit_marker: Marker2D = $ExitMarker
var player;
var delete_distance = 1000;

func _process(_delta: float) -> void:
	if not player:
		return

	var difference = exit_marker.global_position.y - player.global_position.y

	if difference > delete_distance:
		print("DELETING ", name, " | Difference: ", difference)
		queue_free()
