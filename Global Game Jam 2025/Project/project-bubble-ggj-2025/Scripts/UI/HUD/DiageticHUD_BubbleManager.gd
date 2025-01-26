class_name DiageticHUD_BubbleManager
extends Node2D

const PREFAB_DIAGETIC_HUD_BUBBLE_JUMP_INDICATOR = preload("res://Objects/HUD/Prefab_DiageticHUD_BubbleJumpIndicator.tscn")

@onready var Player: bubble_character = $".."

var BubbleIndicator_1:DiageticHUD_BubbleIndicator
var BubbleIndicator_2:DiageticHUD_BubbleIndicator
var BubbleIndicator_3:DiageticHUD_BubbleIndicator

const BubbleOffset:int = 125
const BubbleSeperation:int = 75

var isLookingRight:bool = false:
	set(newValue):
		isLookingRight = newValue
		
		var BubbleDirection
		if isLookingRight:
			BubbleDirection = 1
		else:
			BubbleDirection = -1
		
		BubbleIndicator_1.PositionMoveTowards = Vector2(BubbleDirection * (BubbleOffset + abs(Player.velocity.x/4)),BubbleIndicator_1.PositionMoveTowards.y)
		BubbleIndicator_2.PositionMoveTowards = Vector2(BubbleDirection * (BubbleOffset + BubbleSeperation + abs(Player.velocity.x/3.5)),BubbleIndicator_2.PositionMoveTowards.y)
		BubbleIndicator_3.PositionMoveTowards = Vector2(BubbleDirection * (BubbleOffset + (BubbleSeperation*2) + abs(Player.velocity.x/3)),BubbleIndicator_3.PositionMoveTowards.y)


var currentJumps = 3:
	set(newValue):
		match newValue:
			0:
				BubbleIndicator_1.isUsed = true
				BubbleIndicator_2.isUsed = true
				BubbleIndicator_3.isUsed = true
			1:
				BubbleIndicator_1.isUsed = false
				BubbleIndicator_2.isUsed = true
				BubbleIndicator_3.isUsed = true
			2:
				BubbleIndicator_1.isUsed = false
				BubbleIndicator_2.isUsed = false
				BubbleIndicator_3.isUsed = true
			3:
				BubbleIndicator_1.isUsed = false
				BubbleIndicator_2.isUsed = false
				BubbleIndicator_3.isUsed = false

func _ready() -> void:
	BubbleIndicator_1 = PREFAB_DIAGETIC_HUD_BUBBLE_JUMP_INDICATOR.instantiate()
	add_child(BubbleIndicator_1)
	BubbleIndicator_1.PositionMoveTowards = Vector2(-125,0)
	
	BubbleIndicator_2 = PREFAB_DIAGETIC_HUD_BUBBLE_JUMP_INDICATOR.instantiate()
	add_child(BubbleIndicator_2)
	BubbleIndicator_2.PositionMoveTowards = Vector2(-200,0)
	
	BubbleIndicator_3 = PREFAB_DIAGETIC_HUD_BUBBLE_JUMP_INDICATOR.instantiate()
	add_child(BubbleIndicator_3)
	BubbleIndicator_3.PositionMoveTowards = Vector2(-275,0)
	
	Player.player_jumped.connect(UpdateJumpIndicator)
	Player.jump_restored.connect(UpdateJumpIndicator)

func _physics_process(_delta: float) -> void:
	updateBubbleIndicatorPositions()

func updateBubbleIndicatorPositions() -> void:
	if Player.velocity.x < 0:
		isLookingRight = true
	elif Player.velocity.x > 0:
		isLookingRight = false
	
	BubbleIndicator_1.PositionMoveTowards.y = -Player.velocity.y/10
	BubbleIndicator_2.PositionMoveTowards.y = -Player.velocity.y/8
	BubbleIndicator_3.PositionMoveTowards.y = -Player.velocity.y/6
	
func UpdateJumpIndicator(newValue:int) -> void:
	currentJumps = newValue
