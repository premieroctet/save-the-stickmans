extends KinematicBody2D

export (bool) var can_move = true
export (int) var gravity = 800
export (int) var run_speed = 150
export (int) var jump_speed = -350

export (int) var FEAR_IMPULSE = 10000
export (Vector2) var FEAR_RECOVER = Vector2(100, 100)
export (Vector2) var FEAR_DISTANCE = Vector2(30, 30)

var velocity = Vector2()
var fearVelocity = Vector2()
var loop = 0
var playerName = "Jean-Jean"
var screaming = false

func _ready():
	playerName = get_tree().get_network_unique_id()
	$PlayerLabel.set_text(str(playerName))
	
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
	if scream and not screaming:
		screaming = true
		$PlayerLabel.set_text("Aaaaaah!")
		Server.fear(self.position)
		$Growl.play()
		yield(get_tree().create_timer(2), "timeout")
		$PlayerLabel.set_text(str(playerName))
		screaming = false


func apply_fear(scream_position: Vector2):
	var distance: Vector2 = (self.position - scream_position)

	if distance.abs().x < FEAR_DISTANCE.x:
		fearVelocity = Vector2(0, 0)
		fearVelocity = distance.normalized() * FEAR_IMPULSE
		$PlayerLabel.set_text("#$@&")
		yield(get_tree().create_timer(1), "timeout")
		$PlayerLabel.set_text(str(playerName))
		
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
			fearVelocity -= FEAR_RECOVER
		else:
			fearVelocity += FEAR_RECOVER
			
		move_and_slide(fearVelocity * delta, Vector2.UP)
	# Movements
	velocity = move_and_slide(velocity, Vector2.UP)
	
	Server.sync_player(self.position)
	
