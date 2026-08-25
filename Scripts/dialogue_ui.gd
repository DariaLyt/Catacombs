extends CanvasLayer

signal finished

const TypingText = preload("res://Scripts/typing_text.gd")

@onready var panel: PanelContainer = $Panel
@onready var speaker_label: Label = $Panel/Margin/VBox/SpeakerLabel
@onready var body_label: Label = $Panel/Margin/VBox/BodyLabel
@onready var hint_label: Label = $Panel/Margin/VBox/HintLabel

var _lines: PackedStringArray = []
var _index: int = 0
var _on_finish: Callable = Callable()
var _typing: TypingText.State = TypingText.State.new()
var _opened := false


func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS


func start(speaker: String, lines: PackedStringArray, on_finish: Callable = Callable()) -> void:
	_lines = lines
	_index = 0
	_on_finish = on_finish
	_opened = false
	speaker_label.text = speaker
	hint_label.text = "Space / Enter — continue"
	if _lines.is_empty():
		_close()
		return
	show()
	_present_line(_lines[0])


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("ui_select") or event.is_action_pressed("ui_accept"):
		_advance()
		get_viewport().set_input_as_handled()


func _present_line(text: String) -> void:
	if not _opened:
		await TypingText.reveal(body_label, text, _typing)
		_opened = true
	else:
		body_label.text = text


func _advance() -> void:
	if _typing.active:
		TypingText.skip(_typing)
		return
	_index += 1
	if _index >= _lines.size():
		_close()
	else:
		_present_line(_lines[_index])


func _close() -> void:
	hide()
	if _on_finish.is_valid():
		_on_finish.call()
	finished.emit()
