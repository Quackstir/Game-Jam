class_name HUD
extends Control

@export var player : PlayerController
@export var circle_outline : TextureRect
@export var button_press : TextureRect

@export var default_text : String
@export var mcguffin_text : String

var _mask_can_activate : bool

@onready var label: Label = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/Panel/MarginContainer/Label
@onready var rich_text_label: RichTextLabel = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer2/TextureRect/MarginContainer/RichTextLabel


func _ready() -> void:
	player.equip_mask.connect(_equip_mask)
	player.upequip_mask.connect(_unequip_mask)
	#Global.game_manager.win_state_change.connect(_can_win)
	#Global.game_manager.call_deferred("win_state_change.connect", _can_win)
	GM.win_state_change.connect(_can_win)
	GM.score_change.connect(_score_changed)

func _score_changed(_new_score:int) -> void:
	label.text = "Score: " + str(_new_score)

func _can_win(_can_win:bool) -> void:
	if _can_win:
		rich_text_label.text = mcguffin_text
	else:
		rich_text_label.text = default_text


func _equip_mask(_new_mask:Mask) -> void:
	if _new_mask != null:
		_new_mask.update_use.connect(_update_mask_icon)
		_mask_can_activate = _new_mask.can_activate
		_update_mask_icon(_new_mask.can_use)


func _unequip_mask(_new_mask:Mask) -> void:
	_new_mask.update_use.disconnect(_update_mask_icon)
	pass


func _update_mask_icon(can_use:bool) -> void:
	circle_outline.visible = can_use
	if _mask_can_activate:
		button_press.visible = can_use
	else:
		button_press.visible = false
