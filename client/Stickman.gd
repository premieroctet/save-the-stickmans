extends KinematicBody2D
	
remote func set_position(position):
	move_and_slide(position, Vector2.UP)

func _physics_process(delta):
	return
