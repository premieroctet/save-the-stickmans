extends KinematicBody2D

export (float) var rotation_speed = 0.5
export (int) var rotation_dir = 1

export (int) var movement_speed = 10
export (int) var max_movement_limit = 10
export (int) var movement_dir = 1

var velocity = Vector2()
var velocity_value = 1
var initial_position = Vector2()

# TODO No collision with drawing

func _ready():
	initial_position = position

func _physics_process(delta):
	if rotation_speed > 0:
		rotation += rotation_dir * rotation_speed * delta
	
	print(initial_position, position)
	
	if movement_speed > 0:
		velocity = Vector2()
		
		velocity.x += velocity_value
		
		# TODO Check limit to change velocity value and make the platform go back
		# TODO Use movemnet dir to change velocity direction
		if initial_position.x - position.x > max_movement_limit:
			velocity_value = -1 
		elif position.x < initial_position.x:
			velocity_value = 1
			
		velocity = velocity.normalized() * movement_speed
		velocity = move_and_slide(velocity)
