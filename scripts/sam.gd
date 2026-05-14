extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

const SPEED = 15

var current_state = IDLE
var dir: Vector2 = Vector2.ZERO

var is_roaming = true
var is_chatting = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready() -> void:
	randomize()
	timer.start()

func _physics_process(delta: float) -> void:
	if is_chatting:
		animated_sprite_2d.play("front_idle")
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	match current_state:
		IDLE:
			velocity = Vector2.ZERO
			play_idle_animation()
		NEW_DIR:
			dir = choose([Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT])
			current_state = MOVE
		MOVE:
			velocity = dir * SPEED
			play_walk_animation()
			
			# dùng move_and_collide để tránh dính player
			var motion = dir * SPEED * delta
			var collision = move_and_collide(motion)
			if collision:
				# nếu chạm phải player hoặc vật thể thì đổi hướng
				dir = choose([Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT])
				velocity = Vector2.ZERO
				current_state = IDLE
				return
	
	# nếu không va chạm thì vẫn trượt bình thường
	move_and_slide()

func play_idle_animation():
	if dir == Vector2.UP:
		animated_sprite_2d.play("back_idle")
	elif dir == Vector2.DOWN or dir == Vector2.ZERO:
		animated_sprite_2d.play("front_idle")
	elif dir == Vector2.LEFT:
		animated_sprite_2d.play("left_idle")
	elif dir == Vector2.RIGHT:
		animated_sprite_2d.play("right_idle")

func play_walk_animation():
	if dir == Vector2.UP:
		animated_sprite_2d.play("back_walk")
	elif dir == Vector2.DOWN:
		animated_sprite_2d.play("front_walk")
	elif dir == Vector2.LEFT:
		animated_sprite_2d.play("left_walk")
	elif dir == Vector2.RIGHT:
		animated_sprite_2d.play("right_walk")

func choose(array):
	array.shuffle()
	return array.front()
	
func _on_timer_timeout() -> void:
	timer.wait_time = choose([0.5, 1, 1.5, 2])
	current_state = choose([IDLE, NEW_DIR])
