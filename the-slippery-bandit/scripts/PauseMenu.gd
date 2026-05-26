# PauseMenu.gd
# Attach to root node of PauseMenu.tscn
# This scene lives INSIDE each level scene, not as a separate scene file.
# Set the PauseMenu node's visibility to hidden by default.
#
# Scene tree layout (inside your Level scene):
#   Level (Node2D)
#   ├── ... (level stuff)
#   └── PauseMenu (CanvasLayer)         ← CanvasLayer keeps it on top of everything
#       └── Panel (Control)
#           ├── PausedLabel (Label)     — "Paused"
#           └── ButtonContainer (VBoxContainer)
#               ├── ResumeButton (Button)    — "Resume"
#               ├── RestartButton (Button)   — "Restart Level"
#               └── MainMenuButton (Button)  — "Main Menu"
#
# In your Level script, call pause_menu.show_pause() / hide_pause()
# OR handle input here directly — both shown below.

extends CanvasLayer

@onready var panel          : Control = $Panel
@onready var resume_button  : Button  = $Panel/ButtonContainer/ResumeButton
@onready var restart_button : Button  = $Panel/ButtonContainer/RestartButton
@onready var menu_button    : Button  = $Panel/ButtonContainer/MainMenuButton

var is_paused: bool = false

func _ready() -> void:
	panel.hide()
	resume_button.pressed.connect(_on_resume_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	menu_button.pressed.connect(_on_menu_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # Esc key by default
		if is_paused:
			_on_resume_pressed()
		else:
			_pause()

func _pause() -> void:
	is_paused = true
	get_tree().paused = true
	panel.show()

func _on_resume_pressed() -> void:
	is_paused = false
	get_tree().paused = false
	panel.hide()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	GameManager.start_level(GameManager.current_level)

func _on_menu_pressed() -> void:
	GameManager.go_to_main_menu()

# Public method so the level script can trigger pause externally if needed
func show_pause() -> void:
	_pause()
