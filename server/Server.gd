extends Node

var SERVER_PORT = 8080
var MAX_PLAYERS = 50

var players_ended = []
var players_positions = {}

func _ready():
	var server = NetworkedMultiplayerENet.new()
	var server_created = server.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(server)
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	print('server started ', server_created)

func _physics_process(delta):
	send_world_state()
	
func is_all_players_ended():
	return players_ended.size() == players_positions.size()

func check_should_restart_game():
	if is_all_players_ended():
		rpc('reset')
		players_ended = []
		players_positions = {}

func _player_connected(id):
	print('Player connected', id)
	print('Number of players %d' % players_positions.size())

func _player_disconnected(id):
	print('Player disconnect ', id)
	print('Number of players %d' % players_positions.size())
	
	players_positions.erase(id)
	players_ended.erase(id)
	check_should_restart_game()
	
func send_world_state():
	rpc_unreliable('sync_players', players_positions)

remote func register_player(info):
	var id = get_tree().get_rpc_sender_id()
	players_positions[id] = info
	
remote func player_end():
	var id = get_tree().get_rpc_sender_id()
	players_ended.append(id)
	check_should_restart_game()
