extends Control

@onready var best_score_label: Label = %BestScoreLabel
@onready var settings_menu: Control = %SettingsMenu

func _ready() -> void:
	if best_score_label:
		best_score_label.text = "BEST: %d m" % GameManager.high_score
	if settings_menu:
		settings_menu.visible = false

func _on_play_button_pressed() -> void:
	GameManager.reset()
	get_tree().change_scene_to_file("res://Scene/main_game.tscn")

func _on_settings_button_pressed() -> void:
	if settings_menu:
		settings_menu.visible = true

func _on_quit_button_pressed() -> void:
	get_tree().quit()
