extends Node2D

@export_category("Stage Variables")
@export var SizeStage:int = 1
@export var Stages:Array[Resource_Bubble_StageContainer]

@export_category("Misc Variables")
@export var Player:bubble_character
@export var minChangeBody:float = 0.8
@export var maxChangeBody:float = 1.2

@export_category("Size Changes")
@onready var initialScaleHorizontal:float = scale.x
var isLookingRight:bool = false:
	set(newValue):
		isLookingRight = newValue
		scale.x = initialScaleHorizontal if newValue else -initialScaleHorizontal

@export_category("Misc Node Refernces")
@onready var body: Sprite2D = $Body
@onready var timer: Timer = $Timer

@export_category("Eye Nodes")
@onready var left_pupil_anchor: Node2D = $"left Pupil Anchor"
@onready var right_pupil_anchor: Node2D = $"right Pupil Anchor"

@onready var eyes_pupil_left: Sprite2D = $"left Pupil Anchor/Eyes Pupil Left"
@onready var eyes_pupil_right: Sprite2D = $"right Pupil Anchor/Eyes Pupil Right"

@onready var eyes_blink: Sprite2D = $"Eyes Blink"

@export_category("Textures")
@export var T2D_Body:Array[Texture2D]
@export var Mouth_Frown:Texture2D
@export var Mouth_Smile:Texture2D
@export var Glasses:Texture2D
@export var Eyes_Pupil:Texture2D
@export var Eyes_Blink:Texture2D

func _on_timer_timeout() -> void:
	body.texture = T2D_Body[randi_range(0,T2D_Body.size() - 1)]
	timer.wait_time = randf_range(minChangeBody,maxChangeBody)
	
func EyesBlink() -> void:
	eyes_pupil_left.visible = false
	eyes_pupil_right.visible = false
	eyes_blink.visible = true

func EyesOpen() -> void:
	eyes_pupil_left.visible = true
	eyes_pupil_right.visible = true
	eyes_blink.visible = false

func _process(delta: float) -> void:
	var input_axis := Input.get_axis("ui_left", "ui_right")
	
	if input_axis > 0: 
		isLookingRight = true
	elif input_axis < 0:
		isLookingRight = false

	EyesLookAt(Vector2(input_axis,Player.velocity.y))

func EyesLookAt(LookTowards:Vector2) -> void:
	if LookTowards.length() <= 0:
		eyes_pupil_left.position = Vector2(0,0)
		eyes_pupil_right.position = Vector2(0,0)
	else:
		eyes_pupil_left.position = Vector2(20,0)
		eyes_pupil_right.position = Vector2(20,0)
	
	left_pupil_anchor.look_at(LookTowards + left_pupil_anchor.global_position)
	right_pupil_anchor.look_at(LookTowards + right_pupil_anchor.global_position)
