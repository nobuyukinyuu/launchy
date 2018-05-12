tool
extends Tree

#Default map settings
var settings

var load_icon = preload("res://addons/launchy/icon_load.svg")
var trash_icon = preload("res://addons/launchy/icon_remove.svg")

func _ready():
	set_column_title(0, "Resource Type")
	set_column_title(1, "Editor Path")
	set_column_titles_visible(true)
	create_item()

	connect('item_edited', self, '_on_item_edited')
	connect('button_pressed', self, '_on_button_pressed')

#When an item in ConfigItems is edited.
func _on_item_edited():
	var item = get_selected()

#When populating it during a popup with the initial values found in settings.
func populate(dict, clear=false):
	if clear == true:
		self.clear()
		create_item()  #Root

	for key in dict.keys():
		add_row(key, dict[key])
		
func add_row(key, value):
		var p = create_item()
		p.set_text(0, String(key))
		p.set_expand_right(0,true)
#		p.set_editable(0, true)

		p.set_text(1, String(value))
		p.set_editable(1, true)

		p.add_button( 1, load_icon, -1, false, "Load a path to an executable." )
		p.add_button( 0, trash_icon, -1, false, "Removes this association." )

		
#Updates an editor setting in the association dict
func update_setting(key,value):
	settings[key] = value
	pass

# Returns a float or a string depending on the value of instr
func floatstr(instr):
	if instr.strip_edges() == '0':
		return 0
	elif instr == String(instr.to_float()):
		return instr.to_float()
	return instr

#Check to see if the Open or Remove button was pressed in a tree row.
func _on_button_pressed(item, column, id):
	print(item)
	pass