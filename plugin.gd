# Copyright 2026 @ Jeff3DAnimation
@tool
extends EditorPlugin

## Singletons to load. Do not modify unless you know what you're doing.
var loadSingletonPlugin: Dictionary = {
    # "DontDirectlyUseMe" :   "res://addons/CrispyLog/scripts/message_log.gd",
    "sf"                :   "res://addons/CrispyLog/scripts/settings_menu.gd",
    "p"                 :   "res://addons/CrispyLog/scripts/interface_log.gd",
}

func _enter_tree() -> void:
    for names in loadSingletonPlugin.keys():
        add_autoload_singleton(names, loadSingletonPlugin[names])
    _register_editor_settings()

func _exit_tree() -> void:
    _deregister_editor_settings()
    for names in loadSingletonPlugin.keys():
        remove_autoload_singleton(names)

## Add editor settings.
func _register_editor_settings() -> void:
    # House functions elsewhere so we can keep plugin as clean as possible.
    CrispyLogSettings.create_settings()

## Deregister the editor settings / delete them and their values.
func _deregister_editor_settings() -> void:
    # House functions elsewhere so we can keep plugin as clean as possible.
    CrispyLogSettings.delete_settings()
