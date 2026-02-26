extends CanvasLayer

@export var enabled: bool = true
@export var target_path: NodePath

@onready var panel: PanelContainer = $PanelContainer
@onready var state_label: Label = $PanelContainer/MarginContainer/VBoxContainer/StateLabel
@onready var pos_label: Label = $PanelContainer/MarginContainer/VBoxContainer/PosLabel
@onready var target_label: Label = $PanelContainer/MarginContainer/VBoxContainer/TargetLabel
@onready var stress_rate_label: Label = $PanelContainer/MarginContainer/VBoxContainer/StressRateLabel

var target: Employee

func _ready() -> void:
	if target_path != NodePath():
		target = get_node_or_null(target_path)
	_apply_enabled()

func _process(_delta: float) -> void:
	if not enabled:
		return
	if target == null:
		target = get_node_or_null(target_path)
		if target == null:
			return

	state_label.text = "State: %s" % _state_to_text(target.current_state)
	pos_label.text = "Pos: (%.1f, %.1f)" % [target.global_position.x, target.global_position.y]
	target_label.text = "Target: (%.1f, %.1f)" % [target.target_position.x, target.target_position.y]

	var rate := 0.0
	if target.current_state == Employee.State.WORKING:
		rate = target.stress_increase_per_sec
	elif target.current_state == Employee.State.DRINKING:
		rate = -target.stress_reduce_per_sec
	stress_rate_label.text = "Stress Δ/s: %.1f" % rate

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_debug_toggle"):
		enabled = not enabled
		_apply_enabled()

func _apply_enabled() -> void:
	if panel:
		panel.visible = enabled

func _state_to_text(s: int) -> String:
	match s:
		Employee.State.IDLE:
			return "IDLE"
		Employee.State.WALKING_TO_DESK:
			return "WALKING_TO_DESK"
		Employee.State.WORKING:
			return "WORKING"
		Employee.State.WALKING_TO_COOLER:
			return "WALKING_TO_COOLER"
		Employee.State.DRINKING:
			return "DRINKING"
		_:
			return "UNKNOWN"
