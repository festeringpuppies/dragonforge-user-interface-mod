class_name BackButton extends Button

func _ready() -> void:
	pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	UI.load_last_screen()
	
	
