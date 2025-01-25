class_name DiageticHUD_BubbleIndicator
extends Node2D

@onready var PositionMoveTowards:Vector2 = Vector2(0,0)

func _physics_process(delta: float) -> void:
	position = lerp(position, PositionMoveTowards, get_process_delta_time() * 10)
