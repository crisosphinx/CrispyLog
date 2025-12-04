# CrispyLog
 A Godot 4.4.x+ based logging tool that works for games and applications, alike. Tool is intended to create reeadable, traceable logs that help track-down common issues in your application while provided verbose logging features.

## How to Use this Plugin

### !! Note, if the settings changed are annoying and you want to revert, de-enable and re-enable the plugin to restore settings to the original settings.

- Download and place into this directory:
  - `res://addons/` so it should look like `res://addons/CrispyLog`
- Go to `Project -> Project Settings -> Plugins`
 - Enable the plugin by checking the `On` checkbox - it will look like below
 -  [x] On | CrispyLog | x.x.x | Jeff Miller
- Go to `General -> CrispyLog`
 - Open `Color Pairs` Dictionary
 - If you don't like a particular color, you can change it here.
- You can change the `Default Print` to which ever classification you might like.
 - Available Enums:
   - `Trace`
   - `Verbose`
   - `Debug`
   - `System`
   - `Info` (Defaults to this)
   - `Success`
   - `Warning`
   - `Error`
   - `Critical`
   - `Fatal`
   - `Assert`
   - `Network`
   - `Performance`
- Once installed you can call the following commands
  - Trace Level
    - `p.t(message: String, obj: Object, file_name_only: bool)`
    - `p.trc(message: String, obj: Object, file_name_only: bool)`
    - `p.trace(message: String, obj: Object, file_name_only: bool)`
  - Verbose Level
    - `p.v(message: String, obj: Object, file_name_only: bool)`
    - `p.vrb(message: String, obj: Object, file_name_only: bool)`
    - `p.verbose(message: String, obj: Object, file_name_only: bool)`
  - Debug Level
    - `p.d(message: String, obj: Object, file_name_only: bool)`
    - `p.dbg(message: String, obj: Object, file_name_only: bool)`
    - `p.debug(message: String, obj: Object, file_name_only: bool)`
  - System Level
    - `p.s(message: String, obj: Object, file_name_only: bool)`
    - `p.sys(message: String, obj: Object, file_name_only: bool)`
    - `p.system(message: String, obj: Object, file_name_only: bool)`
  - Info Level
    - `p.i(message: String, obj: Object, file_name_only: bool)`
    - `p.log(message: String, obj: Object, file_name_only: bool)`
    - `p.info(message: String, obj: Object, file_name_only: bool)`
  - Success Level
    - `p.y(message: String, obj: Object, file_name_only: bool)`
    - `p.yes(message: String, obj: Object, file_name_only: bool)`
    - `p.success(message: String, obj: Object, file_name_only: bool)`
  - Warning Level
    - `p.w(message: String, obj: Object, file_name_only: bool)`
    - `p.wrn(message: String, obj: Object, file_name_only: bool)`
    - `p.warning(message: String, obj: Object, file_name_only: bool)`
  - Error Level
    - `p.e(message: String, obj: Object, file_name_only: bool)`
    - `p.err(message: String, obj: Object, file_name_only: bool)`
    - `p.error(message: String, obj: Object, file_name_only: bool)`
  - Critical Level
    - `p.c(message: String, obj: Object, file_name_only: bool)`
    - `p.crt(message: String, obj: Object, file_name_only: bool)`
    - `p.critical(message: String, obj: Object, file_name_only: bool)`
  - Fatal Level
    - `p.f(message: String, obj: Object, file_name_only: bool)`
    - `p.ftl(message: String, obj: Object, file_name_only: bool)`
    - `p.fatal(message: String, obj: Object, file_name_only: bool)`
  - Assert Level
    - `p.a(message: String, assertion: bool, obj: Object, file_name_only: bool)`
    - `p.asrt(message: String, assertion: bool, obj: Object, file_name_only: bool)`
    - `p.assrt(message: String, assertion: bool, obj: Object, file_name_only: bool)`
  - Network Level
    - `p.n(message: String, obj: Object, file_name_only: bool)`
    - `p.net(message: String, obj: Object, file_name_only: bool)`
    - `p.network(message: String, obj: Object, file_name_only: bool)`
  - Performance Level
    - `p.p(message: String, obj: Object, file_name_only: bool)`
    - `p.prf(message: String, obj: Object, file_name_only: bool)`
    - `p.performance(message: String, obj: Object, file_name_only: bool)`

## How the plugin works

For those who are more tech-saavy...

The plugin installs two globals:
- `sf` for settings functionality
- `p` for print

`sf` is used by all scripts in the plugin to attain the Log Level `enum`erator and Color Pair `Dictionary` keys and values. Any `private` functions or variables are underscored and are provided with callouts in the docstring to not be used directly.

Example:
```gdscript
static func _log_message(message: String,
                         level: sf.LoggingLevel = sf.LoggingLevel.INFO,
                         assertion: bool = true) -> void:
    # ...
```
This function is privatized. You *CAN* use it directly, but I highly recommend not as it will add more code to your project or potentially break currently placed functionality. If you want to use it directly, along with other functions or variables that are privatized in certain scripts, you can either create a `global` to reference the script or place it in the scene and reference that object.

For example, you could create an empty Node, assign the script, call the Node and then call the relative function or variable from another script when referencing that Node.

Example scene:
```
Scene
 |_Node       (named A)
    |_Script  (named log_message.gd) # contains function _log_message(message)
```
```gdscript
# From player.gd script
func _ready() -> void:
    A.LogMessage._log_message("hello world", sf.LoggingLevel.Debug, true)
    # Long winded and requires a lot of set up. 
    # Result displays in a green color:
    # DEBUG	[2025/12/02/02:26:57]	[player: _ready]
    #        hello world
    #
    # vs.
    #
    var date: String = "{year}/{month}/{day}/{hour}_{minute}_{second}".format(
        Time.get_datetime_dict_from_system(true)
    )
    print("DEBUG [%s] [%s] hello world" % [str(date), self.name])
    # Even longer-winded with special coloration. 
    # Result displays in a white color (default):
    # DEBUG [2025/12/2/2_32_55] [player] hello world
    #
    # vs.
    #
    p.d("hello world")
    # Works without having to implement anything special.
    # Result displays in a green color:
    # DEBUG	[2025/12/02/02:26:57]	[player: _ready]
    #        hello world
    #
    p.d("hello world", self)
    # Works without having to implement anything special.
    # Result displays in a green color:
    # DEBUG	[2025/12/02/02:26:57]	[Player1 - player: _ready]
    #        hello world
    #
```

## Logs

Log files save in Documents directory, regardless of system.
- Windows / Posix:
  - `C:\Users\[UserName]\Documents\.logs\[appname]\[year]\[month]\[day]\[hour_minute_second].log`
- Mac / Linux / Unix:
  - `~/Documents/.logs/[appname]/[year]/[month]/[day]/[hour_minute_second].log`
