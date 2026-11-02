# GTAV CharSwap Lite

A minimal GTA V ASI plugin that automatically assigns a configured protagonist hash to the current player ped once at startup, after a configurable delay.

This is a stripped-down modification of [Jupiter's Character Swapper ASI / GTAV_CharSwap_Advanced](https://github.com/JupiterKasparov/GTAV_CharSwap_Advanced). It is intended for setups where another mod loads the game with a custom or non-protagonist ped model. Assigning Michael's, Franklin's, or Trevor's internal hash lets that ped use protagonist-related behavior, such as holding cash, while keeping its existing appearance.

## Features

- Automatically assigns the hash selected in the INI file.
- Waits for a configurable startup delay and an active player ped before attempting the assignment.
- Runs once per plugin startup, then finishes.
- No menus, hotkeys, UI notifications, sounds, or transformation effects.
- Leaves model selection to your other mods; Lite does not spawn or swap ped models.

The original mod's character-selection menus, transformation controls, and player-data save/restore logic are not part of Lite's runtime script.

## Installation

1. Install [Script Hook V by Alexander Blade](https://www.dev-c.com/gtav/scripthookv/) and an ASI loader, such as the `dinput8.dll` included with Script Hook V, in your GTA V game folder.
2. Download the compiled plugin from this repository's [Releases](https://github.com/dougieprishpreed/GTAV_CharSwap_Lite/releases), when available.
3. Place `Jupiter_CharSwap_Lite.asi` and `Jupiter_CharSwap_Lite.ini` in the game folder alongside `GTA5.exe`.
4. Configure the INI file, then start Story Mode with the mod that loads your preferred ped model.

Script Hook V is intended for single-player use and does not work in GTA Online. The source repository does not include the compiled ASI.

## Configuration

Edit `Jupiter_CharSwap_Lite.ini` before launching the game:

```ini
[AutoAssign]
PropertiesHash=0x0D7114C9
Delay=18000
```

`PropertiesHash` selects the protagonist identity to assign:

| Character | Model name | PropertiesHash |
| --- | --- | --- |
| Michael | `player_zero` | `0x0D7114C9` |
| Franklin | `player_one` | `0x9B22DBAF` |
| Trevor | `player_two` | `0x9B810FA2` |

`Delay` is measured in milliseconds from the start of the plugin's script. The supplied INI uses **18000 ms (18 seconds)**. Increase it if your other mods need more time to load or select the intended ped. After the delay, Lite waits until a player ped exists and the player is active.

Keep the INI installed and set a valid protagonist hash. If a setting is missing or cannot be parsed, the current source falls back to `PropertiesHash=0` and `Delay=5000`; zero is not a protagonist hash. Integer parsing is provided by Free Pascal's [INI reader](https://www.freepascal.org/docs-html/fcl/inifiles/tcustominifile.readinteger.html), with [hexadecimal notation](https://docs.freepascal.org/docs-html/rtl/sysutils/strtoint.html) supported.

The INI is read once at script startup. Restart the game after changing it.

## Behavior and limitations

Lite makes one hash-assignment attempt after the delay and player checks. It does not monitor later model changes or automatically reapply the hash after a respawn, character switch, or save reload in the same session. Ensure your intended ped is selected before the assignment runs.

The script changes the internal model hash directly in memory using the original project's approach. If its pointer checks fail, it silently skips the write and still finishes; it does not retry or display a success message. This is not a complete protagonist conversion, and compatibility with every ped, mission, mod combination, or GTA V build is not guaranteed.

## Building from source

The plugin is written in Object Pascal for Lazarus / Free Pascal.

1. Open `ScriptHookVAsiPlugin.lpi` in Lazarus with a Free Pascal compiler capable of targeting 64-bit Windows.
2. Build for `x86_64` / `win64`, as configured in the project.
3. The project outputs `Jupiter_CharSwap_Lite.asi`. Install it with the supplied INI as described above.

The runtime entry point is `ScriptHookVAsiPlugin.lpr`, with the inherited `scripthookv.pas` and `natives.pas` bindings. The inherited `menus.pas` file is retained from upstream but is not used by the Lite script. Build artifacts and unrelated experimental projects from the working archive are not included in this source update.

## Credits

- **JupiterKasparov / Jupiter (Chappy Hochmann)** — original Character Swapper source and hash-changing implementation. Thank you for publishing the source and making this modification possible.
- **dougieprishpreed** — simplified automatic startup hash assignment and Lite configuration.
- **Alexander Blade** — Script Hook V.

Original project: [GTAV_CharSwap_Advanced](https://github.com/JupiterKasparov/GTAV_CharSwap_Advanced).
