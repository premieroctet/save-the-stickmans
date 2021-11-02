extends Line2D

var lineBody: StaticBody2D

export (int) var lineTimeout = 2
export (int) var lineWidth = 3

# Create line body
func _ready():
	width = lineWidth
	default_color = Color(0, 0, 0)
	
	lineBody = StaticBody2D.new()
	add_child(lineBody)

func add_point_to_line(position):
	add_point(position)
	
	# Creates collision & shape for the lines (see https://godotengine.org/qa/67407/adding-collision-detection-to-line2d-collisionpolygon2d)
	var n = points.size()
	print(lineBody)
	for i in range(n-1):
		lineBody.add_child(create_segment(points[i], points[i+1]))

	# Remove lines after a timeouts
#	if Input.is_action_just_released("click"):
#		yield(get_tree().create_timer(lineTimeout), "timeout")
#		line.queue_free()

# Create a 2 collision shape from 2 points
func create_segment(p1 : Vector2, p2 : Vector2) -> CollisionShape2D:
	var collision = CollisionShape2D.new()
	collision.shape = SegmentShape2D.new()
	collision.shape.a = p1
	collision.shape.b = p2

	return collision
