class_name JobGenerator
extends Node

func get_income_per_second(stress: float) -> float:
	if stress >= 85.0:
		return 8.0
	if stress >= 60.0:
		return 10.0
	return 12.0

func get_label(stress: float) -> String:
	if stress >= 85.0:
		return "高壓產能: +$8 / 秒"
	if stress >= 60.0:
		return "中壓產能: +$10 / 秒"
	return "穩定產能: +$12 / 秒"
