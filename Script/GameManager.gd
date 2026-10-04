extends Node

signal GameOver

@export var ramp_duration: float = 90.0

var game_time: float = 0.0
var is_game_over: bool = false

func _ready() -> void:
	GameOver.connect(func(): is_game_over = true)

func _process(delta: float) -> void:
	if not is_game_over:
		game_time += delta

func reset() -> void:
	game_time = 0.0
	is_game_over = false

func get_difficulty() -> float:
	if ramp_duration <= 0.0:
		return 1.0
	return clampf(game_time / ramp_duration, 0.0, 1.0)
