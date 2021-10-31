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
	if Input.is_action_just_pressed("click"):
		line = create_line()
		
	if Input.is_action_pressed("click"):
		line.add_point(get_local_mouse_position())
		
		# Creates collision & shape for the lines (see https://godotengine.org/qa/67407/adding-collision-detection-to-line2d-collisionpolygon2d)
		var n = line.points.size()
		for i in range(n-1):
			lineBody.add_child(create_segment(line.points[i], line.points[i+1]))
			
	# Remove lines after a timeouts
#	if Input.is_action_just_released("click"):
#		yield(get_tree().create_timer(lineTimeout), "timeout")
#		line.queue_free()
		
func create_line() -> Line2D:
	var line = Line2D.new()
	line.width = lineWidth
	line.default_color = Color(0, 0, 0)
	
	lineBody= StaticBody2D.new()
	line.add_child(lineBody)
	add_child(line)	
	
	return line
	
# Create a 2 collision shape from 2 points
func create_segment(p1 : Vector2, p2 : Vector2) -> CollisionShape2D:
	var collision = CollisionShape2D.new()
	collision.shape = SegmentShape2D.new()
	collision.shape.a = p1
	collision.shape.b = p2

	return collision
