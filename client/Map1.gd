extends Node2D

onready var fpsLabel = $FpsValue
onready var scoreLabel = $ScoreValue
onready var timerLabel = $TimerValue
onready var Line =  preload("Line.tscn")

export var time = 100

var drawLine
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
		drawLine = Line2D.new()
		add_child(drawLine)
		
	if Input.is_action_pressed("click"):
		drawLine.add_point(get_local_mouse_position())
	elif drawLine:
		Server.send_line(drawLine.points)
		create_line(drawLine.points)
		remove_child(drawLine)
		drawLine = null

func create_line(points):
	var newLine = Line.instance()
	add_child(newLine)
	
	for point in points:
		newLine.add_point_to_line(point)

func _on_EndArea_body_entered(body):
	if body == $Player:
		body.visible = false
		Server.end()

func _on_LevelArea_body_exited(body):
	if body == $Player:
		body.visible = false
		Server.end()

func _on_Timer_timeout():
	time -= 1
	timerLabel.set_text(str(time))
	
	if time == 0:
		end_game()
