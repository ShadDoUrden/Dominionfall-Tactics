class_name LanguageButton
extends Button

@export var lang_code: String = "en"
@export var display_name: String = "English"

func _ready() -> void:
	text = display_name
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)

func _on_pressed() -> void:
	print("Langue sélectionnée :", lang_code)
	if Engine.has_singleton("I18nManager"):
		# On accède au singleton directement
		get_node("/root/I18nManager").set_locale(lang_code)
	else:
		# Fallback si ce n'est pas un Autoload mais un singleton Engine (comme suggéré par votre code original)
		# Bien que dans Godot, les Autoloads sont recommandés.
		var i18n = Engine.get_singleton("I18nManager")
		if i18n:
			i18n.set_locale(lang_code)
