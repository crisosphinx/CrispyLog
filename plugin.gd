# Copyright 2026 @ Jeff3DAnimation
tool
extends EditorPlugin

# Singletons to load. Do not modify unless you know what you're doing.
var loadSingletonPlugin = {
	# "DontDirectlyUseMe" : "res://addons/CrispyLog/scripts/message_log.gd",
	"sf": "res://addons/CrispyLog/scripts/settings_menu.gd",
	"p":  "res://addons/CrispyLog/scripts/interface_log.gd",
}

func _enter_tree():
	for name in loadSingletonPlugin.keys():
		add_autoload_singleton(name, loadSingletonPlugin[name])
	_register_editor_settings()

func _exit_tree():
	_deregister_editor_settings()
	for name in loadSingletonPlugin.keys():
		remove_autoload_singleton(name)

# Add editor settings.
func _register_editor_settings():
	# House functions elsewhere so we can keep plugin as clean as possible.
	CrispyLogSettings.create_settings()

# Deregister the editor settings / delete them and their values.
func _deregister_editor_settings():
	# House functions elsewhere so we can keep plugin as clean as possible.
	CrispyLogSettings.delete_settings()
