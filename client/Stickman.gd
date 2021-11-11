extends KinematicBody2D

export (bool) var can_move = true
export (int) var gravity = 800
export (int) var run_speed = 150
export (int) var jump_speed = -350
export (int) var fear_impulse = 5000
export (Vector2) var fear_recover = Vector2(100, 100)
export (Vector2) var fear_distance = Vector2(30, 30)

var velocity = Vector2()
var fearVelocity = Vector2()

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
		for stickman in get_tree().get_nodes_in_group('stickmans'):
			if stickman != self:
				var distance: Vector2 = (stickman.position - position)
				if distance.abs().x < fear_distance.x:
					stickman.fear(distance)
			
		yield(get_tree().create_timer(2), "timeout")
		$ScreamLabel.visible = false
			
func fear(distance: Vector2):
	fearVelocity = Vector2(0, 0)
	fearVelocity = distance.normalized() * fear_impulse
	
func _physics_process(delta):
	if can_move == true:
		get_input() 
	
	# Gravity
	if velocity.y < gravity:
		velocity.y += gravity * delta
	
	# Fear
	# TODO Improve math
	if fearVelocity < Vector2(-1, -1) or fearVelocity > Vector2(1, 1):
		if fearVelocity.x > 0:
			fearVelocity -= fear_recover
		else:
			fearVelocity += fear_recover
			
		move_and_slide(fearVelocity * delta, Vector2.UP)
	
	# Movements
	move_and_slide(velocity, Vector2.UP)
