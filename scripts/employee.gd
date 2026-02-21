extends CharacterBody2D

## 客服員工 AI 腳本 (v2.1)
## 包含：取票邏輯 (Fetch Ticket) 與正確的座標設定

class_name Employee

# --- 列舉與常量 ---
enum State { IDLE, FETCHING_TICKET, WALKING_TO_DESK, WORKING }

# --- 導出變數 ---
@export var speed: float = 200.0
@export var inbox_pos: Vector2 = Vector2(100, 300) # 收件匣位置
@export var desk_pos: Vector2 = Vector2(300, 300)  # 辦公桌位置 (與 main.tscn 一致)

# --- 運行時變數 ---
var current_state: State = State.IDLE
var target_position: Vector2 = Vector2.ZERO
var current_ticket: Ticket = null 

# --- 信號定義 ---
signal money_earned(amount: int)
signal ticket_completed(title: String)

# --- 組件引用 ---
@onready var sprite = $Sprite
@onready var work_timer: Timer = Timer.new()

func _ready() -> void:
	add_child(work_timer)
	work_timer.one_shot = true
	work_timer.timeout.connect(_on_work_completed)
	
	_enter_state(State.IDLE)

func _physics_process(_delta: float) -> void:
	match current_state:
		State.FETCHING_TICKET, State.WALKING_TO_DESK:
			_handle_movement()
		State.WORKING:
			pass 

# --- 外部呼叫 ---
func assign_job(ticket: Ticket) -> void:
	if current_state != State.IDLE:
		return
	
	current_ticket = ticket
	print(name, ": 收到工單 [", ticket.title, "]，前往取票...")
	_enter_state(State.FETCHING_TICKET)

# --- 狀態機邏輯 ---
func _enter_state(new_state: State) -> void:
	current_state = new_state
	
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO
			_set_color(Color(0.2, 0.6, 1)) # 藍色 (閒置)
			
		State.FETCHING_TICKET:
			target_position = inbox_pos
			_set_color(Color(1, 1, 0)) # 黃色 (取票中)
			
		State.WALKING_TO_DESK:
			target_position = desk_pos
			_set_color(Color(0, 1, 1)) # 青色 (回座位)
			
		State.WORKING:
			velocity = Vector2.ZERO
			_set_color(Color(1, 0.4, 0.4)) # 紅色 (工作中)
			# 根據工單難度設定時間
			var work_time = 2.0
			if current_ticket:
				work_time = current_ticket.difficulty * 2.0
			work_timer.start(work_time)

func _handle_movement() -> void:
	if global_position.distance_to(target_position) > 10.0:
		velocity = (target_position - global_position).normalized() * speed
		move_and_slide()
	else:
		# 到達目的地
		match current_state:
			State.FETCHING_TICKET:
				_enter_state(State.WALKING_TO_DESK)
			State.WALKING_TO_DESK:
				# 修正位置
				global_position = target_position
				_enter_state(State.WORKING)

func _on_work_completed() -> void:
	if current_ticket:
		money_earned.emit(current_ticket.reward)
		ticket_completed.emit(current_ticket.title)
		current_ticket = null
	
	_enter_state(State.IDLE)

# --- 視覺輔助 ---
func _set_color(color: Color) -> void:
	if sprite:
		if sprite is ColorRect:
			sprite.color = color
		elif sprite is Sprite2D or sprite is CanvasItem:
			sprite.modulate = color
