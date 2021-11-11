extends KinematicBody2D
	
func _physics_process(delta):
	return

func set_player_name(name):
	$PlayerLabel.set_text(str(name))
