extends CharacterBody2D

class_name Employee

enum State { IDLE, WALKING_TO_DESK, WORKING, WALKING_TO_COOLER, DRINKING }

@export var speed: float = 180.0
@export var arrive_distance: float = 8.0
@export var walkable_bounds: Rect2 = Rect2(140, 140, 860, 380)
@export var stress_increase_per_sec: float = 10.0
@export var stress_reduce_per_sec: float = 18.0
@export var stress_to_drink_threshold: float = 65.0
@export var work_duration_min: float = 3.0
@export var work_duration_max: float = 5.0
@export var drink_duration_min: float = 2.0
@export var drink_duration_max: float = 4.0

var current_state: State = State.IDLE
var target_position: Vector2 = Vector2.ZERO
var desk_position: Vector2 = Vector2.ZERO
var cooler_position: Vector2 = Vector2.ZERO
var stress: float = 20.0

signal stress_changed(value: float)
signal state_changed(text: String)

@onready var sprite: Sprite2D = $Sprite
@onready var state_timer: Timer = Timer.new()

func _ready() -> void:
	add_child(state_timer)
	state_timer.one_shot = true
	state_timer.timeout.connect(_on_state_timer_timeout)
	_enter_state(State.IDLE)

func setup_points(desk_pos: Vector2, cooler_pos: Vector2) -> void:
	desk_position = desk_pos
	cooler_position = cooler_pos

func _physics_process(delta: float) -> void:
	match current_state:
		State.WALKING_TO_DESK, State.WALKING_TO_COOLER:
			_handle_movement()
		State.WORKING:
			_set_stress(stress + stress_increase_per_sec * delta)
		State.DRINKING:
			_set_stress(stress - stress_reduce_per_sec * delta)

func pick_next_action() -> void:
	if current_state != State.IDLE:
		return

	if stress >= stress_to_drink_threshold:
		_enter_state(State.WALKING_TO_COOLER)
	else:
		_enter_state(State.WALKING_TO_DESK)

func _enter_state(new_state: State) -> void:
	current_state = new_state

	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO
			state_changed.emit("待命")
			sprite.modulate = Color(0.9, 0.9, 1.0)
		State.WALKING_TO_DESK:
			target_position = desk_position
			state_changed.emit("前往辦公桌")
			sprite.modulate = Color(0.7, 0.9, 1.0)
		State.WORKING:
			velocity = Vector2.ZERO
			state_changed.emit("工作中")
			sprite.modulate = Color(1.0, 0.65, 0.65)
			state_timer.start(randf_range(work_duration_min, work_duration_max))
		State.WALKING_TO_COOLER:
			target_position = cooler_position
			state_changed.emit("前往飲水機")
			sprite.modulate = Color(0.7, 1.0, 0.8)
		State.DRINKING:
			velocity = Vector2.ZERO
			state_changed.emit("喝水中")
			sprite.modulate = Color(0.6, 1.0, 0.6)
			state_timer.start(randf_range(drink_duration_min, drink_duration_max))

func _handle_movement() -> void:
	var direction := target_position - global_position
	if direction.length() > arrive_distance:
		velocity = direction.normalized() * speed
		move_and_slide()
		global_position = _clamp_to_bounds(global_position)
	else:
		velocity = Vector2.ZERO
		global_position = _clamp_to_bounds(target_position)
		if current_state == State.WALKING_TO_DESK:
			_enter_state(State.WORKING)
		elif current_state == State.WALKING_TO_COOLER:
			_enter_state(State.DRINKING)

func _on_state_timer_timeout() -> void:
	_enter_state(State.IDLE)

func _set_stress(value: float) -> void:
	var next_value := clamp(value, 0.0, 100.0)
	if is_equal_approx(next_value, stress):
		return
	stress = next_value
	stress_changed.emit(stress)

func _clamp_to_bounds(pos: Vector2) -> Vector2:
	return Vector2(
		clamp(pos.x, walkable_bounds.position.x, walkable_bounds.end.x),
		clamp(pos.y, walkable_bounds.position.y, walkable_bounds.end.y)
	)
