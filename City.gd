extends Area2D

export var life = 10

onready var label = get_node("Label")


func _ready():
	self.add_to_group("player")
	label.text = str(life)
	
func damage(dmg):
	life -= dmg
	label.text = str(life)
	if life <= 0:
		explode()
		
func explode():
	set_physics_process(false)
	var player_nodes = get_tree().get_nodes_in_group("player")
	for n in player_nodes:
		if n != self:
			n.explode()
	queue_free()


func _on_City_body_entered(body):
	if body.is_in_group("enemies"):
		body.explode()
		damage(body.dmg)
