extends Control


##########  Onready Variables Initialization  ##########

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var quit_button: TextureButton = $Buttons/Quit
@onready var restart_button: TextureButton = $Buttons/Restart
@onready var resume_button: TextureButton = $Buttons/Resume
@onready var sound_button: TextureButton = $Buttons/Sound
@onready var button_click_sfx: AudioStreamPlayer2D = $"../../SFX/ButtonClick"


##########  Other Variables Initialization  ##########

var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus = AudioServer.get_bus_index("SFX")



func play_button_sfx() -> void:
	"""This simple function plays the button click sound effect, that's all."""
	
	button_click_sfx.playing = true  # Play the sound effect
	await button_click_sfx.finished  # Wait until the sound effect is finished


func resume() -> void:
	"""This function is called when the user closes the setting menu. It resumes
	the game and take out the blur animation."""
	
	get_tree().paused = false  # Resume the game
	animation_player.play_backwards("blur")  # Play the blur animation backwards
	
	# Disable all buttons so they are not clickable anymore
	quit_button.disabled = true
	restart_button.disabled = true
	resume_button.disabled = true
	sound_button.disabled = true


func pause() -> void:
	"""This function is called when the user presses ESC or the setting menu icon.
	It's supposed to blur the game and show the menu options."""
	
	get_tree().paused = true  # Pause the game
	animation_player.play("blur")  # Play the blur animation
	
	# Enable the menu buttons so they are clickable
	quit_button.disabled = false
	restart_button.disabled = false
	resume_button.disabled = false
	sound_button.disabled = false


func show_function() -> void:
	"""This function is called when the user clicks the menu button. We don't know
	if the game is paused or not, but we should toggle the state anyway."""
	
	play_button_sfx()  # Play click sound effect
	
	# Check if we should pause the game or resume
	if not get_tree().paused:
		pause()
	else:
		resume()


func toggle_sound() -> void:
	"""This function toggles the voice of game. It's called when user presses M
	or press the mute button."""
	
	# We use NOT to toggle the current state of our music bus
	AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))
	AudioServer.set_bus_mute(sfx_bus, not AudioServer.is_bus_mute(sfx_bus))


func _process(_delta: float) -> void:
	"""This function is called in every tick of the game, and it's supposed to
	handle inputs and other user interactions."""
	
	# If the user pressed ESC button, show the function
	if Input.is_action_just_pressed("open_menu"):
		show_function()
	
	# If user pressed M, toggle the sound
	if Input.is_action_just_pressed("mute"):
		play_button_sfx()  # Play button sound effect
		toggle_sound()  # Call the toggle sound function
		
		# Use NOT trick to toggle the state of mute button
		sound_button.button_pressed = not sound_button.button_pressed


func _ready() -> void:
	"""This function is called once in the beginning of the game.
	Some basic initializations are being done here."""
	
	animation_player.play("RESET")  # Play the RESET animation to hide the menu
	
	# Unmute the sounds if they are previously muted
	AudioServer.set_bus_mute(music_bus, false)
	AudioServer.set_bus_mute(sfx_bus, false)
	
	
	# Disable the buttons as they are hidden in the beginning 
	quit_button.disabled = true
	restart_button.disabled = true
	resume_button.disabled = true
	sound_button.disabled = true


func _on_resume_pressed() -> void:
	"""This function is called when the user presses the resume button."""
	
	play_button_sfx()  # Play the sound effect
	resume()  # Call the resume function


func _on_restart_pressed() -> void:
	"""This function is called when the user presses the restart button."""
	
	play_button_sfx()  # Play the sound effect
	resume()  # Resume the game so it's no longer paused
	get_tree().reload_current_scene()  # Reload the current scene


func _on_quit_pressed() -> void:
	"""This function is called when the user presses the quit button."""
	
	play_button_sfx()  # Play the sound effect
	get_tree().quit()  # Quit the game and close everything


func _on_sound_pressed() -> void:
	"""This function is called when the user presses the mute/unmute button."""
	
	play_button_sfx()  # Play the sound effect
	toggle_sound()  # Toggle the sound using the defined function
