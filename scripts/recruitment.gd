class_name RecruitmentPolicy
extends Resource

@export var employee_capacity: int = 4
@export var base_hire_cost: int = 300
@export var hire_cost_step: int = 150

func get_next_hire_cost(active_employee_count: int) -> int:
	var index := max(active_employee_count - 1, 0)
	return base_hire_cost + (index * hire_cost_step)

func can_hire(active_employee_count: int) -> bool:
	return active_employee_count < employee_capacity
