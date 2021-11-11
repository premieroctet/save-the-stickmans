extends KinematicBody2D

export (float) var rotation_speed = 0.5
export (int) var rotation_dir = 1

export (int) var movement_speed = 10
export (int) var max_movement_limit = 20
export (int) var movement_dir = 1

var velocity = Vector2()
var velocity_value = 1
var initial_position = Vector2()

func _ready():
	initial_position = position

func _physics_process(delta):
	if rotation_speed > 0:
		rotation += rotation_dir * rotation_speed * delta
	
	if movement_speed > 0:
		velocity = Vector2()
		velocity.x += velocity_value
		
		if abs(position.x - initial_position.x) > max_movement_limit:
			velocity_value = -1 
		elif position.x < initial_position.x:
			velocity_value = 1
			
		velocity = velocity.normalized() * movement_speed
		velocity = move_and_slide(velocity)
