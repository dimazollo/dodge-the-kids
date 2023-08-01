extends Area2D

signal hit

@export var speed = 400
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed('move_up'):
		velocity.y -= 1
	if Input.is_action_pressed('move_right'):
		velocity.x += 1
	if Input.is_action_pressed('move_down'):
		velocity.y += 1
	if Input.is_action_pressed('move_left'):
		velocity.x -= 1

	var players_animated_sprite = get_node("AnimatedSprite2D")
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		players_animated_sprite.play()
	else:
		players_animated_sprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		players_animated_sprite.animation = 'walk'
		players_animated_sprite.flip_v = false
		players_animated_sprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		players_animated_sprite.animation = 'up'
		players_animated_sprite.flip_v = velocity.y > 0


func _on_body_entered(body):
	pass # Replace with function body.
	hit.emit()
	hide()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
