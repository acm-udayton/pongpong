extends Node2D

const paddle_dist_from_edge = 72
var p1_score = 0
var p2_score = 0
var paddle1
var paddle2
var game_ending_score = 15

func _ready():
	var viewport_size = get_viewport_rect().size
	
	#set up scores
	$P1Score.text = str(p1_score)
	$P2Score.text = str(p2_score)
	
	#create 2 paddles and add them to scene
	var paddle_scene = load("res://paddle.tscn")
	
	paddle1 = paddle_scene.instantiate()
	paddle1.set_pos_and_controls("p1_up", "p1_down", paddle_dist_from_edge, viewport_size.y / 2)
	add_child(paddle1)
	
	paddle2 = paddle_scene.instantiate()
	paddle2.set_pos_and_controls("p2_up", "p2_down", viewport_size.x - paddle_dist_from_edge, viewport_size.y / 2)
	add_child(paddle2)
	
	await get_tree().create_timer(1.0).timeout #wait 1 second
	
	#Spawn ball
	var ball_scene = load("res://ball.tscn")
	var ball = ball_scene.instantiate()
	ball.global_position = Vector2( viewport_size.x / 2, viewport_size.y / 2)
	add_child(ball)
	
	#connect to ball score signal
	var score_signal = ball.score.connect(_on_score)
	
func _on_score(is_p1: bool):
	if is_p1:
		p1_score += 1
		$P1Score.text = str(p1_score)
	else:
		p2_score += 1
		$P2Score.text = str(p2_score)
		
	if p1_score == game_ending_score or p2_score == game_ending_score: #end of game
		
		#hide and stop ball
		$Ball.paused = true
		$Ball.visible = false
		
		#hide paddles
		paddle1.visible = false
		paddle2.visible = false
		
		await get_tree().create_timer(5.0).timeout #wait 5 seconds
		
		#reset paddles
		var viewport_size = get_viewport_rect().size
		paddle1.set_pos_and_controls("p1_up", "p1_down", paddle_dist_from_edge, viewport_size.y / 2)
		paddle2.set_pos_and_controls("p2_up", "p2_down", viewport_size.x - paddle_dist_from_edge, viewport_size.y / 2)
		paddle1.visible = true
		paddle2.visible = true
		
		#reset score
		p1_score = 0
		$P1Score.text = str(p1_score)
		p2_score = 0
		$P2Score.text = str(p2_score)
		
		#turn ball back on
		$Ball.paused = false
		$Ball.visible = true
		
	if is_p1:
		$Ball.reset(true)
	else:
		$Ball.reset(false)
		
		
		
	
	
	
	
	
