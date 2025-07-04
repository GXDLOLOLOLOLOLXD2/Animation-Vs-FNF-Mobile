package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;
import mobile.substates.MobileControlSelectSubState;

using StringTools;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Animation VS FNF Options', 'Mobile Settings', 'Note Colors', 'Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Animation VS FNF Options':
				removeTouchPad();
				openSubState(new options.AVFSettingsSubState());
			case 'Mobile Settings':
				removeTouchPad();
				openSubState(new options.MobileSettingsSubState());
			case 'Note Colors':
				removeTouchPad();
				openSubState(new options.NotesSubState());
			case 'Controls':
				removeTouchPad();
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				removeTouchPad();
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				removeTouchPad();
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				removeTouchPad();
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				removeTouchPad();
				LoadingState.loadAndSwitchState(new options.NoteOffsetState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create()
	{
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		menuBG = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		menuBG.scale.set(0.622, 0.622);
		menuBG.scrollFactor.set(0, 0);
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.y += 75;
		menuBG.x += 15;
		menuBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true, false);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true, false);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true, false);
		add(selectorRight);

		#if android // credits to FNF BR
		var tipText:FlxText = new FlxText(10, FlxG.height - 24, 0, 'Press X to Go In Controls Menu or Y to Controls Settings', 16);
		tipText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		tipText.borderSize = 2;
		tipText.scrollFactor.set();
		add(tipText);
		#end

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();

		//#if mobile
		addTouchPad("UP_DOWN", "A_B_X_Y");
		//#end
	}

	override function closeSubState()
	{
		super.closeSubState();
		ClientPrefs.saveSettings();
		removeTouchPad();
		addTouchPad("UP_DOWN", "A_B_X_Y");
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UI_UP_P) { // up
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) { // down
			changeSelection(1);
		}

		if (touchPad != null && touchPad.buttonX.justPressed) {
			touchPad.active = touchPad.visible = persistentUpdate = false;
			openSubState(new MobileControlSelectSubState());
		}

		if (touchPad != null && touchPad.buttonY.justPressed) {
			touchPad.active = touchPad.visible = persistentUpdate = false;
			openSubState(new mobile.options.MobileOptionsSubState());
		}

		if (controls.BACK) { // b
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT) { // a
			openSelectedSubstate(options[curSelected]);
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}