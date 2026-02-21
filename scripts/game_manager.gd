extends Node2D

## 遊戲主控腳本 (Game Manager v2.1)
## 修正：正確的 UI 節點路徑與資產更新邏輯

var total_money: int = 0
@onready var employee: Employee = $World/Entities/Employee 

# --- UI 引用 (路徑與 main.tscn 保持一致) ---
@onready var money_label: Label = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/MoneyLabel
@onready var ticket_label: Label = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/TicketLabel

# --- 派單計時器 ---
var spawn_timer: float = 0.0

func _ready() -> void:
	print("🚀 GameManager 啟動！")
	
	# 初始化 UI 顯示
	_update_ui()
	
	if employee:
		# 連接員工信號
		employee.money_earned.connect(_on_money_earned)
		employee.ticket_completed.connect(_on_ticket_completed)
		print("✅ 已成功連接員工信號")

func _process(delta: float) -> void:
	# 自動派單邏輯
	if employee and employee.current_state == Employee.State.IDLE:
		spawn_timer += delta
		if spawn_timer > 1.5: # 每 1.5 秒檢查一次
			var new_ticket = Ticket.generate_random()
			employee.assign_job(new_ticket)
			spawn_timer = 0.0

func _on_money_earned(amount: int) -> void:
	total_money += amount
	print("💰 入帳: +$", amount, " | 當前總額: ", total_money)
	_update_ui()

func _on_ticket_completed(title: String) -> void:
	if ticket_label:
		ticket_label.text = "最新結案: " + title

func _update_ui() -> void:
	if money_label:
		money_label.text = "公司資產: $" + str(total_money)
	else:
		print("⚠️ 找不到 MoneyLabel 節點，請檢查路徑！")
