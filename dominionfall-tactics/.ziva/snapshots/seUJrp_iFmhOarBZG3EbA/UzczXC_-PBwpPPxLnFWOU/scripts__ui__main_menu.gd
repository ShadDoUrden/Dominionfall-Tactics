extends Control

func _ready() -> void:
	$MainLayout/Campaign.pressed.connect(_on_campaign_pressed)
	$MainLayout/VSMode.pressed.connect(_on_vs_pressed)
	$MainLayout/MapEditor.pressed.connect(_on_map_editor_pressed)
	$MainLayout/Settings.pressed.connect(_on_settings_pressed)
	$MainLayout/Quit.pressed.connect(_on_quit_pressed)

func _on_campaign_pressed():
	print("Lancement Campagne")

func _on_vs_pressed():
	print("Lancement Mode VS")

func _on_map_editor_pressed():
	print("Lancement Éditeur")

func _on_settings_pressed():
	# Ici on pourrait ouvrir un sous-menu ou revenir à la sélection de langue
	get_tree().change_scene_to_file("res://scenes/ui/lang_select.tscn")

func _on_quit_pressed():
	get_tree().quit()
