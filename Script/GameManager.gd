extends Node

signal GameOver
signal score_changed(new_score: int)

@export var ramp_duration: float = 90.0

var game_time: float = 0.0
var distance: float = 0.0
var score: int = 0
var high_score: int = 0
var is_game_over: bool = false

const SAVE_PATH := "user://savegame.cfg"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_high_score()
	GameOver.connect(_on_game_over)

func _process(delta: float) -> void:
	if not is_game_over and not get_tree().paused:
		game_time += delta

func add_distance(amount: float) -> void:
	if is_game_over or get_tree().paused:
		return
	distance += amount
	var new_score := int(distance / 10.0)
	if new_score != score:
		score = new_score
		score_changed.emit(score)
		if score > high_score:
			high_score = score

func _on_game_over() -> void:
	is_game_over = true
	if score > high_score:
		high_score = score
	save_high_score()

func reset() -> void:
	game_time = 0.0
	distance = 0.0
	score = 0
	is_game_over = false
	get_tree().paused = false

func get_difficulty() -> float:
	if ramp_duration <= 0.0:
		return 1.0
	return clampf(game_time / ramp_duration, 0.0, 1.0)

func load_high_score() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		high_score = config.get_value("game", "high_score", 0)

func save_high_score() -> void:
	var config := ConfigFile.new()
	config.set_value("game", "high_score", high_score)
	config.save(SAVE_PATH)
