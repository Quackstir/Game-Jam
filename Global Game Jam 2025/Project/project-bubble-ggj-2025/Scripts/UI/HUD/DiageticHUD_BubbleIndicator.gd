class_name DiageticHUD_BubbleIndicator
extends Node2D

@onready var PositionMoveTowards:Vector2 = Vector2(0,0)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var bubble_sprite: Sprite2D = $"Bubble Sprite"

var isUsed:bool:set = isUsedUpdate

@export var MovementSpeed:float = 10

@export var Popping_AnimationSpeed:float = 2
@export var Regenerating_AnimationTime:float = 0.3

@export var Regenerating_CurveAnimation:Curve
var bubble_scale:float = 0.0:
	set(newValue):
		scale.x = Regenerating_CurveAnimation.sample(newValue)
		scale.y = Regenerating_CurveAnimation.sample(newValue)

func _physics_process(delta: float) -> void:
	position = lerp(position, PositionMoveTowards, delta * MovementSpeed)
	
func isUsedUpdate(newValue:bool) -> void:
	if newValue:
		bubble_sprite.visible = false
		if isUsed:return
		bubble_sprite.visible = false
		animated_sprite_2d.visible = true
		animated_sprite_2d.play("default",Popping_AnimationSpeed,false)
	else:
		bubble_sprite.visible = true
		animated_sprite_2d.visible = false
		if !isUsed:return
		var tween = create_tween()
		var Regenerating_MoveTowardsValue:float = 1.0
		tween.tween_property($".","bubble_scale",Regenerating_MoveTowardsValue,Regenerating_AnimationTime)
	isUsed = newValue
