extends CanvasLayer

@onready var score_label: Label = %FinalScoreLabel
@onready var high_score_label: Label = %BestScoreLabel

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	GameManager.GameOver.connect(_on_game_over)

func _on_game_over() -> void:
	if score_label:
		score_label.text = "SCORE: %d m" % GameManager.score
	if high_score_label:
		high_score_label.text = "BEST: %d m" % GameManager.high_score
	visible = true

func _on_restart_button_pressed() -> void:
	visible = false
	GameManager.reset()
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed() -> void:
	visible = false
	GameManager.reset()
	get_tree().change_scene_to_file("res://Scene/ui/main_menu.tscn")
