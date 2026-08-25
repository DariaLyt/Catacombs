class_name TypingText

class State:
	var skipped := false
	var active := false

const CHAR_DELAY := 0.04

static func reveal(label: Label, full_text: String, state: State = null, char_delay: float = CHAR_DELAY) -> void:
	if state:
		state.skipped = false
		state.active = true
	label.text = ""
	for i in full_text.length():
		if state and state.skipped:
			label.text = full_text
			state.active = false
			return
		label.text = full_text.substr(0, i + 1)
		# process_always + ignore_pause so typing works during level-transition pause
		await label.get_tree().create_timer(char_delay, true, false, true).timeout
	label.text = full_text
	if state:
		state.active = false


static func skip(state: State) -> void:
	state.skipped = true
