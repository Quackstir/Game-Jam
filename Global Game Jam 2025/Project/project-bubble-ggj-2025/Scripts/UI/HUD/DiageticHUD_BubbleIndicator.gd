class_name DiageticHUD_BubbleIndicator
extends Node2D

@onready var PositionMoveTowards:Vector2 = Vector2(0,0)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var bubble_sprite: Sprite2D = $"Bubble Sprite"

var isUsed:bool:set = isUsedUpdate

@export var expansionCurveAnimation:Curve
var bubble_scale:float = 0.0:
	set(newValue):
		scale.x = expansionCurveAnimation.sample(newValue)
		scale.y = expansionCurveAnimation.sample(newValue)

func _physics_process(delta: float) -> void:
	position = lerp(position, PositionMoveTowards, get_process_delta_time() * 10)
	
func isUsedUpdate(newValue:bool) -> void:
	if newValue:
		bubble_sprite.visible = false
		if isUsed:return
		bubble_sprite.visible = false
		animated_sprite_2d.visible = true
		animated_sprite_2d.play("default",2,false)
	else:
		bubble_sprite.visible = true
		animated_sprite_2d.visible = false
		if !isUsed:return
		var tween = create_tween()
		tween.tween_property($".","bubble_scale",1.0,0.3)
	isUsed = newValue
