extends Node2D
# TODO
# - Start and end game
# - Stickman capacity : repulse
# - Random stickman becomes a zombie

onready var fpsLabel = $FpsLabel
onready var scoreLabel = $ScoreValue
onready var Line =  preload("Line.tscn")

export var lineTimeout = 2
export var lineWidth = 3

var line
var lineBody: StaticBody2D
var savedStickmans = 0
var deadStickmans = 0

func _physics_process(_delta):
	fpsLabel.set_text(str(Engine.get_frames_per_second()))

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		line = Line.instance()
		add_child(line)
		
	if Input.is_action_pressed("click"):
		line.add_point_to_line(get_local_mouse_position())

func _on_EndArea_body_entered(body):
	if body.is_in_group("stickmans"):
		body.queue_free()
		savedStickmans += 1
		scoreLabel.set_text(str(savedStickmans))
		check_if_game_ended()

func _on_LevelArea_body_exited(body):
	if body.is_in_group("stickmans"):
		body.queue_free()
		deadStickmans += 1
		check_if_game_ended()
		
func check_if_game_ended() -> bool: 
	if get_tree().get_nodes_in_group('stickmans').size() == 1: # TODO Why is there still one node ?
		# TODO Restart game, reposition stickmans
		savedStickmans = 0
		deadStickmans = 0
		scoreLabel.set_text(str(savedStickmans))
		return true
		
	return false
