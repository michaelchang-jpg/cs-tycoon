class_name WaterCooler
extends Area2D

signal employee_arrived(employee)

@onready var stand_position: Marker2D = $StandPosition

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func get_stand_global_position() -> Vector2:
	if stand_position:
		return stand_position.global_position
	return global_position

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		employee_arrived.emit(body)
