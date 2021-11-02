extends Node2D
# TODO
# - Implement jump and movements of stickmans
# - Add door at the end of the level
# - Add counter of saved stickmans

onready var fpsLabel = $FpsLabel
onready var Line =  preload("Line.tscn")

var line
export var lineTimeout = 2
export var lineWidth = 3

var lineBody: StaticBody2D

func _physics_process(_delta):
	fpsLabel.set_text(str(Engine.get_frames_per_second()))

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		print('just pressed click')
		line = Line.instance()
		add_child(line)
		
	if Input.is_action_pressed("click"):
		line.add_point_to_line(get_local_mouse_position())
