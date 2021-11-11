extends Node

var Stickman = preload("res://Stickman.tscn")
var SERVER_IP = '192.168.0.164'
var SERVER_PORT = 8080
var connected = false
var players = {}
var player
var map

func _ready():
	player = get_tree().get_root().get_node('Main/Player')
	map = get_tree().get_root().get_node('Main')
	
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
	
func fear(position):
	if connected:
		rpc("apply_fear", position)

func send_line(line):
	if connected:
		rpc("add_line", line)

func end():
	if connected:
		rpc_id(1, "player_end")

remote func add_line(points):
	map.create_line(points)

remote func reset():
	for id in players:
		players[id].queue_free()
		get_tree().get_root().remove_child(players[id])
	
	player.position = Vector2(0, 0);
	player.visible = true
	players = {}
	
remote func apply_fear(position):
	player.apply_fear(position)
	
remote func sync_players(infos):
	for id in infos:
		if id == get_tree().get_network_unique_id():
			continue
		
		if not id in players:
			players[id] = Stickman.instance()
			get_tree().get_root().add_child(players[id])
			#players[id].playerName = str(id)
		
		if is_instance_valid(players[id]):
			players[id].position = infos[id]
		else:
			players[id].queue_free()
			get_tree().get_root().remove_child(players[id])

func _connected_ok():
	connected = true
	print('Connected !')
	
func _server_disconnected():
	print('Kicked from server')

func _connected_fail():
	print('Cant connect to server')
