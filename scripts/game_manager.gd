extends Node2D

@onready var entities: Node2D = $World/Entities
@onready var desk_a: Desk = $World/Entities/Desk
@onready var desk_b: Desk = $World/Entities/DeskB
@onready var water_cooler: WaterCooler = $World/Entities/WaterCooler

@onready var money_label: Label = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/MoneyLabel
@onready var ticket_label: Label = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/TicketLabel
@onready var stress_label: Label = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/StressLabel
@onready var action_label: Label = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/ActionLabel
@onready var recruit_label: Label = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/RecruitLabel
@onready var recruit_button: Button = $UI/Control/PanelContainer/MarginContainer/VBoxContainer/RecruitButton

@onready var job_generator: JobGenerator = JobGenerator.new()
var employee_stats: Dictionary = {}
var employees: Array[Employee] = []
var employee_pool: Array[Employee] = []
var action_cooldowns: Dictionary = {}
var recruit_policy: RecruitmentPolicy = RecruitmentPolicy.new()

var total_money: int = 0
var active_employee_count: int = 1

func _ready() -> void:
	randomize()
	add_child(job_generator)
	_collect_employees()
	_setup_employees()
	recruit_button.pressed.connect(_on_recruit_pressed)
	_update_money(0.0)
	_refresh_ui_summary()

func _process(delta: float) -> void:
	for employee in employees:
		_update_employee_loop(employee, delta)

	_refresh_ui_summary()

func _collect_employees() -> void:
	employee_pool.clear()
	for child in entities.get_children():
		if child is Employee:
			employee_pool.append(child)

	# 保持原場景節點順序，避免 sort_custom callable 在不同設定下造成初始化中斷
	if employee_pool.is_empty():
		active_employee_count = 0
	else:
		active_employee_count = int(clamp(active_employee_count, 1, employee_pool.size()))
	_rebuild_active_employees()

func _setup_employees() -> void:
	for i in employee_pool.size():
		var employee := employee_pool[i]
		var desk_pos := desk_a.get_chair_global_position()
		if i % 2 == 1:
			desk_pos = desk_b.get_chair_global_position()

		employee.setup_points(desk_pos, water_cooler.get_stand_global_position())
		if not employee.stress_changed.is_connected(_on_stress_changed.bind(employee)):
			employee.stress_changed.connect(_on_stress_changed.bind(employee))
		if not employee.state_changed.is_connected(_on_state_changed.bind(employee)):
			employee.state_changed.connect(_on_state_changed.bind(employee))
		employee_stats[employee] = EmployeeStats.new()
		employee_stats[employee].stress = employee.stress
		action_cooldowns[employee] = 0.0

	_rebuild_active_employees()

func _rebuild_active_employees() -> void:
	employees.clear()
	for i in employee_pool.size():
		var employee := employee_pool[i]
		var is_active := i < active_employee_count
		employee.visible = is_active
		employee.set_physics_process(is_active)
		employee.set_process(is_active)
		if is_active:
			employees.append(employee)

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
		recruit_label.text = "招募: 無"
		recruit_button.disabled = true
		recruit_button.text = "招募"
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
	recruit_label.text = _build_recruit_text()
	_refresh_recruit_button()

func _build_recruit_text() -> String:
	var active_count: int = employees.size()
	var capacity: int = int(min(recruit_policy.employee_capacity, employee_pool.size()))
	if active_count >= capacity:
		return "招募: 已滿編 (%d/%d)" % [active_count, capacity]

	var next_cost := recruit_policy.get_next_hire_cost(active_count)
	return "招募: 下位成本 $%d (%d/%d)" % [next_cost, active_count, capacity]

func _refresh_recruit_button() -> void:
	var active_count: int = employees.size()
	var capacity: int = int(min(recruit_policy.employee_capacity, employee_pool.size()))
	if active_count >= capacity:
		recruit_button.disabled = true
		recruit_button.text = "已滿編"
		return

	var next_cost := recruit_policy.get_next_hire_cost(active_count)
	recruit_button.disabled = total_money < next_cost
	recruit_button.text = "招募 ($%d)" % next_cost

func _on_recruit_pressed() -> void:
	var active_count: int = employees.size()
	var capacity: int = int(min(recruit_policy.employee_capacity, employee_pool.size()))
	if active_count >= capacity:
		action_label.text = "目前行為: 招募失敗（已滿編）"
		_refresh_recruit_button()
		return

	var next_cost := recruit_policy.get_next_hire_cost(active_count)
	if total_money < next_cost:
		action_label.text = "目前行為: 招募失敗（資金不足）"
		_refresh_recruit_button()
		return

	total_money -= next_cost
	active_employee_count += 1
	_rebuild_active_employees()
	_update_money(0.0)
	action_label.text = "目前行為: 招募成功！目前 %d/%d" % [employees.size(), capacity]
	_refresh_ui_summary()

func _on_stress_changed(value: float, employee: Employee) -> void:
	if employee_stats.has(employee):
		employee_stats[employee].stress = value

func _on_state_changed(_text: String, _employee: Employee) -> void:
	pass
