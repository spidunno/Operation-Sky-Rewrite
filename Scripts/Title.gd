extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func hide_title_ui():
	$username.visible = false
	$address.visible = false
	$port.visible = false
	$join.visible = false
	$host.visible = false

func _on_join_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client($address.text, $port.value)
	multiplayer.multiplayer_peer = peer
#	multiplayer.set("username", $username.text)
#	multiplayer.multiplayer_peer.set_meta("username", $username.text)
	get_tree().change_scene_to_file("res://Scenes/World.tscn")
#	var world = load("res://Scenes/World.tscn").instantiate()
	#world.username = $username.text
#	add_child(world)
#	move_child(world, 0)
#	hide_title_ui()


func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server($port.value)
	multiplayer.multiplayer_peer = peer
#	multiplayer.set("username", $username.text)
#	multiplayer.multiplayer_peer.set_meta("username", $username.text)
	get_tree().change_scene_to_file("res://Scenes/World.tscn")
#	var world = load("res://Scenes/World.tscn").instantiate()
#	world.username = $username.text
#	add_child(world)
#	move_child(world, 0)
#	hide_title_ui()
