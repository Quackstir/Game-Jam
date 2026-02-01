extends Control

@onready var lose_sfx: AudioStreamPlayer = $LoseSfx

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("_play_lose_sound")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _play_lose_sound():
	lose_sfx.play()


func _on_retry_button_pressed():
	Global.scene_manager.huds.remove_child(self)
	Global.scene_manager.reload_level()


func _on_quit_button_pressed():
	Global.scene_manager.get_current_level().queue_free()
	Global.scene_manager.change_hud_scene("res://Levels/MainMenu/main_menu.tscn")
