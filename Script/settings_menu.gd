extends Control

signal closed

@onready var volume_slider: HSlider = %VolumeSlider
@onready var mute_checkbox: CheckBox = %MuteCheckBox

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var master_bus := AudioServer.get_bus_index("Master")
	if master_bus >= 0:
		var vol_db := AudioServer.get_bus_volume_db(master_bus)
		var is_muted := AudioServer.is_bus_mute(master_bus)
		if volume_slider:
			volume_slider.value = db_to_linear(vol_db) * 100.0
		if mute_checkbox:
			mute_checkbox.button_pressed = is_muted

func _on_volume_slider_value_changed(value: float) -> void:
	var master_bus := AudioServer.get_bus_index("Master")
	if master_bus >= 0:
		var linear_val := clampf(value / 100.0, 0.0, 1.0)
		AudioServer.set_bus_volume_db(master_bus, linear_to_db(linear_val))

func _on_mute_check_box_toggled(toggled_on: bool) -> void:
	var master_bus := AudioServer.get_bus_index("Master")
	if master_bus >= 0:
		AudioServer.set_bus_mute(master_bus, toggled_on)

func _on_back_button_pressed() -> void:
	closed.emit()
	if get_parent() == get_tree().root:
		get_tree().change_scene_to_file("res://Scene/ui/main_menu.tscn")
	else:
		visible = false
