extends CharacterBody2D

@export var min_forward_speed := 500.0
@export var max_forward_speed := 1050.0
@export var forward_speed := 500.0
@export var side_speed := 425.0
@onready var sprite: Sprite2D = $CarSkin

enum RoadType {
	STRAIGHT,
	LEFT,
	RIGHT
}

var CurrentCarHead: RoadType = RoadType.STRAIGHT
var is_player_input_blocked : bool = false

func _ready() -> void:
	GameManager.reset()
	GameManager.GameOver.connect(func(): is_player_input_blocked = true)
	sprite.region_enabled = true
	change_car_head(CurrentCarHead)

func _physics_process(_delta: float) -> void:
	if not is_player_input_blocked:
		var diff := GameManager.get_difficulty()
		forward_speed = lerpf(min_forward_speed, max_forward_speed, diff)
		side_speed = forward_speed * 0.85

	if is_player_input_blocked:
		velocity.y = -forward_speed
		move_and_slide()
		return
	
	velocity.y = -forward_speed
	
	var direction := Input.get_axis("left", "right")
	velocity.x = direction * side_speed

	if direction < 0:
		change_car_head(RoadType.LEFT)
	elif direction > 0:
		change_car_head(RoadType.RIGHT)
	else:
		change_car_head(RoadType.STRAIGHT)

	move_and_slide()

func change_car_head(type: RoadType) -> void:
	if CurrentCarHead == type:
		return

	CurrentCarHead = type

	match type:
		RoadType.STRAIGHT:
			sprite.region_rect = Rect2(19.095, 90.718, 300.491, 572.364)
			sprite.scale = Vector2(0.5,0.5)

		RoadType.LEFT:
			sprite.region_rect = Rect2(20.676, 859.219, 139.949, 197.428)
			sprite.scale = Vector2(1.7,1.7)
			
		RoadType.RIGHT:
			sprite.region_rect = Rect2(570.719, 866.395, 149.945, 182.433)
			sprite.scale = Vector2(1.7,1.7)
