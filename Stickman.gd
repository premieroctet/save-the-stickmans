extends KinematicBody2D

export (int) var speed = 20
export (int) var gravity = 1200

var velocity = Vector2()

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = speed;
	velocity = move_and_slide(velocity)
