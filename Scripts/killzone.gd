extends Area2D


##########  Onready Variables Initialization  ##########

@onready var player: CharacterBody2D = %Player
@onready var game_over_scene: Control = $"../Menu/GameOver"



func game_over() -> void:
	"""This function is called if the player will fall into eternity."""
	
	player.get_node("CollisionShape2D").queue_free()  # Bye-bye player
	
	game_over_scene.show_function()  # Show the game over scene


func _on_body_entered(_body: Node2D) -> void:
	"""This function is called when something enters the killzone area."""
	
	game_over() # Call the game over function above
