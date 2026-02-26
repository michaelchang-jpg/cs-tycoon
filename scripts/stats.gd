class_name EmployeeStats
extends Resource

@export var eq: float = 50.0
@export var knowledge: float = 50.0
@export var stress: float = 20.0

func clamp_all() -> void:
	eq = clamp(eq, 0.0, 100.0)
	knowledge = clamp(knowledge, 0.0, 100.0)
	stress = clamp(stress, 0.0, 100.0)

func apply_work_tick(delta: float, stress_rate: float) -> void:
	stress = clamp(stress + stress_rate * delta, 0.0, 100.0)

func apply_rest_tick(delta: float, recover_rate: float) -> void:
	stress = clamp(stress - recover_rate * delta, 0.0, 100.0)
