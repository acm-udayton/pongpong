extends CharacterBody2D
class_name Ball

const initial_speed = 200
var speed = initial_speed
var direction = Vector2(-1,0)
var audio_manager
var paused = false

signal score(is_p1: bool)

func _ready():
	self.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	audio_manager = get_node("../AudioManager") # This should be using signals but whatever

#Delta refers to the time elapsed since the last _physics_process.
func _physics_process(delta: float):
	if !paused:
		var collision = move_and_collide(direction.normalized() * speed * delta)
	
		if collision != null: #Ball hit something with a collision box on the same layer as the ball
			
			var collider = collision.get_collider()
			if collider is Paddle:
				speed += 10
				
				#FYI:
				#position is relative to spawn position, global_position is relative to screen
				#Also, *technically* the ball has no position... but it's collision shape and/or sprite do!
				#Fortunately the collider object we get already refers to the collision shape
				
				var dist_from_center = collider.global_position.y - $CollisionShape2D.global_position.y
				
				#Calculate new direction vector using collision offset
				#This vector is not normalized here; it gets normalized when we move
				var angle_factor = pow(dist_from_center / 10, 2) # paddle is 10 high, square makes it wilder
				if (dist_from_center < 0):
					angle_factor = -angle_factor
				
				direction.y = -angle_factor
				direction.x = -direction.x
				
				audio_manager.play_sound("Hit")
			
		else: #interactions with walls are handled outside of the "collision" system
			#check for top/bottom wall collision
			var radius = $CollisionShape2D.shape.get_rect().size.y / 2#ball is square so x and y radius is the same
			var screen_size = get_viewport().get_visible_rect().size
			
			#is ball within its radius of the top/botttom edges of the screen?
			if $CollisionShape2D.global_position.y < 0 + radius or $CollisionShape2D.global_position.y > screen_size.y - radius:
				direction.y = -direction.y
				audio_manager.play_sound("Bounce")
			
			#collision with left/right edges of screen
			if $CollisionShape2D.global_position.x < 0 + radius or $CollisionShape2D.global_position.x > screen_size.x - radius:
				direction.x = -direction.x
				audio_manager.play_sound("Miss")
				
				#Signal score 
				if $CollisionShape2D.global_position.x < 0 + radius:
					score.emit(false)
				else:
					score.emit(true)
		
func reset(p1_scored: bool): #Reset ball after a score
	paused = true
	visible = false
	var viewport_size = get_viewport_rect().size
	position = Vector2(viewport_size.x/2, viewport_size.y/2)
	speed = initial_speed
	await get_tree().create_timer(2.0).timeout #wait 2 seconds
	
	if p1_scored:
		# Send ball towards P2
		direction = Vector2(1,0)
	else:
		direction = Vector2(-1,0)
		
	paused = false
	visible = true
	pass
		
	
