extends CanvasLayer

func _ready() -> void:
	GameManager.GameOver.connect(func(): visible = true)

func _on_button_pressed() -> void:
	visible = false
	get_tree().reload_current_scene()
