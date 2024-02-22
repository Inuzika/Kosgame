extends CharacterBody2D

signal laser_shot(laserprojectiles1)

@export var max_speed = 1000.0
@export var acceleration = 15.0
@export var deceleration = 5
@export var rotation_speed = 250.0

@onready var muzzle = $Muzzle
var laser_scene = preload("res://Projectiles/laserprojectiles1.tscn")

func _process(_delta):


	_animation()
	if Input.is_action_pressed("Shoot"):
		shoot_laser()


func _physics_process(delta):
	#Movement
	var input = Vector2(0, Input.is_action_pressed("Up"))
	velocity -= input.rotated(rotation) * acceleration
	velocity = velocity.limit_length(max_speed)
	if input.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO,deceleration)
#Rotation
	if Input.is_action_pressed("Left"):
		rotate(deg_to_rad(-rotation_speed * delta))
	if Input.is_action_pressed("Right"):
		rotate(deg_to_rad(rotation_speed * delta))
#Collision
	move_and_slide()
#Screen Wrapping
	var screen_size = get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0

func _animation():
	if Input.is_action_just_pressed("Up"):
		get_node("Ship_Inu/AnimationPlayer").play("engine_fire")
	if Input.is_action_just_released("Up"):
		get_node("Ship_Inu/AnimationPlayer").play_backwards("engine_fire")

func shoot_laser():
	var l = laser_scene.instantiate()
	l.global_position = muzzle.global_position
	l.rotation = rotation
	laser_shot.emit(l)
