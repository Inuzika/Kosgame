@icon("res://asteroid-svgrepo-com.svg")
class_name Asteroid
extends Area2D

signal exploded(pos, size)
signal player_hit

enum AsteroidSize{LARGE,MEDIUM,SMALL}
@export var size := AsteroidSize.LARGE

@onready var sprite = $Sprite2D
@onready var Cshape= $CollisionShape2D
@export var rotation_rate = 20
@export var speed = 500

var randomI = randi_range(1,1000)
var randomII = randi_range(1,500)

func _ready():
	set_position(Vector2(randomI,randomII))

	match size:
		AsteroidSize.LARGE:
			speed = randomI/5.0
			rotation_rate = randomII/5.0
			sprite.texture = preload("res://Enemies/Asteroid1.png")
			Cshape.set_deferred("shape",preload("res://Enemies/Asteroid1largeHB.tres"))
		AsteroidSize.MEDIUM:
			speed = randomII
			rotation_rate = randomI
			sprite.texture = preload("res://Enemies/Asteroid1medium.png")
			Cshape.set_deferred("shape",preload("res://Enemies/Asteroid1mediumHB.tres"))
		AsteroidSize.SMALL:
			speed = randomII*2
			rotation_rate = randomI
			sprite.texture = preload("res://Enemies/Asteroid1small.png")
			Cshape.set_deferred("shape",preload("res://Enemies/Asteroid1smallHB.tres"))

func _process(_delta):
	pass

func _physics_process(delta):
	var movement_vector = Vector2(0,-1)
	global_position += movement_vector.rotated(rotation) * speed * delta
	rotate(deg_to_rad(-rotation_rate * delta))
	#Screen Wrapping
	var radius = Cshape.shape.radius
	var screen_size = get_viewport_rect().size
	if global_position.y+radius < 0:
		global_position.y = screen_size.y+radius
	elif global_position.y-radius > screen_size.y:
		global_position.y = -radius
	if global_position.x+radius < 0:
		global_position.x = screen_size.x+radius
	elif global_position.x-radius > screen_size.x:
		global_position.x = -radius

func explode():
	emit_signal("exploded",global_position,size)
	queue_free()

func _on_body_entered(body):
	emit_signal("player_hit")
	print(body)

