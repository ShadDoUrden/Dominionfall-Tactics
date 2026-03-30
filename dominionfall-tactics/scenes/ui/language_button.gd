class_name LanguageButton
extends Button

@export var lang_code: String = "en"
@export var display_name: String = "English"
@export var flag_icon: Texture2D

func _ready() -> void:
	# On vide le texte et l'icône par défaut pour tout gérer nous-mêmes
	text = ""
	icon = null
	
	# Création d'un conteneur horizontal pour centrer le groupe Drapeau + Texte
	var hbox = HBoxContainer.new()
	hbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER # Centre tout le groupe horizontalement
	hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE # Permet au clic de traverser vers le bouton
	hbox.add_theme_constant_override("separation", 20)
	add_child(hbox)
	
	# Ajout du drapeau
	if flag_icon:
		var rect = TextureRect.new()
		rect.texture = flag_icon
		rect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		rect.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		rect.custom_minimum_size = Vector2(64, 40)
		hbox.add_child(rect)
	
	# Ajout du nom de la langue
	var label = Label.new()
	label.text = display_name
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 24)
	hbox.add_child(label)
	
	# Taille du bouton pour mobile
	custom_minimum_size.y = 70
	
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)

func _on_pressed() -> void:
	# On appelle le gestionnaire de langue
	if I18nManager:
		I18nManager.set_locale(lang_code)
	else:
		TranslationServer.set_locale(lang_code)
	
	# On force la mise à jour immédiate de tous les nœuds de la scène
	get_tree().root.propagate_notification(NOTIFICATION_TRANSLATION_CHANGED)
