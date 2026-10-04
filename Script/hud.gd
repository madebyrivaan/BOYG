extends CanvasLayer

@onready var score_label: Label = %ScoreLabel
@onready var high_score_label: Label = %HighScoreLabel
@onready var speed_label: Label = %SpeedLabel
@onready var pause_panel: Control = %PausePanel
@onready var settings_menu: Control = %SettingsMenu

var player: CharacterBody2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_panel.visible = false
	if settings_menu:
		settings_menu.visible = false
	
	if not player:
		player = get_tree().get_first_node_in_group("Player")
	
	GameManager.score_changed.connect(_on_score_changed)
	_update_labels()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func _process(_delta: float) -> void:
	if player and is_instance_valid(player) and "forward_speed" in player:
		speed_label.text = "SPD: %d" % int(player.forward_speed / 10.0)

func _on_score_changed(_new_score: int) -> void:
	_update_labels()

func _update_labels() -> void:
	score_label.text = "%d m" % GameManager.score
	high_score_label.text = "BEST: %d m" % GameManager.high_score

func toggle_pause() -> void:
	if GameManager.is_game_over:
		return
	var will_pause := not get_tree().paused
	get_tree().paused = will_pause
	pause_panel.visible = will_pause
	if not will_pause and settings_menu:
		settings_menu.visible = false

func _on_pause_button_pressed() -> void:
	toggle_pause()

func _on_resume_button_pressed() -> void:
	toggle_pause()

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	GameManager.reset()
	get_tree().reload_current_scene()

func _on_settings_button_pressed() -> void:
	if settings_menu:
		settings_menu.visible = true

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	GameManager.reset()
	get_tree().change_scene_to_file("res://Scene/ui/main_menu.tscn")
