extends KinematicBody2D

export (int) var gravity = 800
export (int) var run_speed = 150
export (int) var jump_speed = -350

var velocity = Vector2()

func get_input():
	velocity.x = 0
	
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_accept')
	var scream = Input.is_action_just_pressed('scream')

	if jump and is_on_floor():
		velocity.y = jump_speed
	if right:
		velocity.x += run_speed
	if left:
		velocity.x -= run_speed
	if scream:
		$ScreamLabel.visible = true
#		for stickman in get_tree().get_nodes_in_group('stickmans'):
#			if stickman != self:
#				stickman.velocity.bounce(stickman.velocity)
			
		yield(get_tree().create_timer(2), "timeout")
		$ScreamLabel.visible = false
			
func _physics_process(delta):
	get_input() 
	velocity.y += gravity * delta
	move_and_slide(velocity, Vector2.UP)
