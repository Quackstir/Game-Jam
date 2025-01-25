class_name DiageticHUD_BubbleManager
extends Node2D

const PREFAB_DIAGETIC_HUD_BUBBLE_JUMP_INDICATOR = preload("res://Objects/HUD/Prefab_DiageticHUD_BubbleJumpIndicator.tscn")

@export var Player:CharacterBody2D

var BubbleIndicator_1:DiageticHUD_BubbleIndicator
var BubbleIndicator_2:DiageticHUD_BubbleIndicator
var BubbleIndicator_3:DiageticHUD_BubbleIndicator

func _ready() -> void:
	BubbleIndicator_1 = PREFAB_DIAGETIC_HUD_BUBBLE_JUMP_INDICATOR.instantiate()
	Player.add_child(BubbleIndicator_1)
	BubbleIndicator_1.PositionMoveTowards = Vector2(-125,0)
	
	BubbleIndicator_2 = PREFAB_DIAGETIC_HUD_BUBBLE_JUMP_INDICATOR.instantiate()
	Player.add_child(BubbleIndicator_2)
	BubbleIndicator_2.PositionMoveTowards = Vector2(-200,0)
	
	BubbleIndicator_3 = PREFAB_DIAGETIC_HUD_BUBBLE_JUMP_INDICATOR.instantiate()
	Player.add_child(BubbleIndicator_3)
	BubbleIndicator_3.PositionMoveTowards = Vector2(-275,0)
