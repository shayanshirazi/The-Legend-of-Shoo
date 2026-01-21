extends AnimatedSprite2D


##########  Onready Variables Initialization  ##########

@onready var timer: Timer = $Timer
@onready var player_health_bar: ProgressBar = $"../HealthBar"
@onready var player: CharacterBody2D = %Player



func _ready() -> void:
	"""This function is called only once when the object is initialized."""
	
	hide()  # Hide the object as nothing is exploded yet


func start() -> void:
	"""This function is called when something is exploded!"""
	
	show()  # Show the body
	play()  # Play the animation
	timer.start()  # Start the timer so after animation is done end the explosion


func _on_timer_timeout() -> void:
	"""This function is called after the explosion timer is finished. It hides the effect."""
	
	timer.stop()  # Stop the timer
	hide()  # Hide the effect
