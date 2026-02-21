extends Node2D

## 遊戲主控腳本 (Game Manager)
## 負責統計金錢、顯示 UI 等全域邏輯

var total_money: int = 0
@onready var employee = $Employee # 暫時只有一個員工

# --- UI 引用 ---
@onready var money_label: Label = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/MoneyLabel
@onready var ticket_label: Label = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/TicketLabel

func _ready() -> void:
	# 初始化 UI
	update_ui()
	
	# 連接員工的賺錢信號
	if employee:
		employee.money_earned.connect(_on_money_earned)
		employee.ticket_completed.connect(_on_ticket_completed)

func _on_money_earned(amount: int) -> void:
	total_money += amount
	print("💰 公司入帳: $", amount, " | 總資產: $", total_money)
	update_ui()

func _on_ticket_completed(title: String) -> void:
	print("✅ 案件結案: ", title)
	if ticket_label:
		ticket_label.text = "最新結案: " + title

func update_ui() -> void:
	if money_label:
		money_label.text = "公司資產: $" + str(total_money)
