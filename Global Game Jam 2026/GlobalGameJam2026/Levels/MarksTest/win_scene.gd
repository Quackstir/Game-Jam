extends Control

@onready var label_2: Label = $CanvasLayer/MarginContainer/HBoxContainer/Panel2/VBoxContainer/Label2

func _ready() -> void:
	label_2.text = "Score: " + str(GM.score)
