class_name Interactable
extends Area2D

var can_interact : bool = true

func on_interact(_player:PlayerController) -> void:
	print("I'm being interacted with")

func activate() -> void:
	pass
