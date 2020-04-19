extends Area2D

export var life = 1

onready var label = get_node("Label")

var missile = load("res://Instances/Objects/Missile.tscn").duplicate()
var fire = false
var loaded = null

func _ready():
	self.add_to_group("player")
	label.text = str(life)

func _input(event):
	if not fire and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		var mousepos = get_local_mouse_position()
		var i_missile = missile.instance()
		i_missile.start(mousepos)
		loaded = i_missile
		fire = true
		

func _on_Cooldown_timeout():
	if fire:
		add_child_below_node(get_tree().get_root().get_node("Game"),loaded)
		fire = false
		
func damage(dmg):
	life -= dmg
	label.text = str(life)
	if life <= 0:
		explode()
		
func explode():
	set_physics_process(false)
	queue_free()


func _on_Tower_body_entered(body):
	if body.is_in_group("enemies"):
		body.explode()
		damage(body.dmg)
