# ![icon](https://user-images.githubusercontent.com/1023003/39945136-f44d9a6a-552e-11e8-9f86-9e5699e34c30.png) Launchy

Launchy is a plugin which lets you open resources in your preferred external editor.  Associations can be done using the built in configuration dialog, or modify your editor settings directly.

When activated for the first time, Launchy will modify your global editor settings to add an Editors->External category.  A dictionary containing the associations Launchy uses is located there.  It's empty by default, so Launchy also checks for this and spawns the config dialog so you can add some associations for the first time.  From then on, you can access the config dialog by right-clicking the launch button on a supported resource.

![image](https://user-images.githubusercontent.com/1023003/39945324-af921ff8-552f-11e8-95cc-46b233e00a3b.png)


**WARNING:** As of right now, there is a bug in the way Godot 3.0.2 handles popups spawned by an editor plugin which may cause your editor to become unresponsive shortly after closing.  Please be aware of this before launching the config popup.  Normal operation of this plugin once configured should be unaffected.
