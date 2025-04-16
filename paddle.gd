extends CharacterBody2D
class_name Paddle

const initial_movespeed = 100
var accel_accumulator = 0
const accel_factor = 15

var up_action_str = ""
var down_action_str = ""

func set_pos_and_controls(up_action: String, down_action: String, x: float, y: float):
	up_action_str = up_action
	down_action_str = down_action
	position.x = x
	position.y = y
	accel_accumulator = 0

func _physics_process(delta):
	var up = Input.is_action_pressed(up_action_str)
	var down = Input.is_action_pressed(down_action_str)
	
	if (up and down) or (!up and !down): #Both directions pressed or neither
		accel_accumulator = 0
		velocity.y = 0
		pass
	else:
		accel_accumulator += accel_factor
		velocity.y = initial_movespeed+accel_accumulator
		if up:
			velocity.y = -velocity.y
		move_and_collide(velocity * delta)
	
	#clamp to edges of screen based on size of collision box
	# The $ is equivalent to get_node()
	var radius_y = $CollisionShape2D.shape.get_rect().size.y / 2
	var screen_size = get_viewport().get_visible_rect().size
	
	position = position.clamp(Vector2(0,0+radius_y),Vector2(screen_size.x,screen_size.y-radius_y))
