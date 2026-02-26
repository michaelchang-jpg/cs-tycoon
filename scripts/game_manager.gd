extends Node2D

@onready var entities: Node2D = $World/Entities
@onready var desk_a: Desk = $World/Entities/Desk
@onready var desk_b: Desk = $World/Entities/DeskB
@onready var water_cooler: WaterCooler = $World/Entities/WaterCooler

@onready var money_label: Label = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/MoneyLabel
@onready var ticket_label: Label = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/TicketLabel
@onready var stress_label: Label = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/StressLabel
@onready var action_label: Label = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/ActionLabel

@onready var job_generator: JobGenerator = JobGenerator.new()
var employee_stats: Dictionary = {}
var employees: Array[Employee] = []
var action_cooldowns: Dictionary = {}

var total_money: int = 0

func _ready() -> void:
	randomize()
	add_child(job_generator)
	_collect_employees()
	_setup_employees()
	_update_money(0.0)
	_refresh_ui_summary()

func _process(delta: float) -> void:
	for employee in employees:
		_update_employee_loop(employee, delta)

	_refresh_ui_summary()

func _collect_employees() -> void:
	employees.clear()
	for child in entities.get_children():
		if child is Employee:
			employees.append(child)

func _setup_employees() -> void:
	for i in employees.size():
		var employee := employees[i]
		var desk_pos := desk_a.get_chair_global_position()
		if i % 2 == 1:
			desk_pos = desk_b.get_chair_global_position()

		employee.setup_points(desk_pos, water_cooler.get_stand_global_position())
		employee.stress_changed.connect(_on_stress_changed.bind(employee))
		employee.state_changed.connect(_on_state_changed.bind(employee))
		employee_stats[employee] = EmployeeStats.new()
		employee_stats[employee].stress = employee.stress
		action_cooldowns[employee] = 0.0

func _update_employee_loop(employee: Employee, delta: float) -> void:
	if employee.current_state == Employee.State.IDLE:
		action_cooldowns[employee] += delta
		if action_cooldowns[employee] >= 0.5:
			employee.pick_next_action()
			action_cooldowns[employee] = 0.0
	else:
		action_cooldowns[employee] = 0.0

	if employee.current_state == Employee.State.WORKING:
		var income := job_generator.get_income_per_second(employee.stress)
		_update_money(delta * income)

func _update_money(add_amount: float) -> void:
	total_money += int(add_amount)
	money_label.text = "公司資產: $%d" % total_money

func _refresh_ui_summary() -> void:
	if employees.is_empty():
		ticket_label.text = "今日產能: --"
		stress_label.text = "壓力值: --"
		action_label.text = "目前行為: 無員工"
		return

	var stress_sum := 0.0
	var working_count := 0
	var high_stress_count := 0

	for employee in employees:
		stress_sum += employee.stress
		if employee.current_state == Employee.State.WORKING:
			working_count += 1
		if employee.stress >= employee.stress_to_drink_threshold:
			high_stress_count += 1

	var avg_stress := stress_sum / float(employees.size())
	ticket_label.text = "%s | 工作中 %d/%d" % [job_generator.get_label(avg_stress), working_count, employees.size()]
	stress_label.text = "平均壓力: %d / 100 (高壓 %d)" % [int(avg_stress), high_stress_count]
	action_label.text = "目前行為: 多員工循環運作中"

func _on_stress_changed(value: float, employee: Employee) -> void:
	if employee_stats.has(employee):
		employee_stats[employee].stress = value

func _on_state_changed(_text: String, _employee: Employee) -> void:
	# 狀態細節由 DebugOverlay 觀察；主 UI 顯示整體摘要
	pass
