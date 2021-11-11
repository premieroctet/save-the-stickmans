extends KinematicBody2D

export (bool) var can_move = true
export (int) var gravity = 800
export (int) var run_speed = 150
export (int) var jump_speed = -350
export (Vector2) var fear_recover = Vector2(100, 100)
export (Vector2) var fear_distance = Vector2(30, 30)

var MAX_FEAR_DISTANCE = 50
var FEAR_IMPULSE = 5000

var velocity = Vector2()
var fearVelocity = Vector2()
var loop = 0

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
		Server.fear(self.position)

func apply_fear(scream_position: Vector2):
	var distance = scream_position.distance_to(self.position)
	
	if distance < MAX_FEAR_DISTANCE: 
		var impulse = (1 - distance / MAX_FEAR_DISTANCE) * FEAR_IMPULSE
		var move = (self.position - scream_position) * impulse
		
		velocity.x += move.x
		velocity.y += move.y

func _physics_process(delta):
	if can_move == true:
		get_input() 
	
	# Gravity
	velocity.y += gravity * delta
	
	# Fear
	# TODO Improve math
#	if fearVelocity < Vector2(-1, -1) or fearVelocity > Vector2(1, 1):
#		if fearVelocity.x > 0:
#			fearVelocity -= fear_recover
#		else:
#			fearVelocity += fear_recover
#			
#		move_and_slide(fearVelocity * delta, Vector2.UP)
	
	# Movements
	velocity = move_and_slide(velocity, Vector2.UP)
	
	Server.sync_player(self.position)
	
