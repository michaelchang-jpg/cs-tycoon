class_name Desk
extends Area2D

## 辦公桌物件腳本
## 管理座位狀態與提供員工互動點

# --- 信號 ---
signal employee_arrived(employee)

# --- 屬性 ---
@export var is_occupied: bool = false
@export var assigned_employee_name: String = ""

# --- 互動點 ---
# 用一個 Marker2D 來定義「椅子」的確切位置，讓員工知道要站/坐在哪
@onready var chair_position: Marker2D = $ChairPosition

func _ready() -> void:
	# 確保 body_entered 信號有連接 (如果員工走進區域)
	body_entered.connect(_on_body_entered)

func get_chair_global_position() -> Vector2:
	if chair_position:
		return chair_position.global_position
	return global_position

func assign_employee(emp_name: String) -> void:
	assigned_employee_name = emp_name
	is_occupied = true

func vacate() -> void:
	assigned_employee_name = ""
	is_occupied = false

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D: # 假設員工是 CharacterBody2D
		# 可以在這裡觸發一些互動，例如「員工坐下」的動畫
		emit_signal("employee_arrived", body)
