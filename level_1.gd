extends Node2D

@onready var player = $Player1

func _ready():
	player.connect("laser_shot", on_player_shoot)

func on_player_shoot():
	$Lasers.add_child(laserprojectiles1)
