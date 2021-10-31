extends RigidBody2D

export (int) var speed = 1

func _physics_process(delta):
	apply_central_impulse(Vector2(speed, 0))

