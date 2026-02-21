extends CharacterBody2D

## 客服員工基礎 AI 腳本 (Godot 4.6 強型別規範)
## 包含基礎狀態機、屬性系統與自主行動邏輯

# --- 列舉與常量 ---
enum State { IDLE, ROAMING, WORKING, RESTING }

# --- 導出變數 (可在編輯器調整) ---
@export_group("基礎屬性")
@export var employee_name: String = "菜鳥客服"
@export var speed: float = 120.0
@export var typing_speed: float = 1.0
@export var max_stress: float = 100.0

@export_group("AI 行為設定")
@export var roam_radius: float = 300.0
@export var idle_duration: Vector2 = Vector2(1.0, 3.0) # 隨機休息時間範圍

# --- 運行時變數 ---
var current_state: State = State.IDLE
var target_position: Vector2 = Vector2.ZERO
var stress: float = 0.0
var fatigue: float = 0.0

# --- 組件引用 ---
@onready var sprite: Node2D = $Sprite
@onready var state_timer: Timer = Timer.new()

func _ready() -> void:
	# 初始化計時器
	add_child(state_timer)
	state_timer.one_shot = true
	state_timer.timeout.connect(_on_timer_timeout)
	
	# 初始狀態設定
	_enter_state(State.IDLE)

func _physics_process(delta: float) -> void:
	match current_state:
		State.ROAMING:
			_handle_roaming(delta)
		State.WORKING:
			_handle_working(delta)

# --- 狀態切換邏輯 ---
func _enter_state(new_state: State) -> void:
	current_state = new_state
	
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO
			state_timer.start(randf_range(idle_duration.x, idle_duration.y))
		
		State.ROAMING:
			# 在當前位置周圍選一個隨機點
			target_position = global_position + Vector2(
				randf_range(-roam_radius, roam_radius),
				randf_range(-roam_radius, roam_radius)
			)
			# 確保目標在視窗內 (此處可根據辦公室邊界微調)
		
		State.WORKING:
			# 未來實作：走到桌子旁邊並坐下
			pass

# --- 核心行為處理 ---
func _handle_roaming(_delta: float) -> void:
	if global_position.distance_to(target_position) > 10.0:
		var direction: Vector2 = (target_position - global_position).normalized()
		velocity = direction * speed
		
		# 視覺處理：轉向
		if direction.x != 0:
			if sprite is Sprite2D:
				sprite.flip_h = direction.x < 0
			# 如果是 ColorRect 或其他 Node2D，可以用 scale.x 翻轉
			elif sprite is Node2D:
				sprite.scale.x = -1 if direction.x < 0 else 1
			
		move_and_slide()
	else:
		_enter_state(State.IDLE)

func _handle_working(delta: float) -> void:
	# 工作時壓力上升
	stress += 1.0 * delta
	if stress >= max_stress:
		_enter_state(State.RESTING)

# --- 信號處理 ---
func _on_timer_timeout() -> void:
	if current_state == State.IDLE:
		_enter_state(State.ROAMING)

# --- 公有方法 (供管理系統呼叫) ---
func assign_to_desk(desk_pos: Vector2) -> void:
	target_position = desk_pos
	_enter_state(State.ROAMING)
	# 到達後觸發工作狀態的邏輯可在此擴充
