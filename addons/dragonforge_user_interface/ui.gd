extends Node

var _screens: Dictionary[String, Screen]
var _current_screen: Screen

var _history: Array[Screen]

var use_transitions: bool = false

var fade_out_time: float = 0.1
var fade_in_time: float = 0.1
var fade_hold_time: float = 0.1

## Registers a new screen to the UI autoload ensuring only one screen at a time
## is open. (Used by the [Screen] object.)
func register_screen(screen: Screen) -> void:
	_screens[screen.name] = screen


## Opens a new [Screen] and closes the currently open screen.
func open_screen(screen: Screen, save_history: bool = true) -> void:
	if _current_screen:
		if use_transitions:
			_fade_out(_current_screen, fade_out_time)
			await get_tree().create_timer(fade_out_time).timeout
		_current_screen.hide()
		_current_screen.modulate = Color.WHITE
		if save_history:
			_history.append(_current_screen)
	_current_screen = screen
	if use_transitions:
		_current_screen.modulate = Color.TRANSPARENT
		await get_tree().create_timer(fade_hold_time).timeout # pause before coming back
	_current_screen.show()
	if use_transitions:
		_fade_in(_current_screen, fade_in_time)
		await get_tree().create_timer(fade_in_time).timeout


## Opens a new [Screen] by the screen's name and closes the currently open screen.
func open_screen_by_name(screen_name: String, save_history: bool = true) -> void:
	var new_screen: Screen = _screens[screen_name]
	open_screen(new_screen, save_history)


## Opens a new [Screen] by the screen's name without closing the currently open screen.
func open_pop_up_by_name(screen_name: String) -> void:
	_screens[screen_name].show()


## Closes a [Screen] by the screen's name.
func close_screen_by_name(screen_name: String) -> void:
	_screens[screen_name].hide()


## Opens the last [Screen] (for use with "Back" buttons)
func load_last_screen() -> void:
	if not _history.is_empty():
		var tmp: Screen = _history.pop_back()
		if tmp:
			open_screen(tmp, false)


## Clears the history
func clear_history() -> void:
	_history.clear()
	

## Fade in the screen content
func _fade_in(_screen: Screen, t: float) -> void:
	var _tween: Tween = create_tween()
	_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	_tween.tween_property(_screen, "modulate", Color.WHITE, t)
	

## Fade out the screen content:
func _fade_out(_screen: Screen, t: float) -> void:
	var _tween: Tween = create_tween()
	_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	_tween.tween_property(_screen, "modulate", Color.TRANSPARENT, t)
