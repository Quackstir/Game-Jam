class_name Loot
extends Interactable

func _ready() -> void:
	can_interact = false

func on_interact(player:PlayerController) -> void:
	super(player)
	reparent(player)
	position = Vector2.ZERO
	monitorable = false
	
func activate() -> void:
	Global.game_manager.score += 10
	queue_free()
