extends Button

@export var lang_code: String = "en"
@export var display_name: String = "English"

func _ready() -> void:
	text = display_name
	if not is_connected("pressed", Callable(self, "_on_pressed")):
		connect("pressed", Callable(self, "_on_pressed"))

func _on_pressed() -> void:
	print("Langue sélectionnée :", lang_code)
	if Engine.has_singleton("I18nManager"):
		I18nManager.set_locale(lang_code)
