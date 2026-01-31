class_name MaskStatue
extends Mask

@onready var timer: Timer = $Timer

func _init() -> void:
	can_use = true


func on_interact(player:PlayerController) -> void:
	super(player)
	player.on_movement.connect(_player_standing)


func remove_mask(player:PlayerController) -> void:
	timer.stop()
	_player.is_detectable = true
	player.on_movement.disconnect(_player_standing)
	super(player)


func _player_standing(is_moving:bool) -> void:
	if !is_moving:
		print("Yo")
		_player.is_detectable = true
		timer.start()
	else:
		timer.stop()


func _on_timer_timeout() -> void:
	print("Invisible")
	_player.is_detectable = false
