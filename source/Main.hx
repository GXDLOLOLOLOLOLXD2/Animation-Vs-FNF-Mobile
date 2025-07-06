package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;

import mobile.backend.MobileData;

class Main extends Sprite
{
	var gameWidth:Int = 1280;
	var gameHeight:Int = 720;
	var initialState:Class<FlxState> = TitleState;
	var zoom:Float = -1;
	var framerate:Int = 60;
	var skipSplash:Bool = true;
	var startFullscreen:Bool = false;
	public static var fpsVar:FPS;

	public static function main():Void {
		Lib.current.addChild(new Main());
	}

	public function new() {
		super();

		MobileData.init();

		if (stage != null)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(?E:Event):Void {
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, init);

		setupGame();
	}

	private function setupGame():Void {
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1) {
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Std.int(Math.ceil(stageWidth / zoom));
			gameHeight = Std.int(Math.ceil(stageHeight / zoom));
		}

		#if !debug
		initialState = TitleState;
		#end

		ClientPrefs.loadDefaultKeys();

		// Corrigido: zoom não é argumento aqui!
		addChild(new FlxGame(gameWidth, gameHeight, initialState, framerate, framerate, skipSplash, startFullscreen));

		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);

		if (fpsVar != null)
			fpsVar.visible = ClientPrefs.showFPS;

		#if mobile
		lime.system.System.allowScreenTimeout = ClientPrefs.screensaver;
			#if android
			FlxG.android.preventDefaultKeys = [BACK];
			#end
		#end

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
	}
}
