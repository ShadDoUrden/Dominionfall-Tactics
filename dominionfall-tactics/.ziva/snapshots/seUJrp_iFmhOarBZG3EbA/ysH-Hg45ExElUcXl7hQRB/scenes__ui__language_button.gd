class_name LanguageButton
extends Button

@export var lang_code: String = "en"
@export var display_name: String = "English"
@export var flag_icon: Texture2D

func _ready() -> void:
	# On nettoie les propriétés par défaut pour utiliser un conteneur personnalisé
	text = ""
	icon = null
	
	# Création d'un conteneur pour centrer l'icône et le texte ensemble
	var hbox = HBoxContainer.new()
	hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE # Important pour cliquer sur le bouton
	hbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER # Centrage horizontal de l'HBox
	hbox.set("theme_override_constants/separation", 15)
	add_child(hbox)
	
	# Ajout du drapeau
	if flag_icon:
		var rect = TextureRect.new()
		rect.texture = flag_icon
		rect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		rect.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		rect.custom_minimum_size = Vector2(48, 32) # Taille de drapeau standard
		hbox.add_child(rect)
	
	# Ajout du nom de la langue
	var label = Label.new()
	label.text = display_name
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hbox.add_child(label)
	
	custom_minimum_size.y = 80
	
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
