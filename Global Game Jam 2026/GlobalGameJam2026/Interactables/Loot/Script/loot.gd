class_name Loot
extends Interactable

func on_interact(player:PlayerController) -> void:
	super(player)
	reparent(player)
	position = Vector2.ZERO
	monitorable = false
