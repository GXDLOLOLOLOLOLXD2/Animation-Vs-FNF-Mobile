package options;

/*
 * Based on BaseOptionsMenu.
 * by @GXDLOLOLOLOLOLXD2 and fixed by @azeitona-x7 (youtube)
 */
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

import MusicBeatSubstate;
import Controls;
import ClientPrefs;
import options.Option;
import options.OptionsState;
import options.BaseOptionsMenu;

class MobileSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
        title = 'Mobile Settings';
        #if desktop
		rpcTitle = 'Mobile Preferences'; // For Discord RPC
        #end

        optionsArray = [];

		var extraButtonsOption = new Option('Extra Buttons',
			'Define which extra buttons appear (example: A, B, C...).',
			'extraButtons',
			'string',
			['NONE', 'A', 'AB', 'ABC', 'FULL']);

		var hitboxPosOption = new Option('Hitbox Right Side',
			'Define if the extra hitbox appears on the right side of the screen.',
			'hitboxPos',
			'bool');

		var hitboxTypeOption = new Option('Hitbox Type',
			'Changes the appearance type of the hitbox.',
			'hitboxType',
			'string',
			['Gradient', 'Square', 'Circle', 'None']);

		var controlsAlphaOption = new Option('Control Opacity',
			'Changes the opacity of the touch buttons.\n0.0 is invisible, 0.6 is default, 1.0 is visible.',
			'controlsAlpha',
			'float',
			0.0,
            0.2,
            0.4,
            0.6,
            0.8,
			1.0);

		var screensaverOption = new Option('Screensaver',
			'Enable/Desable the mode of "sleep screen" (when the game are inative).',
			'screensaver',
			'bool');

		addOption(extraButtonsOption);
		addOption(hitboxPosOption);
		addOption(hitboxTypeOption);
		addOption(controlsAlphaOption);
		addOption(screensaverOption);

        super();
	}
}