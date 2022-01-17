tool
extends Button

var plugin #A reference to the EdititorPlugin, provided by `plugin.gd`
var exe="" #String to editor executable
var res    #Reference to the editor's currently selected resource.

var font:DynamicFont

func _ready():
	self.connect("pressed", self, "_on_ToolButton_pressed")
	
	$PopupMenu.connect("index_pressed", self, '_launchSettings')

#	font = get_font("font").duplicate()
#	font.outline_size = 1
#	font.outline_color = ColorN('black', 0.8)
#	self.add_font_override("font", font)
	

#Called by the plugin script once we're injected into the property editor.
func stylize():
	#Get the editor theme style for a hovering menu item.
	#For some reason, trying to copy the default theme won't produce the editor theme we expect,
	#so instead steal the theme from a parent node.
	var style:StyleBoxFlat = get_parent().theme.get_stylebox("MenuHover", "EditorStyles").duplicate()

	style.border_width_bottom = 2
	style.border_width_top = 2
	style.border_blend = true

	style.content_margin_top = 8
	style.content_margin_bottom = 8
	add_stylebox_override("normal", style)
	add_stylebox_override("hover", style)
	add_stylebox_override("focus", style)
	

#For right clicking.
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed == true:
		_launchSettings(0)

#For left clicking.
func _on_ToolButton_pressed():
	if exe == '':
		print('Launchy: Warning, no external editor has been assigned to launch for this resource.')
	elif exe !='' and File.new().file_exists(exe):
		#Get the path to the resource on disk.
		var path = ProjectSettings.globalize_path(res.resource_path)
		OS.execute(exe, [path], false)
	else:  #Path doesn't exist?
		print("Launchy: Warning, couldn't launch external editor ", exe)

#Right-click menu selected
func _launchSettings(idx):
	$Config.popup_centered()
