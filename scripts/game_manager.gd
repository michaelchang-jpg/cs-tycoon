extends Node2D

@onready var employee: Employee = $World/Entities/Employee
@onready var desk: Desk = $World/Entities/Desk
@onready var water_cooler: WaterCooler = $World/Entities/WaterCooler

@onready var money_label: Label = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/MoneyLabel
@onready var ticket_label: Label = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/TicketLabel
@onready var stress_label: Label = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/StressLabel
@onready var action_label: Label = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/ActionLabel

var total_money: int = 0
var action_cooldown: float = 0.0

func _ready() -> void:
	randomize()
	employee.setup_points(desk.get_chair_global_position(), water_cooler.get_stand_global_position())
	employee.stress_changed.connect(_on_stress_changed)
	employee.state_changed.connect(_on_state_changed)
	_update_money(0)
	_on_stress_changed(employee.stress)
	_on_state_changed("待命")

func _process(delta: float) -> void:
	if employee.current_state == Employee.State.IDLE:
		action_cooldown += delta
		if action_cooldown >= 0.5:
			employee.pick_next_action()
			action_cooldown = 0.0
	else:
		action_cooldown = 0.0

	if employee.current_state == Employee.State.WORKING:
		_update_money(delta * 12)

func _update_money(add_amount: float) -> void:
	total_money += int(add_amount)
	money_label.text = "公司資產: $%d" % total_money
	ticket_label.text = "今日產能: +$12 / 秒（工作中）"

func _on_stress_changed(value: float) -> void:
	stress_label.text = "壓力值: %d / 100" % int(value)

func _on_state_changed(text: String) -> void:
	action_label.text = "目前行為: %s" % text
