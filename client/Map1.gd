extends Node2D

onready var fpsLabel = $FpsValue
onready var scoreLabel = $ScoreValue
onready var timerLabel = $TimerValue
onready var Line =  preload("Line.tscn")

export var lineTimeout = 2
export var lineWidth = 3
export var time = 100

var line
var lineBody: StaticBody2D
var savedStickmans = 0
var deadStickmans = 0

func start_game():
	timerLabel.set_text(str(time))
	print('start game')
	
func end_game():
	savedStickmans = 0
	deadStickmans = 0
	time = 100
	scoreLabel.set_text(str(savedStickmans))
	print('end game')

func _ready():
	start_game();

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
		end_game();
		return true
		
	return false

func _on_Timer_timeout():
	time -= 1
	timerLabel.set_text(str(time))
	
	if time == 0:
		end_game()
