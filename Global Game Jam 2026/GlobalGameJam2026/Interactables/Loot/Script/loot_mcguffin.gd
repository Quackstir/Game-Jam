class_name LootMcguffin
extends Loot

func _ready() -> void:
	can_interact = true

func on_interact(player:PlayerController) -> void:
	super(player)
	Global.game_manager.can_win = true
