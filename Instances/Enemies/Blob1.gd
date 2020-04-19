extends KinematicBody2D

export var speed = 150
export var steer_force = 500
export var dmg = 1

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = Vector2.ZERO

func _ready():
	self.add_to_group("enemies")
	var targets = get_tree().get_nodes_in_group("player")
	var t = targets[randi() % targets.size()]
	start(t.position)

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
	if position.distance_to(target) < 10:
		explode()
	## Steering
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	move_and_collide(velocity * delta)

func explode():
	set_physics_process(false)
	#$AnimatedSprite.play("Explode")
	#yield($AnimatedSprite, "animation_finished")
	queue_free()
