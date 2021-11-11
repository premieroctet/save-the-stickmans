extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var players = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_players_infos(infos):
	for id in infos:
		if !players[id]:
			players[id] = preload("res://Stickman.tscn").instance()
		
		players[id].position = infos[id]
