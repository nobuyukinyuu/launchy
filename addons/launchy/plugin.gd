#Resource launcher addon by Nobuyuki
#For more stuff check out https://github.com/nobuyukinyuu
tool
extends EditorPlugin

var b # A class member to hold the widget control during the plugin lifecycle
var c # A class member to hold the config dialog during the plugin lifecycle
var interface = get_editor_interface()
var editor_settings = interface.get_editor_settings()
var current_object  #currently selected object in the editor
var settings = editor_settings.get_setting('editors/external/associations')  #Dict

func _enter_tree():
	#Setup the scene instances.
	b = preload("res://addons/launchy/launchbutton.tscn").instance()
	c = b.get_node("Config")
	b.plugin = self 
	c.editor_settings = editor_settings

	add_control_to_container(CONTAINER_PROPERTY_EDITOR_BOTTOM, b)
	b.visible = false

#Setup config popup.
	#This won't work until Godot 3.1, so instead we'll load settings from the control.
#	add_tool_menu_item("Edit Associations", c, callback)
	
	#We add the config dialog to the scene tree so that we can call it.
#	interface.get_editor_viewport().add_child(c, true)
	#Connect popup closing so we can update our handler to the latest associations.
	c.connect('popup_hide', self, '_on_config_popup_closing')

	#Set basic global settings for our new external editor associations.
	if editor_settings.get_setting('editors/external/associations') == null:
		editor_settings.set_setting('editors/external/associations', {})

	var property_info = {
		"name": "editors/external/associations",
		"type": TYPE_DICTIONARY,
		"hint": PROPERTY_HINT_MULTILINE_TEXT,
		"hint_string": "External resource editor associations for Launchy."
	}
	editor_settings.add_property_info(property_info)


	
	if settings.empty() == true:
		print ("Launchy: External editor associations not yet set.")
#		print ("Go to Project->Tools->Launchy: Edit Associations to set some editors.\n")
		c.get_node('./ConfigItems').settings = settings
		launchConfigPopup()
	else:
		print ("Launchy is loaded. Settings are located in Editor Settings->Editors->External->Associations.")
		c.get_node('./ConfigItems').settings = settings


#Called whenever the editor selection changes.
func edit(object):
	current_object = object

#Launchy handles Resources only.
func handles(object):
#	print("launchy handles: ", object)

	#Just checking for any base class here before stopping.
	#When choosing the application to launch, we should probably
	#go through the entire set of keys to check for if an exact class is found.
	for type in settings.keys():
		if object.is_class(type):
			return true
	return false

#What to do when visibility changes.  Called automatically if handles() returns true.
func make_visible(visible):
	if b != null:  
		b.visible = visible
		if visible == true:
			if current_object is Resource:  b.res = current_object
			#Set the launch exe to the most specific class we can get.
			if settings.has(current_object.get_class()):
				b.exe = settings[current_object.get_class()]
			else:  #Exact match not found.  Search for a base class.
				#TODO:  Maybe walk the inheretance tree recursively up to find the
				#       subclass which matches the closest to current_object type
				for type in settings.keys():
					if current_object.is_class(type):
						b.exe = settings[type]

func launchConfigPopup():
	print("Launchy: Modifying associations...")
	settings = editor_settings.get_setting('editors/external/associations')
	c.get_node('./ConfigItems').settings = settings
	c.popup_centered()
func _on_config_popup_closing():
	updateHandlerSettings()

func updateHandlerSettings():
	#Update our settings for the visibility handler.
	settings = editor_settings.get_setting('editors/external/associations')



func _exit_tree():
	# Clean-up of the plugin goes here
	remove_control_from_container(CONTAINER_PROPERTY_EDITOR_BOTTOM, b) 
	b = null