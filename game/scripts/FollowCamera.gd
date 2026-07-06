class_name FollowCamera
extends Camera2D

var target: Node2D = null

func _process(_delta: float) -> void:
	if target:
		global_position = target.global_position
