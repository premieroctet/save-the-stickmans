extends KinematicBody2D

export (int) var gravity = 1200
# export (int) var run_speed = 60
export (int) var run_speed = 300
export (int) var jump_speed = -400

var velocity = Vector2()
const UP = Vector2(0, -1)

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_accept')

	if jump and is_on_floor():
		velocity.y = jump_speed
	if right:
		velocity.x += run_speed
	if left:
		velocity.x -= run_speed

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, UP)
