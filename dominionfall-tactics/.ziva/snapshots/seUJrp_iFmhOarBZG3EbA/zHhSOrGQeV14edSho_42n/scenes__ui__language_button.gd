class_name LanguageButton
extends Button

@export var lang_code: String = "en"
@export var display_name: String = "English"
@export var flag_icon: Texture2D

func _ready() -> void:
	text = display_name
	if flag_icon:
		icon = flag_icon
		expand_icon = true
	
	alignment = HORIZONTAL_ALIGNMENT_CENTER
	custom_minimum_size.y = 80 # Hauteur plus confortable
	
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)

func _on_pressed() -> void:
	print("Langue sélectionnée :", lang_code)
	# On tente d'accéder à l'Autoload I18nManager
	var i18n = get_node_or_null("/root/I18nManager")
	if i18n:
		i18n.set_locale(lang_code)
	else:
		# Fallback sur Godot TranslationServer
		TranslationServer.set_locale(lang_code)
