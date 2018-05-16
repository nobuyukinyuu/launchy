tool
extends WindowDialog

var editor_settings  #A reference to global EditorSettings from parent EditorPlugin

#Updates the tree with the latest settings.
func _about_to_show():
	$ConfigItems.populate(editor_settings.get_setting("editors/external/associations"), true)
	pass

func _ready():
	$MarginContainer/btnAdd.connect("pressed",self, "_on_btnAdd_pressed")

	$HBoxOKCancel/OK.connect("pressed", self, "_on_OK_pressed")
	$HBoxOKCancel/Cancel.connect("pressed", self, "_on_Cancel_pressed")
	$HBoxOKCancel/Apply.connect("pressed", self, "_on_Apply_pressed")
	
	#For updating the apply button.
	$ConfigItems.connect('item_edited',self, '_on_ConfigItems_item_edited')
	$ConfigItems.connect('button_pressed',self, '_on_ConfigItems_button_pressed')

	$ConfigItems.set_column_expand(0, true)

	connect("about_to_show",self, "_about_to_show")

#Add an association
func _on_btnAdd_pressed():
	var key = $MarginContainer/LineEditResType.text
	var value = $MarginContainer/LineEditPath.text

	#Check that the association is valid and not blank.
	if key.strip_edges() == "":
		$AcceptDialog.dialog_text = "Resource associations must have a name."
		$AcceptDialog.popup()
		return

	#Check that no duplicate keys exist.  If so, abort.
	for itemInSettings in $ConfigItems.settings.keys():
		if key == itemInSettings:
			$AcceptDialog.dialog_text = "An association with this Resource type already exists.\nPlease edit it from the list below."
			$AcceptDialog.popup()
			return

	print("Launchy:  Adding new association for %s..." % key)

	$ConfigItems.add_row(key,value)
	$ConfigItems.update_setting(key,value)

	$HBoxOKCancel/Apply.disabled = false 

func _on_OK_pressed():
	saveSettingsToEditor()
	$HBoxOKCancel/Apply.disabled = true
	self.visible = false
func _on_Apply_pressed():
	saveSettingsToEditor()
	$HBoxOKCancel/Apply.disabled = true
func _on_Cancel_pressed():
	self.visible = false

func saveSettingsToEditor():
	print("Launchy:  Saving settings...")
	editor_settings.set_setting('editors/external/associations', $ConfigItems.settings)
	#TODO:  Tell EditorPlugin instance that it needs to update its copy of settings
	#		so that it can handle the new types.
	$"..".plugin.updateHandlerSettings()

func _on_ConfigItems_item_edited():
	$HBoxOKCancel/Apply.disabled = false
func _on_ConfigItems_button_pressed(item, column, id):
	$HBoxOKCancel/Apply.disabled = false
