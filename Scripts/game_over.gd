extends Control


##########  Onready Variables Initialization  ##########

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var button_click_sfx: AudioStreamPlayer2D = $"../../SFX/ButtonClick"
@onready var health_bar: ProgressBar = $"../HealthBar"
@onready var setting_button: TextureButton = $"../Resume"
@onready var score_bar: Label = $"../ScoreBar"
@onready var score_report: RichTextLabel = $ScoreReport
@onready var typing_effect: AudioStreamPlayer2D = $TypingEffect
@onready var delay_timer: Timer = $Delay
@onready var restart_button: TextureButton = $RestartButton
@onready var click_button: AudioStreamPlayer2D = $ClickButton
@onready var setting_menu: Control = $"../SettingMenu"
@onready var legend_mode: Label = $LegendMode
@onready var normal_mode: Label = $Label
@onready var game_over_audio: AudioStreamPlayer2D = $GameOverAudio
@onready var game_finished_audio: AudioStreamPlayer2D = $GameFinishedAudio
@onready var best_score_label: RichTextLabel = $BestScore
@onready var best_score_label_fade: RichTextLabel = $BestScore/BestScoreFade


##########  Other Variables Initialization  ##########

var player_score
var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus = AudioServer.get_bus_index("SFX")
var message: String
var cur_chars: int = 0
var best_score: int = 0
var last_high_score_color: float

var zero_result = [
	"$? You can do better than this old sport! Try again, I believe in you.",
	"Zero does not mean you failed, it means you have just started! Remember, legends are not born, they are shaped ...",
	"Don't feel bad. See this as the silence before the thunder ... and prepare for it :0",
	"Is $ the best you can do? I doubt. Make the princess proud, prove your desire to the king ... try again!",
	"Zero is mathematically a beautiful number ... but not as your score!",
	"$? Never give up, never give up, no, noo, nooooooo!",
	"You can do better than $! One more time, one more time, one more time ...",
	"The princess is laughing at you, WTH you're doing? $!?",
	"$? You might have disappointed the princess, but I'm still proud of you, no matter how terrible your gaming skills are …",
	"Zero? You can't be serious!! OMG, you're either so bad or you just have started. Prove I'm wrong … try again",
]

var bad_result = [
	"You passed $ pillars! Who would have thought? Keep going, as you get better in every try ^_^",
	"I want to be honest with you: $ pillars is not bad, but you can do much better! Show some skills to make it to other stages!",
	"Did you just pass $ pillars? Nice, nice, nice. Can you do better? Let's see :D",
	"Who's showing off skills here? Hmmmmm is it you? $ is super-duper cool, see if you can go higher:",
	"$ pillars you passed, one by one. Princess is waiting for you, make Shoo proud!",
	"Hmmm did you just pass $ pillars? Good job, but you know what they say? Good is the enemy of great ...",
	"Your skills are not defined based on a single attempt! You did $, but you can do waaaaaaaaaaay better. Make me proud *L*",
	"Don't get super-excited, but you did well. $ pillars, one by one ... can you achieve more?"
]

var avg_result = [
	"$ pillars, one after another! You took the first step of carving your name in history :D",
	"You passed $ pillars; you did great! But sometimes, my friend, even great is not enough, you need to do even better ...",
	"$ is an impressive start! But the king's challenge was not supposed to be easy. Remember, I believe in you ...",
	"How was the view when you saw those $ pillars behind? Fascinating, right o,o",
	"You did superfragilisticexpialidocious. $? Wooow! You're on the rise! Few make it here.",
	"You are actually better than 60% of people who tested this game already! $? Keep going ...",
	"Ok, ok ... you're not bad! $ is an acceptable result, the question is if you can do better (?)",
	"$ is not bad, but you need more than that to help Shoo achieve his dream ...",
	"To give up, or not to give up? That is the problem. I'm telling you now, $ is not where you should give up!"
]

var good_result = [
	"Hmmm, what's this smell? YOU'RE ON FIIREE! $ pillars Woooow!",
	"OMG, you're really into it! $? See if you can make it to 200 W-W",
	"$ pillars UaU. Did you count them one by one? Or did you fly haha!",
	"$ shows that you're better than most, but that's not enough for Shoo ... he needs to be the best.",
	"You're good! $ is already a very good result, but remember: good is the enemy of great ...",
	"$?? Welcome to the elite league, friend ... I'm so proud of you, but Shoo is not (yet). Prove he is wrong :D",
	"Ahh, that was so cloooose. Maybe next time, hah? $ is not that far from 200!"
]

var legend_result = [
	"$? Oooooo you were almost there .... I'm speechless, try again!",
	"You deserve a reward ... or maybe not yet! $ is close to 200 but not quite there yet ...",
	"$! Don't stop now, I beg you D:  you're so close, Shoo needs you ...",
	"Yoooooou almost did it! I'm proud of you so much ^_^, $ is not far away from 200, go one more time.",
	"$? You're born for this! Make it 200, I believe in you o-o"
]

var impossible_result = [
	"Oooo! How does it feel to be better than the creator of the game? Nice, ha? My best score was 153, and you did $!!",
	"Incredible! $? I don't know what to say Orz Orz Orz. Shoo ows you a lot ...",
	"$? Happy new wife, Shoo! And thank you, my friend, for giving me your valuable time",
	"WTF? I thought 200+ is impossible ... you actually did $?? be proud ;O",
	"History will remember you as a legend. $ is more than excellent, it is the excellence ...",
	"$? You're impossible! YOU DID THE IMPOSSIBLE. Watch out Tom Cruise, a new player is in the game ;)"
]

var messages = [zero_result, bad_result, avg_result, good_result, legend_result, impossible_result]



func get_message() -> String:
	"""Returns the appropriate message based on the player score. No input, output is the 
	message in String format."""
	
	# Select the message list based on the player score
	var applicable_messages
	
	if player_score == 0:
		applicable_messages = messages[0]
	elif player_score < 20:
		applicable_messages = messages[1]
	elif player_score < 50:
		applicable_messages = messages[2]
	elif player_score < 100:
		applicable_messages = messages[3]
	elif player_score < 200:
		applicable_messages = messages[4]
	else:
		applicable_messages = messages[5]
	
	# Randomly select one of the related messages
	var result = applicable_messages[randi() % len(applicable_messages)]
	
	# Personalize the message by using the player score in it
	result = result.replace("$", str(player_score))
	
	if player_score >= 200:  # If player has won, give them the final message
		result += """
		
		Remember, it's not about the victory, but the courage to face the impossible. I'm so proud of you ... 
		
		I hope you enjoyed the journey :)
		- Shayan"""
	
	# Align the text to center using BBCode tags
	result = "[center]"+result+"[/center]"
	
	return result  # Return the final result


func restart() -> void:
	"""This function is called when the user wants to restart the game, and is meant to
	start the main scene and delete all cache and temporary data."""
	
	get_tree().paused = false  # Start the game so player can move
	animation_player.play_backwards("blur")  # Re-do the blurring so it feels natural
	
	get_tree().change_scene_to_file("res://Scenes/main.tscn")  # Change the scene to main scene


func pause() -> void:
	"""This function is called when the user loses, and is meant the 
	show the GAME OVER screen to them."""
	
	get_tree().paused = true  # Pause the game to prevent further movements
	player_score = int(score_bar.text)  # Get the player score from the text_bar
	
	# Access the score.txt file to get the previous result, and update it if necessary
	var file = FileAccess.open("res://score.txt", FileAccess.READ)
	
	if file:  # If the file exists
		best_score = file.get_as_text().to_int()  # Read the content and convert it to int
		file.close()  # Close the file to prevent future errors
	else:
		best_score = 0  # If for any reason the file cannot be opened, assume previous score is zero
	
	best_score = max(best_score, player_score)  # Update the high score
	
	# Update the score.txt file
	file = FileAccess.open("res://score.txt", FileAccess.WRITE) 
	file.store_string(str(best_score))
	file.close()
	
	# Set the text of rainbow high schore label to the new high score
	best_score_label.text = "[center]High: "+str(best_score)+"[/center]"
	best_score_label_fade.text = "[center]High: "+str(best_score)+"[/center]"
	
	
	# Hide health bar and menu to make the GAME OVER screen as simple as possible
	health_bar.hide(); setting_button.hide()
	score_bar.hide(); restart_button.hide()
	setting_menu.queue_free()  # Delete the setting as we'll rebuild it later
	
	
	if (player_score >= 200):  # If the player finished the game
		legend_mode.show(); normal_mode.hide()  # Show different title
		best_score_label.hide();best_score_label_fade.hide()  # Hide the high score
		
		game_finished_audio.play()  # Play the VICTORY audio
	else:  # If the player couldn't make it this time
		legend_mode.hide(); normal_mode.show()  # Show the normal title
		
		game_over_audio.play()  # Play GAME OVER sound
	
	# Increase the volume of background music if the game is not on mute mode
	if not AudioServer.is_bus_mute(music_bus):
		AudioServer.set_bus_volume_db(music_bus, -10)  # Initially it's set to -26db
	
	animation_player.play("blur")  # Player the blur animation


func show_function() -> void:
	"""External scripts call this function to show the game over scene."""
	
	pause()  # Call the pause function to pause the game
	
	message = get_message()  # Get the message
	score_report.text = message  # Set the text to the personalized message 
	
	delay_timer.start()  # Start a 2s timer


func _on_delay_timeout() -> void:
	"""After the game over scene is shown, and 2s timer is finished, this function
	is called to print the message with typing effect."""
	
	delay_timer.stop()  # Stop the timer, as in godot timers don't stop themself!
	
	# Make the final scene more dramatic if the player has finished the game
	if player_score >= 200:
		animation_player.speed_scale = 0.05  # Reduce the speed of typing animation
	
	animation_player.play("score_report")  # Play the typing animation


func show_restart_button() -> void:
	"""This function is called after the message is shown, and will make the restart button appear."""
	
	restart_button.show()  # Show the restart button, but it's not still here
	
	if (player_score < 200):  # If player didn't win yet, play the show_restart animation to fade the button in
		animation_player.play("show_restart")


func _process(_delta: float) -> void:
	"""This function is called on every tick of the game and is used to make the typing effect more 
	realistic using sound effects."""
	
	if cur_chars != score_report.visible_characters:  # If the typing should still continue
		cur_chars = score_report.visible_characters  # Update the current number of characters
		typing_effect.play()  # Play the sound effect
		
		if cur_chars == -1:  # If the typing is finished (don't ask why -1, it's a Godot thing)
			show_restart_button()  # Show the restart button


func _ready() -> void:
	"""This function is called at the beginning of the game, when the player has not
	lost yet, so we just hide everything for now."""
	
	animation_player.play("RESET")  # RESET animation will hide all objects
	legend_mode.hide()  # Hide the legend title


func _on_restart_button_pressed() -> void:
	"""This function is called when the orange restart button is clicked."""
	
	click_button.play()  # Play the button click sound
	await click_button.finished  # Wait until the sound is played completely
	
	restart()  # Call the restart function to restart everything


func _on_high_score_animation_timer_timeout() -> void:
	"""This function is used to give a rainbow effect to the high score label. It
	gradually change the border colour of the high score label to make it seem like a rainbow."""
	
	last_high_score_color += randf_range(0.01, 0.03)  # Change the last hue a little bit
	
	# Prevent the hue from going too high, and make it overflow if that happened
	if last_high_score_color > 1:
		last_high_score_color -= 1
	
	# Create the new border colour using Godot builtin functions
	var new_color = Color.from_hsv(last_high_score_color, 1, 0.8, 0.5)
	
	# Set the new colour to the high score label
	best_score_label.set('theme_override_colors/font_shadow_color', new_color)
