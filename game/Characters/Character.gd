

extends CharacterBody2D

@export var speed = 232
@export var jump_speed = -364
@export var gravity = 140 * 9.8
@export var jumps_count: int = 2

@export_range(0.0, 1.0) var friction = 0.32
@export_range(0.0, 1.0) var acceleration = 0.32

var is_jumping = false
var is_attacking = false
var jumps_used = 0

func _ready():
	add_to_group("players")


func _physics_process(delta):
	velocity.y += gravity * delta
	var dir = Input.get_axis("ui_left", "ui_right")

	# Movement
	if dir != 0:
		if is_on_floor():
			velocity.x = lerp(velocity.x, dir * speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, dir * speed * 1.4, acceleration)
		if dir > 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
		if not is_attacking:
			$AnimatedSprite2D.play("run")
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		if not is_attacking:
			$AnimatedSprite2D.play("idle")

	# Double Jump
	if Input.is_action_just_pressed("ui_up") and (is_on_floor() or jumps_used < jumps_count - 1):
		velocity.y = jump_speed
		jumps_used += 1
		is_jumping = true

	# Animation and Jumping State
	if is_jumping:
		if is_on_floor():
			jumps_used = 0
			is_jumping = false
		if not is_attacking:
			$AnimatedSprite2D.play("fall")

	# Attack
	if Input.is_action_just_pressed("ui_home"):
		is_attacking = true
	if is_attacking:
		$AnimatedSprite2D.play("attack")

	# Move and Slide
	move_and_slide()

	# Throwable weapon system
	if Input.is_action_just_pressed("ui_end"):
		var dagger = load("res://Weapons/Dagger.tscn").instantiate() as Throwable
		dagger.position = self.position + Vector2(0, -8)
		var direction = (get_global_mouse_position() - self.position).normalized()
		dagger.throw(640, direction)
		get_parent().add_child(dagger)

func _on_animated_sprite_2d_animation_finished():
	if is_attacking:
		is_attacking = false

func _on_animated_sprite_2d_animation_looped():
	if is_attacking:
		is_attacking = false
