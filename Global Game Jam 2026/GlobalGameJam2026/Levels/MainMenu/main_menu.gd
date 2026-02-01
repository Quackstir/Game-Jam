extends Control
@onready var main_buttons: VBoxContainer = $"Main Buttons"
@onready var credits: Panel = $Credits
@onready var back_button: Button = $"Credits/Back Button"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_buttons.visible = true
	credits.visible = false


func _on_play_button_pressed() -> void:
	Global.scene_manager.change_level_scene("res://Levels/Tutorial_Level/TutorialLevel.tscn")
	self.queue_free()


func _on_credits_button_pressed() -> void:
	main_buttons.visible = false
	credits.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	main_buttons.visible = true
	credits.visible = false
