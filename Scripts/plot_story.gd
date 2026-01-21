extends Control


##########  Onready Variables Initialization  ##########

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var click_button: AudioStreamPlayer2D = $ClickButton
@onready var timer: Timer = $Timer
@onready var title_animation: AnimationPlayer = $TitleAnimation
@onready var story_plot: RichTextLabel = $StoryPlot
@onready var story: AnimationPlayer = $Story
@onready var story_sound: AudioStreamPlayer2D = $StorySound


##########  Other Variables Initialization  ##########

var double_speed:bool = false



func start_the_game() -> void:
	"""After the story is over, this function is called to start the real game."""
	
	# Change the scene to main.tscn
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _ready() -> void:
	"""This function is called once in the beginning of the game. Nothing special going on here"""
	
	animation_player.play_backwards("background")  # Show the background


func _on_start_button_pressed() -> void:
	"""This function is called when the start button is pressed. It starts
	showing the story play if it's the first time user opens the game."""
	
	# Open and read the score.txt file
	var file = FileAccess.open("res://score.txt", FileAccess.READ)
	var first_time: bool
	
	# Check if it's the first time user opens the game
	if file:
		var flag = file.get_as_text().to_int()  # Read the file content
		file.close()  # Close the file
		
		first_time = (flag == -1)  # It's first time if content is -1 (not changed)
	else:  # If the file cannot be opened for any reason, we assume it's user's first time
		first_time = true
	
	click_button.play()  # Play the sound effect
	await click_button.finished  # Wait for it to finish
	
	if not first_time:
		# If it's not the first time, go to the main scene directly
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
	else:
		title_animation.play("RESET")  # Playe RESET animation
		
		story.play("plot_story")  # Start telling the story
		story_sound.play()  # And playing my beautiful charming sound


func _on_story_animation_finished(_anim_name: StringName) -> void:
	"""After the story is finished, wait for 1s and then go to main scene."""
	
	timer.start()  # Start the timer


func _on_timer_timeout() -> void:
	"""This function is called after the 1s timer has run out."""
	
	timer.stop()  # Stop the timer
	start_the_game()  # Start the main game


func _on_skip_button_pressed() -> void:
	"""If user skips the story this function is called."""
	
	click_button.play()  # Play the sound effect
	await click_button.finished  # Wait for it to finish
	
	start_the_game()  # Start the game


func _on_double_speed_button_pressed() -> void:
	"""If user wants to speed up the storytelling speed, this function is called."""
	
	double_speed = !double_speed  # Toggle the double speed flag variable
	
	# Apply the changes
	if double_speed:
		story.speed_scale *= 4.0  # Increase the animation scale
		story_sound.pitch_scale *= 4.0  # And sound pitch (which is not directly speed, but will work)
	else:
		story.speed_scale /= 4.0  # Decrease the animation scale
		story_sound.pitch_scale /= 4.0  # And sound pitch (which is not directly speed, but will work)
