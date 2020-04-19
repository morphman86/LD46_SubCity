extends KinematicBody2D

export var speed = 150
export var steer_force = 500

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = Vector2.ZERO
var dmg = 2

func _ready():
	self.add_to_group("enemies")
	var targets = get_tree().get_nodes_in_group("player")
	var target = targets[randi() % targets.size()]
	start(target.position)

func start(_target):
	target = _target
	velocity = transform.x * speed
	
func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer
	
func _physics_process(delta):
	## Explode when reaching target position
	if position.distance_to(target) < 300:
		explode()
	## Steering
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	var collision_info = move_and_collide(velocity * delta)

func explode():
	var blob1 = load("res://Instances/Enemies/Blob1.tscn").duplicate().instance()
	blob1.position = self.position
	get_tree().get_root().add_child_below_node(get_tree().get_root().get_node("Game/Enemies"),blob1)
	var blob2 = load("res://Instances/Enemies/Blob1.tscn").duplicate().instance()
	blob2.position = self.position
	get_tree().get_root().add_child_below_node(get_tree().get_root().get_node("Game/Enemies"),blob2)
	set_physics_process(false)
	queue_free()
