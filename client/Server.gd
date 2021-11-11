extends Node

var SERVER_IP = '127.0.0.1'
var SERVER_PORT = 1100
var MAX_PLAYERS = 50

func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().set_network_peer(peer)

	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	print('client started')

func _connected_ok():
	print('Connected to server')

func _server_disconnected():
	print('Kicked from server')

func _connected_fail():
	print('Cant connect to server')
