extends Area2D


##########  Onready Variables Initialization  ##########

@onready var player: CharacterBody2D = %Player
@onready var timer: Timer = $Timer


##########  Other Variables Initialization  ##########

var SPEED: int = 300
var direction: Vector2 = Vector2.ZERO



func _ready() -> void:
	"""This function is called once at the beginning of the game."""
	
	global_position.y /= 3  # Scale the stone position


func _physics_process(delta: float) -> void:
	"""This function is called in every tick of the game, and is meant to
	handle the physic aspect of the stone."""
	
	# If the stone is going somewhere, move it
	if direction != Vector2.ZERO:
		global_position += direction * SPEED * delta  # Make it move towards direction
	
	# If we ran out of screen, start the 0.5s timer and delete the object afterwards
	if global_position.x < 0:
		timer.start()  # Start the timer


func _on_timer_timeout() -> void:
	"""This function is called after the 0.5s timer is finished. It just deletes the
	stone from the scene."""
	
	queue_free()  # Delete the object from the scene


func shoot(pos: Vector2) -> void:
	"""This function is called when the stone is shooted. We find the position of player
	and by normalizing the vector of their delta distance, we have a direction to go towards."""
	
	direction = (pos - global_position).normalized()  # Calculate the direction vector


func _on_body_entered(body: Node2D) -> void:
	"""If the stone hits anything, this function is called."""
	
	# If it's not the player, it doesn't matter
	if not body is CharacterBody2D:
		return
	
	body.take_stone_damage()  # Make the player take stone damage
	queue_free()  # Delete the stone afterward
