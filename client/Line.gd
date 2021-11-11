extends Line2D

onready var lineBody: StaticBody2D = $StaticBody2D

export (int) var lineTimeout = 5
export (int) var lineWidth = 3

func _ready():
	yield(get_tree().create_timer(lineTimeout), "timeout")
	queue_free()

func add_point_to_line(position):
	add_point(position)
	
	# Creates collision & shape for the lines (see https://godotengine.org/qa/67407/adding-collision-detection-to-line2d-collisionpolygon2d)
	var n = points.size()
	for i in range(n-1):
		lineBody.add_child(create_segment(points[i], points[i+1]))

# Create a 2 collision shape from 2 points
func create_segment(p1 : Vector2, p2 : Vector2) -> CollisionShape2D:
	var collision = CollisionShape2D.new()
	collision.shape = SegmentShape2D.new()
	collision.shape.a = p1
	collision.shape.b = p2

	return collision
