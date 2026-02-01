class_name LootMcguffin
extends Loot

@onready var big_loot_sfx: AudioStreamPlayer = $BigLootSfx

func _ready() -> void:
	can_interact = true

func on_interact(player:PlayerController) -> void:
	super(player)
	Global.game_manager.can_win = true
	big_loot_sfx.play()
