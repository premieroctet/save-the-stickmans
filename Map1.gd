extends Node2D

onready var line = $Line2D
onready var fpsLabel = $FpsLabel

var segments = []

func _physics_process(delta):
	fpsLabel.set_text(str(Engine.get_frames_per_second()))

func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		line.add_point(get_local_mouse_position())
		# TODO Create collision & shape for the lines (see https://godotengine.org/qa/67407/adding-collision-detection-to-line2d-collisionpolygon2d)
	
		var n = line.points.size()
		for i in range(n-1):
			segments.append(create_segment(line.points[i], line.points[i+1]))
			
		for s in segments:
			$Line2D/LineBody.add_child(s)
		
# Create a 2 collision shape from 2 points
func create_segment(p1 : Vector2, p2 : Vector2) -> CollisionShape2D:
	var collision = CollisionShape2D.new()
	collision.shape = SegmentShape2D.new()
	collision.shape.a = p1
	collision.shape.b = p2

	return collision
