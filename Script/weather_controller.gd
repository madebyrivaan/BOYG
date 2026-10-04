extends Node2D

@export var weather_types: Array[String] = ["rain", "snow", "fog"]
@export var switch_interval: float = 20.0
@export var transition_duration: float = 1.5

@onready var weather_fx: WeatherFX = $WeatherFX

var current_index: int = 0
var timer: Timer

func _ready() -> void:
	if not weather_fx:
		push_error("WeatherController: WeatherFX child node not found!")
		return

	if weather_types.is_empty():
		weather_types = Array(WeatherFX.effects())

	# Initialize first weather randomly
	current_index = randi() % weather_types.size()
	weather_fx.effect = weather_types[current_index]
	weather_fx.set_param(&"intensity", 1.0)
	weather_fx.fade_in(transition_duration)

	# Setup repeating 20-second timer
	timer = Timer.new()
	timer.wait_time = switch_interval
	timer.one_shot = false
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_timer_timeout() -> void:
	if weather_types.is_empty() or not is_instance_valid(weather_fx):
		return

	current_index = (current_index + 1) % weather_types.size()
	_transition_to_weather(weather_types[current_index])

func _transition_to_weather(next_weather: String) -> void:
	# Smoothly fade out current weather, switch effect, and fade in next weather
	var tween := create_tween()
	tween.tween_method(func(val: float) -> void:
		if is_instance_valid(weather_fx):
			weather_fx.set_param(&"intensity", val)
	, 1.0, 0.0, transition_duration)

	tween.tween_callback(func() -> void:
		if is_instance_valid(weather_fx):
			weather_fx.effect = next_weather
			weather_fx.set_param(&"intensity", 1.0)
			weather_fx.fade_in(transition_duration)
	)
