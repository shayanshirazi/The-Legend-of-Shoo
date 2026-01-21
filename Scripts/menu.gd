extends CanvasLayer


##########  Onready Variables Initialization  ##########

@onready var health_bar: ProgressBar = $HealthBar
@onready var setting_menu: Control = $SettingMenu



func _on_resume_pressed() -> void:
	"""This function is called when the user presses the setting button."""
	
	setting_menu.show_function()  # Show the menu


func _ready() -> void:
	"""This function is called once at the beginning of the game. Nothing
	special going on here!"""
	
	health_bar.hide()  # Hide the health bar


func take_hit(amount: int) -> void:
	"""Other scripts call this function. It updates the health bar."""
	
	health_bar.show()  # Show the health bar if it's not already visible
	
	health_bar.value -= amount  # Deduct the hit amount from the health bar
