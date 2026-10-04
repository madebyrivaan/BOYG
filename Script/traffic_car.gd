extends Node2D

@export var forward_speed := 400.0

@export var static_body : StaticBody2D
@export var area2d : Area2D

func _process(delta: float) -> void:
	global_position.y += forward_speed * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GameManager.GameOver.emit()
		change_collison_layer(false)

func change_collison_layer(_collison : bool) -> void:
	static_body.set_collision_layer_value(1,_collison)
	static_body.set_collision_mask_value(1,_collison)
	
	area2d.set_collision_layer_value(1,_collison)
	area2d.set_collision_mask_value(1,_collison)
