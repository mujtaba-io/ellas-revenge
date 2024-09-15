extends RigidBody2D
class_name Throwable

# How much health reduced if it hit
@export var health_impact: float = 1.0


func _ready():
	add_to_group("throwables")



func throw(initial_force: float, direction: Vector2):
	var unit_direction := direction.normalized()
	var impulse := unit_direction * initial_force
	apply_central_impulse(impulse)


func _on_body_entered(body):
	if "health" in body:
		body.health -= health_impact
	queue_free()
