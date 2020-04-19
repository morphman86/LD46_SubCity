extends Area2D

export var speed = 400
export var steer_force = 500

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = Vector2.ZERO

func start(_target):
	$Lifetime.connect("timeout", self, "_on_Lifetime_timeout")
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
	position += velocity * delta
	
func _on_Missile_body_entered(body):
	body.explode()
	explode()
	
func _on_Lifetime_timeout():
	explode()

func explode():
	set_physics_process(false)
	$AnimatedSprite.play("Explode")
	yield($AnimatedSprite, "animation_finished")
	queue_free()
