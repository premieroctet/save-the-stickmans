extends Node2D
# TODO
# - Add timeout on line, to delete it after X seconds => Maybe use a script just for a line instance ?
# - Implement jump and movements of stickmans
# - Add door at the end of the level
# - Add counter of saved stickmans

onready var fpsLabel = $FpsLabel

export var lineTimeout = 2
export var lineWidth = 3

var line: Line2D
var lineBody: StaticBody2D

func _ready():
	print("ready")

func _physics_process(_delta):
	fpsLabel.set_text(str(Engine.get_frames_per_second()))

func _input(_event: InputEvent) -> void:
#	if Input.is_action_just_pressed("click"):
#		line = $Line.duplicate()
		
	if Input.is_action_pressed("click"):
		line.add_point_to_line(get_local_mouse_position())
