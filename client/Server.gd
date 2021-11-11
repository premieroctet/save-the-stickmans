extends Node

var SERVER_IP = '192.168.0.164'
var SERVER_PORT = 8080
var connected = false
var players = {}

func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.set_dtls_verify_enabled(false)
	
	var error = peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer

	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	print(error)
	print(peer.get_connection_status())

func _process(delta):
#	print(peer.get_connection_status())
	pass
	
func sync_player(info):
	if connected:
		rpc_unreliable_id(1, "register_player", info)
	
remote func sync_players(infos):
	for id in infos:
		if id == get_tree().get_network_unique_id():
			continue
		
		if not id in players:
			players[id] = preload("res://Stickman.tscn").instance()
			get_tree().get_root().add_child(players[id])
		
		players[id].position = infos[id] 

func _connected_ok():
	connected = true
	print('Connected !')
	
func _server_disconnected():
	print('Kicked from server')

func _connected_fail():
	print('Cant connect to server')
